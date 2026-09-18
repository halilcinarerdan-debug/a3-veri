-- =====================================================================
-- SIGINT / BAZ İSTASYONU ÜÇGENLEME MOTORU
--
-- İstemci yalnızca "şu an şifreli kanaldan paket gönderiyorum" sinyalini
-- verir (zaman/miktar bilgisi içermez). Tüm fiziksel hesap (konum, RSSI,
-- SNR, üçgenleme güveni, arama çemberi) sunucunun kendi ped konumundan
-- ve sabit kule koordinatlarından türetilir; istemci bu değerleri asla
-- doğrudan besleyemez.
-- =====================================================================

Sigint = {}

local function pathLossRssi(distanceM)
    if distanceM < CONFIG.RF.REFERENCE_DIST_M then distanceM = CONFIG.RF.REFERENCE_DIST_M end
    local pathLoss = CONFIG.RF.REFERENCE_LOSS_DB
        + 10.0 * CONFIG.RF.PATH_LOSS_EXPONENT * math.log(distanceM / CONFIG.RF.REFERENCE_DIST_M, 10)
    return CONFIG.RF.TX_POWER_DBM - pathLoss
end

local function dist3(a, b)
    local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function confidenceBase(nTowers)
    if nTowers >= 3 then return CONFIG.TRIANGULATION.CONFIDENCE_BASE[3] end
    return CONFIG.TRIANGULATION.CONFIDENCE_BASE[nTowers] or 0.0
end

-- Cihazı ajana kaydeder (yalnızca sunucu içi çağrı / export; ağ olayı değildir)
function Sigint.RegisterDevice(identifier, imei, imsi)
    if not Validation.IsValidImei(imei) or not Validation.IsValidImsi(imsi) then
        return false, 'invalid_device_ids'
    end
    local a = Cache.Ensure(identifier)
    a.sigint.imei = imei
    a.sigint.imsi = imsi
    Cache.MarkDirty(identifier)
    return true
end

-- İstemci: "paket gönderiyorum" bildirimi (içerik/konum taşımaz)
RegisterNetEvent('sigint_layer1:packetTransmit', function()
    local src = source
    if Validation.RateLimited(src) then return end

    local identifier = Validation.ResolveIdentifier(src)
    if not identifier then return end

    local a = Cache.Ensure(identifier)
    if not a.sigint.imei then return end -- kayıtlı cihazı olmayan ajan izlenemez

    a.sigint.is_transmitting = true
    a.sigint.last_packet_ms = GetGameTimer()
end)

-- Tek bir ajan için üçgenleme hesabını günceller
local function updateAgentTriangulation(identifier, a, onlineMap, now)
    local s = a.sigint

    if s.is_transmitting and (now - s.last_packet_ms) > CONFIG.TICK.STALE_TRANSMIT_MS then
        s.is_transmitting = false
    end

    local src = onlineMap[identifier]

    if s.is_transmitting and src then
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            local coords = GetEntityCoords(ped)
            local dtSeconds = CONFIG.TICK.SIGINT_MS / 1000.0

            if Validation.PlausibleMovement(s.last_coords, coords, dtSeconds) then
                local hearing = {}
                local weightSum, wx, wy, wz, snrSum = 0.0, 0.0, 0.0, 0.0, 0.0

                for _, tower in ipairs(CONFIG.TOWERS) do
                    local d = dist3(coords, tower.coords)
                    local rssi = pathLossRssi(d)
                    if rssi >= CONFIG.RF.SENSITIVITY_DBM then
                        local snr = rssi - CONFIG.RF.NOISE_FLOOR_DBM
                        hearing[#hearing + 1] = { tower = tower, rssi = rssi, snr = snr, dist = d }
                        local w = 10 ^ (rssi / 10.0)
                        weightSum = weightSum + w
                        wx = wx + tower.coords.x * w
                        wy = wy + tower.coords.y * w
                        wz = wz + tower.coords.z * w
                        snrSum = snrSum + snr
                    end
                end

                local nHearing = #hearing

                if nHearing > 0 then
                    table.sort(hearing, function(x, y) return x.rssi > y.rssi end)

                    local avgSnr = snrSum / nHearing
                    local snrQuality = Validation.ClampNumber(
                        (avgSnr - CONFIG.TRIANGULATION.SNR_FLOOR_DB)
                            / (CONFIG.TRIANGULATION.SNR_CEIL_DB - CONFIG.TRIANGULATION.SNR_FLOOR_DB),
                        CONFIG.TRIANGULATION.SNR_QUALITY_MIN, CONFIG.TRIANGULATION.SNR_QUALITY_MAX)

                    local target = math.min(confidenceBase(nHearing) * snrQuality, CONFIG.TRIANGULATION.CONFIDENCE_MAX_3PLUS)

                    s.triangulation_confidence = s.triangulation_confidence
                        + (target - s.triangulation_confidence) * CONFIG.TRIANGULATION.ACCUMULATION_RATE

                    if weightSum > 0 then
                        s.estimated_centroid = vector3(wx / weightSum, wy / weightSum, wz / weightSum)
                    end
                else
                    s.triangulation_confidence = s.triangulation_confidence * (1.0 - CONFIG.TRIANGULATION.DECAY_RATE)
                end

                s.triangulation_confidence = Validation.ClampNumber(
                    s.triangulation_confidence, 0.0, CONFIG.TRIANGULATION.CONFIDENCE_MAX_3PLUS)

                s.search_radius_m = CONFIG.TRIANGULATION.SEARCH_RADIUS_MIN_M
                    + (CONFIG.TRIANGULATION.SEARCH_RADIUS_MAX_M - CONFIG.TRIANGULATION.SEARCH_RADIUS_MIN_M)
                    * (1.0 - s.triangulation_confidence)

                s.active_towers = hearing
                s.last_coords = coords
                Cache.MarkDirty(identifier)
            end
        end
    elseif s.triangulation_confidence > 0.0 then
        -- yayın yok: güven zamanla söner, ajan "soğur"
        s.triangulation_confidence = Validation.ClampNumber(
            s.triangulation_confidence * (1.0 - CONFIG.TRIANGULATION.DECAY_RATE), 0.0, 1.0)
        s.search_radius_m = CONFIG.TRIANGULATION.SEARCH_RADIUS_MIN_M
            + (CONFIG.TRIANGULATION.SEARCH_RADIUS_MAX_M - CONFIG.TRIANGULATION.SEARCH_RADIUS_MIN_M)
            * (1.0 - s.triangulation_confidence)
        Cache.MarkDirty(identifier)
    end
end

function Sigint.RunTick()
    local onlineMap = Validation.BuildOnlineIdentifierMap()
    local now = GetGameTimer()
    for identifier, a in pairs(Cache.Agents) do
        if a.sigint.imei then
            updateAgentTriangulation(identifier, a, onlineMap, now)
        end
    end
end
