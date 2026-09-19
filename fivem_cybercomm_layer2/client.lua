--[[
    KATMAN 2 | CLIENT
    Sorumluluk: NUI koprusu + input kilidi + focus yonetimi + fiziksel dunya.
    Hicbir finansal/adli veri burada uretilmez.

    v1.4.0 revizyonlari (CEF stutter fix):
      - OpenApp: NUI-message-first, focus-later. SendNUIMessage -> 80ms async
        Wait -> SetNuiFocus. CEF'in GPU compositor layer'ini olusturup ilk
        frame'i cizmesine izin verir; mouse kilidi animasyonu bloklamaz.
      - openingGuard: re-entrancy kilidi. F6 spam'inde cift focus imkansiz.
      - Close akisi simetrik hale getirildi (guard reset).

    v1.5.0 revizyonlari (KATMAN 4 :: Illegal GPS Navigasyon Terminali):
      - RegisterNUICallback('setIllegalWaypoint', ...) eklendi. Oyuncunun
        terminale ELLE girdigi Enlem/Boylam degerlerini dogrulayip yerel
        SetNewWaypoint(x, y) native'ini tetikler.
      - Hicbir blip/marker olusturulmaz; sadece GTA V'in kendi "rotaya git"
        cizgisi (radar/minimap) devreye girer. Server'a hicbir istek gitmez;
        bu tamamen istemci-yerel, 0 ms resmon maliyetli bir islemdir.
]]

local isUiOpen      = false
local focusLock     = false
local openingGuard  = false   -- v1.4.0: NUI-message <-> focus senkron kilidi

local function SetUiFocus(shouldFocus)
    isUiOpen = shouldFocus
    SetNuiFocus(shouldFocus, shouldFocus)
    SetNuiFocusKeepInput(false)
end

local function OpenApp()
    if isUiOpen or openingGuard then return end
    openingGuard = true

    -- 1) CEF'e "ac" sinyalini ONCE gonder. Sayfa arka planda render edilsin,
    --    GPU compositor layer'i olussun. Focus bu adimda KILITLENMEZ.
    SendNUIMessage({ action = 'open' })
    TriggerServerEvent('cybercomm:requestSync')

    -- 2) 80ms'lik async emniyet penceresi. Bu sure icinde oyun thread'i
    --    BLOKLANMAZ; SetNuiFocus cagrilmadigi icin fare de serbest kalir.
    --    CEF bu 80ms'de frame buffer'i doldurup ilk paint'i yapar.
    CreateThread(function()
        Wait(80)

        -- Pencere acilana kadar CloseApp cagrildiysa acma islemini iptal et
        if not openingGuard then return end

        SetUiFocus(true)
        openingGuard = false
    end)
end

local function CloseApp()
    if not isUiOpen and not openingGuard then return end

    -- Acilis henuz tamamlanmadiysa: sadece NUI'ye kapatma sinyali gonder
    if openingGuard and not isUiOpen then
        openingGuard = false
        SendNUIMessage({ action = 'close' })
        return
    end

    openingGuard = false
    focusLock    = true
    isUiOpen     = false

    SendNUIMessage({ action = 'close' })
    SetNuiFocus(false, false)

    CreateThread(function()
        Wait(60)
        SetNuiFocus(false, false)
        focusLock = false
    end)
end

RegisterKeyMapping('cybercomm_toggle', 'ShadowLine Ac/Kapat', 'keyboard', 'F6')
RegisterCommand('cybercomm_toggle', function()
    if isUiOpen or openingGuard then CloseApp() else OpenApp() end
end, false)

-- Input kilidi + ESC ile kapatma
CreateThread(function()
    while true do
        if isUiOpen and not focusLock then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 322, true) -- INPUT_FRONTEND_CANCEL (ESC)
            if IsDisabledControlJustReleased(0, 322) then
                CloseApp()
            end
            Wait(0)
        else
            Wait(500) -- UI kapaliyken 500ms; 0.00ms resmon hedefi
        end
    end
end)

-- ============================================================
-- SIGINT MOBILE TRACKER | Heartbeat
-- ============================================================
CreateThread(function()
    while true do
        if isUiOpen then
            TriggerServerEvent('cybercomm:heartbeat')
            Wait(3000)
        else
            Wait(2000)
        end
    end
end)

local SigintSoundSet  = 'DLC_HEIST_HACKING_SNAKE_SOUNDS'
local SigintSoundName = 'Beep'

RegisterNetEvent('cybercomm:sigintProximity', function(data)
    if type(data) ~= 'table' or data.active ~= true then return end
    PlaySoundFrontend(-1, SigintSoundName, SigintSoundSet, true)
end)

