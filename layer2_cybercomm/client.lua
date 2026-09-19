--[[
    KATMAN 2 | CLIENT
    Sorumluluk: NUI koprusu + input kilidi + focus yonetimi.
    Hicbir finansal/adli veri burada uretilmez.
]]

local isUiOpen = false
local focusLock = false

local function SetUiFocus(shouldFocus)
    isUiOpen = shouldFocus
    SetNuiFocus(shouldFocus, shouldFocus)
    SetNuiFocusKeepInput(false)
end

local function OpenApp()
    if isUiOpen then return end
    SetUiFocus(true)
    SendNUIMessage({ action = 'open' })
    TriggerServerEvent('cybercomm:requestSync')
end

local function CloseApp()
    if not isUiOpen then return end
    focusLock = true
    isUiOpen = false
    SendNUIMessage({ action = 'close' })
    SetNuiFocus(false, false)

    -- NUI callback gecikse bile focus'un garanti serbest kalmasi icin emniyet kemeri
    CreateThread(function()
        Wait(60)
        SetNuiFocus(false, false)
        focusLock = false
    end)
end

RegisterKeyMapping('cybercomm_toggle', 'ShadowLine Ac/Kapat', 'keyboard', 'F6')
RegisterCommand('cybercomm_toggle', function()
    if isUiOpen then CloseApp() else OpenApp() end
end, false)

-- Input kilidi + ESC ile kapatma (tek thread, 0ms'e yakin)
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
            Wait(250)
        end
    end
end)

-- ============================================================
-- SIGINT MOBILE TRACKER | Heartbeat
-- Arayuz acik oldugu surece sunucuya "hala baglantidayim" sinyali gonderir.
-- Bu sinyal, sunucu tarafinda Packet_Leak_Ratio'yu besler (bkz. server.lua).
-- Arayuz kapaliyken thread neredeyse hic uyanmaz (0.00ms resmon hedefine sadik).
-- ============================================================
CreateThread(function()
    while true do
        if isUiOpen then
            TriggerServerEvent('cybercomm:heartbeat')
            Wait(3000)
        else
            Wait(1000)
        end
    end
end)

-- Yer tutucu ses varliklari: kendi ses paketinizle (soundset/isim) degistirin.
-- Yanlis/olmayan bir isim verilirse native sessizce hicbir sey calmaz (crash yok).
local SigintSoundSet  = 'DLC_HEIST_HACKING_SNAKE_SOUNDS'
local SigintSoundName = 'Beep'

RegisterNetEvent('cybercomm:sigintProximity', function(data)
    if type(data) ~= 'table' or data.active ~= true then return end
    -- Sinyal avcisi minibus yaklastikca cizirti/parazit efekti tetiklenir.
    PlaySoundFrontend(-1, SigintSoundName, SigintSoundSet, true)
end)

RegisterNetEvent('cybercomm:lockdown', function(payload)
    SendNUIMessage({ action = 'lockdown', data = payload })
end)

-- ============================================================
-- FIZIKSEL DUNYA KATMANI | ORTAK YARDIMCILAR
-- Hem SIGINT minibusu hem de sivil pusu asagidaki ortak yardimcilari kullanir.
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

--- Spawn edilen varliklarin network ID'lerini sunucuya kaydettirir. Oyuncu
--- aniden ayrilirsa (crash/alt+f4), sunucu bu ID'leri baska bir client'a
--- yayinlayarak sahipsiz kalan varliklarin silinmesini saglar (bellek/dunya
--- sizintisi onlemi - bkz. server.lua SpawnedEntities).
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
        -- Bu client'ta hic streamlenmemis/zaten silinmis bir netId icin
        -- NetworkGetEntityFromNetworkId 0 doner; DoesEntityExist ile teyit edilir.
        if handle and handle ~= 0 and DoesEntityExist(handle) then
            SafeDeleteEntity(handle)
        end
    end
end)

-- ============================================================
-- SIGINT MOBILE PED SPAWN (Sinyal Avcisi Minibus) - fiziksel katman
-- Sunucu SADECE "ne zaman/nerede" kararini verir (bkz. server.lua
-- StartSigintHunter). Aracin gercekten olusturulmasi, yol dugumune
-- oturtulmasi ve surus AI'i BURADA, istemci tarafinda calisir.
-- ============================================================

