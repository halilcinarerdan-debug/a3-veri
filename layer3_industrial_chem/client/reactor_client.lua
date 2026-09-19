local isNuiOpen = false
local currentReactorId = nil

local function OpenReactorNui(reactorId)
    currentReactorId = reactorId
    isNuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', reactorId = reactorId })
end

local function CloseReactorNui()
    isNuiOpen = false
    currentReactorId = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

CreateThread(function()
    while true do
        local sleep = 1000
        local pc = GetEntityCoords(PlayerPedId())

        for reactorId, def in pairs(Config.Reactors) do
            if #(pc - def.coords) < 2.5 then
                sleep = 0
                DrawMarker(2, def.coords.x, def.coords.y, def.coords.z + 0.4,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25,
                    120, 120, 120, 180, false, true, 2, false, nil, nil, false)

                if not isNuiOpen and IsControlJustReleased(0, 38) then -- E
                    OpenReactorNui(reactorId)
                end
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('layer3_industrial_chem:client:telemetry', function(reactorId, telemetry)
    if isNuiOpen and currentReactorId == reactorId then
        SendNUIMessage({ action = 'telemetry', data = telemetry })
    end
end)

RegisterNetEvent('layer3_industrial_chem:client:synthesisResult', function(result)
    if isNuiOpen then
        SendNUIMessage({ action = 'result', data = result })
    end
end)

RegisterNetEvent('layer3_industrial_chem:client:gasExposureEffect', function(payload)
    local severity = math.min(1.0, payload.severity or 0.0)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', severity)
    SetTimecycleModifier('spectator5')
    SetTimecycleModifierStrength(severity)
    Wait(400)
    ClearTimecycleModifier()
end)

RegisterNUICallback('close', function(_, cb)
    CloseReactorNui()
    cb('ok')
end)

RegisterNUICallback('setValve', function(data, cb)
    if currentReactorId then
        TriggerServerEvent('layer3_industrial_chem:server:setCoolantValve', currentReactorId, data.percent)
    end
    cb('ok')
end)

RegisterNUICallback('chargeReagent', function(data, cb)
    if currentReactorId then
        TriggerServerEvent('layer3_industrial_chem:server:chargeReagent', currentReactorId, data.item, tonumber(data.massMg))
    end
    cb('ok')
end)

RegisterNUICallback('startSynthesis', function(data, cb)
    if currentReactorId then
        TriggerServerEvent('layer3_industrial_chem:server:startSynthesis', currentReactorId, data.recipeKey)
    end
    cb('ok')
end)

RegisterNUICallback('finalizeSynthesis', function(_, cb)
    if currentReactorId then
        TriggerServerEvent('layer3_industrial_chem:server:finalizeSynthesis', currentReactorId)
    end
    cb('ok')
end)

RegisterNUICallback('toggleVentilation', function(data, cb)
    if currentReactorId then
        TriggerServerEvent('layer3_industrial_chem:server:toggleVentilation', currentReactorId, data.state)
    end
    cb('ok')
end)

RegisterNUICallback('performMaintenance', function(_, cb)
    if currentReactorId then
        TriggerServerEvent('layer3_industrial_chem:server:performMaintenance', currentReactorId)
    end
    cb('ok')
end)

RegisterCommand('toggle_gasmask', function()
    TriggerServerEvent('layer3_industrial_chem:server:toggleGasMask')
end, false)