RegisterNetEvent('cybercomm:lockdown', function(payload)
    SendNUIMessage({ action = 'lockdown', data = payload })
end)

-- ============================================================
-- FIZIKSEL DUNYA KATMANI | ORTAK YARDIMCILAR
-- ============================================================

local function LoadModelHash(modelHash)
    if not IsModelValid(modelHash) then return false end
    RequestModel(modelHash)
    local attempts = 0
    while not HasModelLoaded(modelHash) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    return HasModelLoaded(modelHash)
end

local function SafeDeleteEntity(entity)
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

local function IsValidCoords(c)
    if type(c) ~= 'vector3' then return false end
    if c.x ~= c.x or c.y ~= c.y or c.z ~= c.z then return false end
    if math.abs(c.x) > 1e5 or math.abs(c.y) > 1e5 or math.abs(c.z) > 1e5 then return false end
    return true
end

local function RaycastGroundZ(x, y, zStart, zEnd)
    local ray = StartShapeTestRay(x, y, zStart, x, y, zEnd, 1, 0, 4)
    local retval, hit, endCoords = GetShapeTestResult(ray)
    if retval == 1 and hit and endCoords then
        return endCoords.z
    end
    return nil
end

local function SafeGroundZ(x, y, zHint)
    local hint = tonumber(zHint) or 0.0

    local rayZ = RaycastGroundZ(x, y, hint + 60.0, hint - 120.0)
    if rayZ and rayZ == rayZ and rayZ > -100.0 then
        return rayZ
    end

    local found, nativeZ = GetGroundZFor_3dCoord(x, y, hint + 60.0, false)
    if found and nativeZ and nativeZ == nativeZ and nativeZ > -100.0 then
        return nativeZ
    end

    return math.max(-50.0, math.min(3000.0, hint))
end

local function SafeVehicleNode(target)
    if not IsValidCoords(target) then return nil, nil end

    local found, nodeCoords, nodeHeading =
        GetClosestVehicleNode(target.x, target.y, target.z, 1, 3.0, 0)

    if not found or not nodeCoords then
        found, nodeCoords, nodeHeading =
            GetClosestVehicleNode(target.x, target.y, target.z, 1, 30.0, 0)
    end
    if not found or not nodeCoords then
        found, nodeCoords, nodeHeading =
            GetClosestVehicleNode(target.x, target.y, target.z, 1, 100.0, 0)
    end

    if found and nodeCoords then
        return nodeCoords, (nodeHeading or 0.0)
    end
    return nil, nil
end