local HunterVehicleModel = 'rumpo'              -- duz/isaretsiz sivil kargo minibusu
local HunterPedModel     = 'a_m_m_business_01'  -- sivil kiyafetli, "dedektif" gorunumlu genel ped
local HunterPatrolSpeed  = 12.0                 -- ~43 km/s, sehir ici gercekci devriye hizi
local HunterDrivingStyle = 786603               -- normal surus: trafige uyar, araclardan kacinir
local HunterMaxLeashMeters = 350.0              -- oyuncu bu kadar uzaklasirsa yerel guvenlik agi devreye girer

local hunterVehicle = nil
local hunterPeds     = {}
local hunterActive   = false

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
    if type(data) ~= 'table' or type(data.coords) ~= 'vector3' then return end
    if hunterActive then return end -- zaten aktif bir avci varken tekrar spawn etme
    hunterActive = true

    CreateThread(function()
        local vehicleHash = GetHashKey(HunterVehicleModel)
        local pedHash      = GetHashKey(HunterPedModel)

        if not LoadModelHash(vehicleHash) or not LoadModelHash(pedHash) then
            hunterActive = false
            return
        end

        local target = data.coords
        -- En yakin yol dugumune otur: minibus havada/binada spawn olmaz.
        local nodeFound, roadCoords = GetClosestVehicleNode(target.x, target.y, target.z, 1, 3.0, 0)
        local finalCoords = nodeFound and roadCoords or target

        local groundFound, groundZ = GetGroundZFor_3dCoord(finalCoords.x, finalCoords.y, finalCoords.z + 5.0, false)
        local spawnZ = groundFound and groundZ or finalCoords.z

        local vehicle = CreateVehicle(vehicleHash, finalCoords.x, finalCoords.y, spawnZ, math.random(0, 359) + 0.0, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleColours(vehicle, 0, 0) -- siyah/siyah, sinsi sivil gorunum
        SetVehicleOnGroundProperly(vehicle)
        SetModelAsNoLongerNeeded(vehicleHash)

        local driver    = CreatePedInsideVehicle(vehicle, 4, pedHash, -1, true, false)
        local passenger = CreatePedInsideVehicle(vehicle, 4, pedHash, 0, true, false)
        SetModelAsNoLongerNeeded(pedHash)

        for _, pedHandle in ipairs({ driver, passenger }) do
            SetEntityAsMissionEntity(pedHandle, true, true)
            SetBlockingOfNonTemporaryEvents(pedHandle, true) -- gorevden sapmasin (kacmasin/meraklanmasin)
        end

        hunterVehicle = vehicle
        hunterPeds    = { driver, passenger }
        NetworkRegisterEntities('hunter', { vehicle, driver, passenger })

        SetDriverAbility(driver, 1.0)
        TaskVehicleDriveToCoordLongrange(driver, vehicle, target.x, target.y, target.z, HunterPatrolSpeed, HunterDrivingStyle, 15.0)

        -- Sinsi devriye dongusu: oyuncunun CANLI konumuna dogru periyodik olarak
        -- yeniden yonlendirilir. Wait(2000) ile 0.00ms resmon hedefi korunur.
        while hunterActive do
            Wait(2000)

            if not DoesEntityExist(vehicle) or not DoesEntityExist(driver) then
                CleanupHunter()
                break
            end

            local playerCoords = GetEntityCoords(PlayerPedId())
            local vehCoords    = GetEntityCoords(vehicle)

            -- Guvenlik agi: sunucunun despawn sinyali herhangi bir sebeple
            -- kaybolursa dahi, asiri uzaklasma durumunda yerel olarak temizlenir.
            if #(playerCoords - vehCoords) > HunterMaxLeashMeters then
                CleanupHunter()
                break
            end

            TaskVehicleDriveToCoordLongrange(driver, vehicle, playerCoords.x, playerCoords.y, playerCoords.z, HunterPatrolSpeed, HunterDrivingStyle, 15.0)
        end
    end)
end)

RegisterNetEvent('cybercomm:despawnHunterVehicle', function()
    CleanupHunter()
end)

-- ============================================================
-- CIV-AMBUSH PHYSICAL REACTION (Sivil Pusu Baskini) - fiziksel katman
-- Honeypot tuzagina parolasiz dusen oyuncuyu 4 NOOSE/SWAT pedi karsilar.
-- ============================================================

