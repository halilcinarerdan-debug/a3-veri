-- =====================================================================
-- SUNUCU TARAFI DOĞRULAMA / ANTI-CHEAT
-- Kritik prensip: hiçbir istemci (client) girdisi, adli/biyometrik/sinyal
-- verisini doğrudan belirleyemez. Konum, RSSI, üçgenleme ve itiraf
-- olasılığı gibi tüm hassas değerler yalnızca sunucu tarafında,
-- sunucunun kendi entity/zaman verisinden hesaplanır.
-- =====================================================================

Validation = {}

local eventCounters = {} -- [src] = { count = n, windowStart = ms }

-- Bir oyuncunun event tetikleme sıklığını sınırlar (paket/injector spam koruması)
function Validation.RateLimited(src)
    local t = GetGameTimer()
    local c = eventCounters[src]
    if not c or (t - c.windowStart) > 60000 then
        eventCounters[src] = { count = 1, windowStart = t }
        return false
    end
    c.count = c.count + 1
    return c.count > CONFIG.VALIDATION.MAX_EVENTS_PER_MIN
end

-- Framework-bağımsız kimlik çözümleme: FiveM lisans kimliğini kullanır.
-- ESX/QBCore/vRP gibi bir karakter kimliğine ihtiyaç duyulursa bu
-- fonksiyon tek değişim noktasıdır.
function Validation.ResolveIdentifier(src)
    local identifiers = GetPlayerIdentifiers(src)
    if not identifiers then return nil end
    for _, id in ipairs(identifiers) do
        if string.sub(id, 1, 8) == 'license:' then
            return id
        end
    end
    return nil
end

-- Çevrimiçi tüm oyuncular için identifier -> source haritası çıkarır.
-- Tek seferde inşa edilip döngü boyunca yeniden kullanılır (CPU tasarrufu).
function Validation.BuildOnlineIdentifierMap()
    local map = {}
    for _, srcStr in ipairs(GetPlayers()) do
        local src = tonumber(srcStr)
        local id = Validation.ResolveIdentifier(src)
        if id then map[id] = src end
    end
    return map
end

-- İki ölçüm arası mesafe/zaman oranı fiziksel olarak makul mü?
function Validation.PlausibleMovement(prevCoords, currentCoords, dtSeconds)
    if not prevCoords or dtSeconds <= 0 then return true end
    local dx = currentCoords.x - prevCoords.x
    local dy = currentCoords.y - prevCoords.y
    local dz = currentCoords.z - prevCoords.z
    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
    return (dist / dtSeconds) <= CONFIG.VALIDATION.MAX_SPEED_MPS
end

function Validation.ClampNumber(n, min, max)
    if type(n) ~= 'number' or n ~= n then return min end
    if n < min then return min end
    if n > max then return max end
    return n
end

-- IMEI için standart Luhn sağlama algoritması
function Validation.IsValidImei(imei)
    if type(imei) ~= 'string' or #imei ~= 15 or not imei:match('^%d+$') then
        return false
    end
    local sum = 0
    for i = 1, 15 do
        local d = tonumber(imei:sub(i, i))
        if i % 2 == 0 then
            d = d * 2
            if d > 9 then d = d - 9 end
        end
        sum = sum + d
    end
    return (sum % 10) == 0
end

function Validation.IsValidImsi(imsi)
    return type(imsi) == 'string' and #imsi == 15 and imsi:match('^%d+$') ~= nil
end
