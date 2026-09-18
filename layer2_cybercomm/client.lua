--[[
    KATMAN 2 | CLIENT
    ShadowLine :: Siber Suc Haberlesme Arayuzu (NUI Koprusu)

    Sorumluluk sinirlari:
    - Bu dosya SADECE arayuzu acip/kapatir ve sunucu <-> NUI arasinda mesaj tasir.
    - Hicbir finansal (cuzdan), adli (EXIF) veya biyometrik (kortizol) veri burada
      HESAPLANMAZ. Tum gercek veri sunucu taraflidir (bkz. server.lua) - istemci
      tarafi manipulasyona acik oldugu icin kaynak-of-truth asla client degildir.
]]

local isUiOpen = false

local function SetUiFocus(shouldFocus)
    isUiOpen = shouldFocus
    SetNuiFocus(shouldFocus, shouldFocus)
end

local function OpenApp()
    if isUiOpen then return end
    SetUiFocus(true)
    SendNUIMessage({ action = 'open' })
    TriggerServerEvent('cybercomm:requestSync')
end

local function CloseApp()
    if not isUiOpen then return end
    SetUiFocus(false)
    SendNUIMessage({ action = 'close' })
end

-- Standalone tus baglamasi (INPUT_PHONE natifi yerine gecen saf FiveM API cozumu)
RegisterKeyMapping('cybercomm_toggle', 'ShadowLine Haberlesme Arayuzunu Ac/Kapat', 'keyboard', 'F6')
RegisterCommand('cybercomm_toggle', function()
    if isUiOpen then
        CloseApp()
    else
        OpenApp()
    end
end, false)

-- Arayuz acikken oyun kontrollerini kilitle, arka plandaki oyunu "bulanik" birakma
CreateThread(function()
    while true do
        if isUiOpen then
            DisableControlAction(0, 1, true)   -- INPUT_LOOK_LR
            DisableControlAction(0, 2, true)   -- INPUT_LOOK_UD
            DisableControlAction(0, 24, true)  -- INPUT_ATTACK
            DisableControlAction(0, 25, true)  -- INPUT_AIM
            DisableControlAction(0, 106, true) -- INPUT_VEH_MOUSE_CONTROL_OVERRIDE
            Wait(0)
        else
            Wait(250)
        end
    end
end)

RegisterNUICallback('close', function(_, cb)
    CloseApp()
    cb({ ok = true })
end)

RegisterNUICallback('requestSync', function(_, cb)
    TriggerServerEvent('cybercomm:requestSync')
    cb({ ok = true })
end)

-- Oyuncu bir mesaji "okundu" isaretlerse dahi bu bilgi sunucuya danisilarak
-- yazilir; NUI'nin dogrudan sunucu state'ini degistirmesine izin verilmez.
RegisterNUICallback('markRead', function(data, cb)
    if type(data) == 'table' and type(data.messageId) == 'string' then
        TriggerServerEvent('cybercomm:markRead', data.messageId)
    end
    cb({ ok = true })
end)

RegisterNetEvent('cybercomm:syncState', function(state)
    SendNUIMessage({ action = 'syncState', payload = state })
end)

RegisterNetEvent('cybercomm:newMessage', function(message)
    SendNUIMessage({ action = 'newMessage', payload = message })
end)

RegisterNetEvent('cybercomm:newDeadDrop', function(dropMessage)
    SendNUIMessage({ action = 'newDeadDrop', payload = dropMessage })
end)

RegisterNetEvent('cybercomm:walletUpdate', function(walletState)
    SendNUIMessage({ action = 'walletUpdate', payload = walletState })
end)

RegisterNetEvent('cybercomm:forceClose', function()
    CloseApp()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and isUiOpen then
        SetUiFocus(false)
    end
end)
