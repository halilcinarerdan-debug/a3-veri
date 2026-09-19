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