local AmbushPedModel      = 'S_M_Y_SWAT_01'
local AmbushWeaponHash    = 'WEAPON_CARBINERIFLE'
local AmbushRadioSoundSet  = 'POLICE_SCANNER_KEYS' -- yer tutucu; kendi ses paketinizle degistirin
local AmbushRadioSoundName = 'Beep'
local AmbushCount          = 4
local AmbushRingMinRadius  = 8.0
local AmbushRingMaxRadius  = 15.0

RegisterNetEvent('cybercomm:triggerAmbush', function(data)
    if type(data) ~= 'table' or type(data.coords) ~= 'vector3' then return end

    CreateThread(function()
        local pedHash    = GetHashKey(AmbushPedModel)
        local weaponHash = GetHashKey(AmbushWeaponHash)

        if not LoadModelHash(pedHash) then return end

        local baseCoords = data.coords
        local ambushPeds = {}

        for i = 1, AmbushCount do
            local angle       = (i / AmbushCount) * 2 * math.pi + (math.random(-20, 20) / 100)
            local ringRadius  = math.random(AmbushRingMinRadius, AmbushRingMaxRadius)
            local px = baseCoords.x + math.cos(angle) * ringRadius
            local py = baseCoords.y + math.sin(angle) * ringRadius

            local groundFound, groundZ = GetGroundZFor_3dCoord(px, py, baseCoords.z + 10.0, false)
            local pz = groundFound and groundZ or baseCoords.z

            local ped = CreatePed(4, pedHash, px, py, pz, 0.0, true, false)
            SetEntityAsMissionEntity(ped, true, true)
            SetPedArmour(ped, 100)
            GiveWeaponToPed(ped, weaponHash, 250, false, true)
            SetPedCombatAbility(ped, 2)     -- Professional
            SetPedCombatMovement(ped, 2)    -- Offensive
            SetPedAccuracy(ped, 65)
            SetBlockingOfNonTemporaryEvents(ped, true)

            ambushPeds[#ambushPeds + 1] = ped
        end

        SetModelAsNoLongerNeeded(pedHash)
        NetworkRegisterEntities('ambush', ambushPeds)

        -- Telsiz anonsu: pusu bolgesinden pozisyonel olarak calinir.
        PlaySoundFromCoord(-1, AmbushRadioSoundName, baseCoords.x, baseCoords.y, baseCoords.z, AmbushRadioSoundSet, false, 0, false)

        Wait(200) -- pedlerin sahneye tam yerlesmesi icin kisa bir emniyet payi

        local playerPed = PlayerPedId()
        for _, ped in ipairs(ambushPeds) do
            if DoesEntityExist(ped) then
                TaskCombatPed(ped, playerPed, 0, 16)
            end
        end

        -- Catisma basladigi an ShotSpotter akustik sensor sinyali sunucuya
        -- iletilir; haritada gosterim/dispatch tepkisi Katman 3'un isidir.
        TriggerServerEvent('cybercomm:reportShotSpotter', baseCoords)

        -- 5 dakika sonra hala hayattaysa mission-entity durumu birakilir; boylece
        -- oyuncu catismadan kacsa dahi pedler sonsuza dek "korumali" kalmaz ve
        -- oyunun kendi dogal ped temizligine devredilir (bellek sizintisi onlenir).
        Wait(5 * 60 * 1000)
        for _, ped in ipairs(ambushPeds) do
            if DoesEntityExist(ped) then
                SetEntityAsMissionEntity(ped, false, false)
            end
        end
        TriggerServerEvent('cybercomm:unregisterSpawnedEntities', 'ambush')
    end)
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

-- POLICE HONEYPOT & CRYPTO-CHALLENGE: oyuncunun ajana gonderdigi gizli
-- guvenlik ifadesi. Dogru/yanlis degerlendirmesi TAMAMEN server.lua'da
-- yapilir; client sadece ham metni tasir.
RegisterNUICallback('sendChallenge', function(data, cb)
    if type(data) == 'table' and type(data.agentId) == 'string' and type(data.phrase) == 'string' then
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

-- Resource yeniden baslatilirsa/durursa aktif SIGINT minibusu hemen temizlenir.
-- (Pusu pedleri gibi kisa omurlu/kendi kapsaminda kalan varliklar icin FiveM
-- zaten bir kaynagin sahip oldugu tum entity'leri resource durdugunda otomatik
-- siler; bu sadece minibus icin ANINDA ve ongorulebilir temizlik saglar.)
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    CleanupHunter()
end)