local function NetworkRegisterEntities(category, entityHandles)
    local netIds = {}
    for _, handle in ipairs(entityHandles) do
        if DoesEntityExist(handle) then
            netIds[#netIds + 1] = NetworkGetNetworkIdFromEntity(handle)
        end
    end
    if #netIds > 0 then
        TriggerServerEvent('cybercomm:registerSpawnedEntities', category, netIds)
    end
end

RegisterNetEvent('cybercomm:forceDeleteNetworkEntities', function(netIds)
    if type(netIds) ~= 'table' then return end
    for _, netId in ipairs(netIds) do
        local handle = NetworkGetEntityFromNetworkId(netId)
        if handle and handle ~= 0 and DoesEntityExist(handle) then
            SafeDeleteEntity(handle)
        end
    end
end)

-- ============================================================
-- SIGINT MOBILE PED SPAWN (Sinyal Avcisi Minibus)
-- ============================================================

local HunterVehicleModel   = 'rumpo'
local HunterPedModel       = 'a_m_m_business_01'
local HunterPatrolSpeed    = 12.0
local HunterDrivingStyle   = 786603
local HunterMaxLeashMeters = 350.0
local HunterRetargetMeters = 8.0

local hunterVehicle = nil
local hunterPeds    = {}
local hunterActive  = false

local function CleanupHunter()
    hunterActive = false
    for _, pedHandle in ipairs(hunterPeds) do
        SafeDeleteEntity(pedHandle)
    end
    hunterPeds = {}
    SafeDeleteEntity(hunterVehicle)
    hunterVehicle = nil
    TriggerServerEvent('cybercomm:unregisterSpawnedEntities', 'hunter')
end

RegisterNetEvent('cybercomm:spawnHunterVehicle', function(data)
    if type(data) ~= 'table' or not IsValidCoords(data.coords) then return end
    if hunterActive then return end
    hunterActive = true

    CreateThread(function()
        local vehicleHash = GetHashKey(HunterVehicleModel)
        local pedHash     = GetHashKey(HunterPedModel)

        if not LoadModelHash(vehicleHash) or not LoadModelHash(pedHash) then
            hunterActive = false
            return
        end

        local target = data.coords

        local nodeCoords, nodeHeading = SafeVehicleNode(target)
        local spawnX, spawnY
        if nodeCoords then
            spawnX, spawnY = nodeCoords.x, nodeCoords.y
        else
            spawnX, spawnY = target.x, target.y
        end

        local spawnZ  = SafeGroundZ(spawnX, spawnY, target.z)
        local heading = nodeHeading or (math.random(0, 359) + 0.0)

        local vehicle = CreateVehicle(vehicleHash, spawnX, spawnY, spawnZ, heading, true, false)
        if not vehicle or vehicle == 0 then
            hunterActive = false
            SetModelAsNoLongerNeeded(vehicleHash)
            SetModelAsNoLongerNeeded(pedHash)
            return
        end

        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleColours(vehicle, 0, 0)
        SetVehicleOnGroundProperly(vehicle)
        SetModelAsNoLongerNeeded(vehicleHash)

        local driver    = CreatePedInsideVehicle(vehicle, 4, pedHash, -1, true, false)
        local passenger = CreatePedInsideVehicle(vehicle, 4, pedHash, 0, true, false)
        SetModelAsNoLongerNeeded(pedHash)

        for _, pedHandle in ipairs({ driver, passenger }) do
            SetEntityAsMissionEntity(pedHandle, true, true)
            SetBlockingOfNonTemporaryEvents(pedHandle, true)
        end

        hunterVehicle = vehicle
        hunterPeds    = { driver, passenger }
        NetworkRegisterEntities('hunter', { vehicle, driver, passenger })

        SetDriverAbility(driver, 1.0)
        TaskVehicleDriveToCoordLongrange(driver, vehicle,
            target.x, target.y, target.z,
            HunterPatrolSpeed, HunterDrivingStyle, 15.0)

        local lastTargetCoords = target

        while hunterActive do
            Wait(2000)

            if not DoesEntityExist(vehicle) or not DoesEntityExist(driver) then
                CleanupHunter()
                break
            end

            local playerCoords = GetEntityCoords(PlayerPedId())
            local vehCoords    = GetEntityCoords(vehicle)

            if #(playerCoords - vehCoords) > HunterMaxLeashMeters then
                CleanupHunter()
                break
            end

            if #(playerCoords - lastTargetCoords) > HunterRetargetMeters then
                TaskVehicleDriveToCoordLongrange(driver, vehicle,
                    playerCoords.x, playerCoords.y, playerCoords.z,
                    HunterPatrolSpeed, HunterDrivingStyle, 15.0)
                lastTargetCoords = playerCoords
            end
        end
    end)
end)

RegisterNetEvent('cybercomm:despawnHunterVehicle', function()
    CleanupHunter()
end)

-- ============================================================
-- CIV-AMBUSH PHYSICAL REACTION (Sivil Pusu Baskini)
-- ============================================================

local AmbushPedModel       = 'S_M_Y_SWAT_01'
local AmbushWeaponHash     = 'WEAPON_CARBINERIFLE'
local AmbushRadioSoundSet  = 'POLICE_SCANNER_KEYS'
local AmbushRadioSoundName = 'Beep'
local AmbushCount          = 4
local AmbushRingMinRadius  = 8.0
local AmbushRingMaxRadius  = 15.0

RegisterNetEvent('cybercomm:triggerAmbush', function(data)
    if type(data) ~= 'table' or not IsValidCoords(data.coords) then return end

    CreateThread(function()
        local pedHash    = GetHashKey(AmbushPedModel)
        local weaponHash = GetHashKey(AmbushWeaponHash)

        if not LoadModelHash(pedHash) then return end

        local baseCoords = data.coords
        local ambushPeds = {}

        for i = 1, AmbushCount do
            local angle      = (i / AmbushCount) * 2 * math.pi + (math.random(-20, 20) / 100)
            local ringRadius = AmbushRingMinRadius
                             + math.random() * (AmbushRingMaxRadius - AmbushRingMinRadius)

            local px = baseCoords.x + math.cos(angle) * ringRadius
            local py = baseCoords.y + math.sin(angle) * ringRadius
            local pz = SafeGroundZ(px, py, baseCoords.z)

            local ped = CreatePed(4, pedHash, px, py, pz, 0.0, true, false)
            if ped and ped ~= 0 then
                SetEntityAsMissionEntity(ped, true, true)
                SetPedArmour(ped, 100)
                GiveWeaponToPed(ped, weaponHash, 250, false, true)
                SetPedCombatAbility(ped, 2)
                SetPedCombatMovement(ped, 2)
                SetPedAccuracy(ped, 65)
                SetBlockingOfNonTemporaryEvents(ped, true)
                ambushPeds[#ambushPeds + 1] = ped
            end
        end

        SetModelAsNoLongerNeeded(pedHash)

        if #ambushPeds == 0 then return end

        NetworkRegisterEntities('ambush', ambushPeds)

        PlaySoundFromCoord(-1, AmbushRadioSoundName,
            baseCoords.x, baseCoords.y, baseCoords.z,
            AmbushRadioSoundSet, false, 0, false)

        Wait(200)

        local playerPed = PlayerPedId()
        for _, ped in ipairs(ambushPeds) do
            if DoesEntityExist(ped) then
                TaskCombatPed(ped, playerPed, 0, 16)
            end
        end

        -- ShotSpotter sinyali SUNUCU tarafindan yayinlanir (client'tan asla).

        Wait(5 * 60 * 1000)
        for _, ped in ipairs(ambushPeds) do
            if DoesEntityExist(ped) then
                SetEntityAsMissionEntity(ped, false, false)
            end
        end
        TriggerServerEvent('cybercomm:unregisterSpawnedEntities', 'ambush')
    end)
end)

-- ============================================================
-- KATMAN 4 :: ILLEGAL GPS NAVIGASYON TERMINALI
-- ============================================================
--[[
    Dogrudan HARITA/BLIP entegrasyonu degildir. GTA V'in orijinal Pause
    Menu haritasi EXIF enlem/boylam degerlerini gostermedigi icin, oyuncu
    bu degerleri (ajanin mesajindan veya EXIF panelinden) ELLE terminale
    girer. Tek yapilan sey yerel SetNewWaypoint(x, y) native'ini
    tetiklemektir -- bu da GTA V'nin kendi radar/minimap rota cizgisini
    (sivil sat-nav gorunumu) aktif eder. Hicbir blip/marker YARATILMAZ,
    sunucuya hicbir istek gitmez: tamamen istemci-yerel, senkron, 0 ms
    resmon maliyetli bir NUI callback'tir.
]]
local IllegalGpsWorldBound = 8000.0 -- GTA V oyun dunyasi X/Y sinirinin cok uzerinde bir guvenlik payi

local function IsValidRouteNumber(n)
    return type(n) == 'number' and n == n and math.abs(n) <= IllegalGpsWorldBound
end

RegisterNUICallback('setIllegalWaypoint', function(data, cb)
    if type(data) ~= 'table' then
        cb({ ok = false, reason = 'bad_payload' })
        return
    end

    local lat = tonumber(data.lat) -- EXIF "Enlem" = oyun dunyasi X ekseni
    local lon = tonumber(data.lon) -- EXIF "Boylam" = oyun dunyasi Y ekseni

    if not IsValidRouteNumber(lat) or not IsValidRouteNumber(lon) then
        cb({ ok = false, reason = 'invalid_coords' })
        return
    end

    SetNewWaypoint(lat, lon)

    cb({ ok = true })
end)

-- ============ NUI CALLBACK'LERI ============
RegisterNUICallback('close', function(_, cb)
    CloseApp()
    cb({ ok = true })
end)

RegisterNUICallback('requestSync', function(_, cb)
    TriggerServerEvent('cybercomm:requestSync')
    cb({ ok = true })
end)

RegisterNUICallback('markRead', function(data, cb)
    if type(data) == 'table' and type(data.messageId) == 'string' then
        TriggerServerEvent('cybercomm:markRead', data.messageId)
    end
    cb({ ok = true })
end)

RegisterNUICallback('claimDeadDrop', function(data, cb)
    if type(data) == 'table' and type(data.messageId) == 'string' then
        TriggerServerEvent('cybercomm:claimDeadDrop', data.messageId)
    end
    cb({ ok = true })
end)

RegisterNUICallback('sendChallenge', function(data, cb)
    if type(data) == 'table'
       and type(data.agentId) == 'string'
       and type(data.phrase)  == 'string' then
        TriggerServerEvent('cybercomm:sendChallenge', data.agentId, data.phrase)
    end
    cb({ ok = true })
end)

-- ============ SERVER -> NUI ============
RegisterNetEvent('cybercomm:syncState', function(payload)
    SendNUIMessage({ action = 'syncState', data = payload })
end)

RegisterNetEvent('cybercomm:newMessage', function(msg)
    SendNUIMessage({ action = 'newMessage', data = msg })
end)

RegisterNetEvent('cybercomm:newDeadDrop', function(msg)
    SendNUIMessage({ action = 'newDeadDrop', data = msg })
end)

RegisterNetEvent('cybercomm:walletUpdate', function(payload)
    SendNUIMessage({ action = 'walletUpdate', data = payload })
end)

RegisterNetEvent('cybercomm:notify', function(data)
    SendNUIMessage({ action = 'notify', data = data })
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    CleanupHunter()
end)
