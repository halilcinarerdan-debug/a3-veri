--[[
    cbrn_simulation.lua
    Kapali hacim gaz konsantrasyonu (PPM) kutle dengesi simulasyonu,
    maruziyet/asfiksi hasar egrisi ve kalici kontaminasyon kaydi.

    Kutle dengesi:  dC/dt = (G - Q * C) / V
      G = uretim/sizinti hizi (ppm * m3 / s)
      Q = havalandirma degisim hizi (m3 / s)
      V = odanin hacmi (m3)
      C = konsantrasyon (PPM)
]]

CBRNSimulation = {}

local Rooms = {}
local PlayerGasMask = {}
local PlayerExposure = {}

local function clamp(v, lo, hi)
    if v < lo then return lo elseif v > hi then return hi end
    return v
end

local function GetRoom(roomId)
    if not Rooms[roomId] then
        local volume = 220.0
        for _, def in pairs(Config.Reactors) do
            if def.interiorId == roomId then
                volume = def.ventVolumeM3
                break
            end
        end

        Rooms[roomId] = {
            ppm = 0.0,
            pendingGeneration = 0.0,
            ventilationOn = false,
            volumeM3 = volume,
            contaminated = false,
            originCoords = nil,
        }
    end
    return Rooms[roomId]
end

function CBRNSimulation.RegisterLeak(roomId, fluxPpmM3PerSec, gasType)
    local room = GetRoom(roomId)
    room.pendingGeneration = room.pendingGeneration + fluxPpmM3PerSec
    room.lastGasType = gasType
end

function CBRNSimulation.SetVentilation(roomId, state)
    GetRoom(roomId).ventilationOn = state and true or false
end

function CBRNSimulation.MarkExplosionOrigin(roomId, coords)
    GetRoom(roomId).originCoords = coords
end

function CBRNSimulation.GetRoomPpm(roomId)
    local room = Rooms[roomId]
    return room and room.ppm or 0.0
end

function CBRNSimulation.ToggleGasMask(playerId, equipped)
    PlayerGasMask[playerId] = equipped and true or false
end

function CBRNSimulation.IsGasMaskEquipped(playerId)
    return PlayerGasMask[playerId] == true
end

-- Bir oyuncu ayni anda yalnizca TEK bir odaya atfedilir (ilk eslesen
-- reaktor odasi). Onceki tasarimda her oda her oyuncuyu bagimsiz
-- degerlendiriyordu; iki reaktor odasi birbirine yakinsa (< 15m) bu,
-- ayni oyuncunun maruziyet sayacinin bir odadan digerine her tick
-- sifirlanmasina yol aciyordu. Tek-gecis (player-centric) tasarim bunu
-- yapisal olarak imkansiz kilar.
local function FindPlayerRoomId(ped)
    local pc = GetEntityCoords(ped)
    for _, def in pairs(Config.Reactors) do
        local dx, dy, dz = pc.x - def.coords.x, pc.y - def.coords.y, pc.z - def.coords.z
        if (dx * dx + dy * dy + dz * dz) <= (15.0 * 15.0) then
            return def.interiorId
        end
    end
    return nil
end

-- Katman 2 (layer2_cybercomm) adli takip hattina rapor gonderir.
-- Fire-and-forget: kaynak yoksa olay sadece yerel MariaDB kaydinda kalir.
local function ReportForensicDecay(roomId, coords, ppmPeak)
    if GetResourceState(Config.Bridge.Layer2Resource) == 'started' then
        TriggerEvent('layer2_cybercomm:forensics:reportDecayEvent', {
            source = 'layer3_industrial_chem',
            interiorId = roomId,
            coords = { x = coords.x, y = coords.y, z = coords.z },
            ppmPeak = ppmPeak,
            eventType = 'cbrn_contamination',
        })
    end

    exports.oxmysql:execute(
        'UPDATE layer3_contamination_zones SET forensic_reported_at = NOW() WHERE interior_id = ? ORDER BY id DESC LIMIT 1',
        { roomId }
    )
end

local function ContaminateZone(roomId, room)
    if room.contaminated then return end
    room.contaminated = true

    local coords = room.originCoords
    if not coords then
        for _, def in pairs(Config.Reactors) do
            if def.interiorId == roomId then coords = def.coords break end
        end
    end
    coords = coords or vec3(0.0, 0.0, 0.0)

    exports.oxmysql:execute([[
        INSERT INTO layer3_contamination_zones
            (interior_id, pos_x, pos_y, pos_z, radius, ppm_peak, created_at)
        VALUES (?, ?, ?, ?, ?, ?, NOW())
    ]], { roomId, coords.x, coords.y, coords.z, Config.CBRN.contaminationRadius, room.ppm })

    ReportForensicDecay(roomId, coords, room.ppm)
end

local function EvaluatePlayerExposure(playerId, ped, dtSeconds)
    local roomId = FindPlayerRoomId(ped)
    if not roomId then
        PlayerExposure[playerId] = nil
        return
    end

    local room = Rooms[roomId]
    local ppm = room and room.ppm or 0.0
    local protected = CBRNSimulation.IsGasMaskEquipped(playerId)

    if ppm >= Config.CBRN.dangerousPpm and not protected then
        local exp = PlayerExposure[playerId]
        if not exp or exp.roomId ~= roomId then
            exp = { roomId = roomId, seconds = 0.0 }
        end
        exp.seconds = exp.seconds + dtSeconds
        PlayerExposure[playerId] = exp

        -- Kimyasal akciger odemi ilerleme egrisi: erken hafif,
        -- 120. saniyeye dogru hizlanan (ustel) hasar.
        local fraction = clamp(exp.seconds / Config.CBRN.lethalExposureSeconds, 0.0, 1.0)
        local damageFraction = fraction ^ 1.6
        local health = math.floor(200 * (1.0 - damageFraction))
        SetEntityHealth(ped, math.max(0, health))

        TriggerClientEvent('layer3_industrial_chem:client:gasExposureEffect', playerId, {
            severity = fraction,
            ppm = ppm,
        })

        if exp.seconds >= Config.CBRN.lethalExposureSeconds then
            SetEntityHealth(ped, 0)
            ContaminateZone(roomId, room)
            PlayerExposure[playerId] = nil
        end
    elseif ppm >= Config.CBRN.irritantPpm and not protected then
        TriggerClientEvent('layer3_industrial_chem:client:gasExposureEffect', playerId, {
            severity = 0.15,
            ppm = ppm,
        })
        PlayerExposure[playerId] = nil
    else
        PlayerExposure[playerId] = nil
    end
end

function CBRNSimulation.Tick(dtSeconds)
    for _, room in pairs(Rooms) do
        local qM3PerMin = room.ventilationOn and Config.CBRN.activeVentilationM3PerMin or Config.CBRN.naturalInfiltrationM3PerMin
        local qM3PerSec = qM3PerMin / 60.0

        local dppm = ((room.pendingGeneration - qM3PerSec * room.ppm) / room.volumeM3) * dtSeconds
        room.ppm = math.max(0.0, room.ppm + dppm)
        room.pendingGeneration = 0.0 -- her tick reaktor tarafindan yeniden beslenir
    end

    for _, playerId in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 then
            EvaluatePlayerExposure(playerId, ped, dtSeconds)
        end
    end
end

CreateThread(function()
    local tick = Config.CBRN.tickMs
    while true do
        Wait(tick)
        CBRNSimulation.Tick(tick / 1000.0)
    end
end)
