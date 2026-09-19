--[[
    main.lua
    Reaktor yasam dongusu orkestrasyonu: oyuncu etkilesim eventleri,
    fizik/telemetri tick'i ve Katman 1/2 koprulerinin cagri noktalari.

    Standalone kimlik: framework (QB-Core/ESX/vRP) yoktur. "citizenId"
    olarak FiveM'in kendi 'license' identifier'i kullanilir; Katman 1/2
    bu ayni kimlik uzerinden eslesecek sekilde tasarlanmalidir.
]]

local function GetCitizenId(source)
    return GetPlayerIdentifierByType(source, 'license') or ('unknown:' .. tostring(source))
end

local function IsSourceNearReactor(source, reactorId, maxDist)
    local def = Config.Reactors[reactorId]
    if not def then return false end
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - def.coords) <= (maxDist or 10.0)
end

CreateThread(function()
    for reactorId in pairs(Config.Reactors) do
        ChemistryCore.InitReactor(reactorId)
    end
end)

-- Fizik ve telemetri ayni tick'te yurutulur: reaktor calisiyorsa fizik
-- ilerletilir, ardindan 15m yaricapindaki tum oyunculara (cok oyunculu
-- gorunurluk icin, tek bir "sahip" varsayimi yapilmadan) anlik telemetri
-- (Isi/Basinc/pH + odanin guncel PPM degeri) yayinlanir.
CreateThread(function()
    local tick = Config.Thermal.physicsTickMs
    while true do
        Wait(tick)
        local dt = tick / 1000.0

        for reactorId, def in pairs(Config.Reactors) do
            local state = ChemistryCore.GetReactorState(reactorId)
            if state then
                if state.running then
                    ChemistryCore.PhysicsTick(reactorId, dt)
                end

                local telemetry = ChemistryCore.GetTelemetry(reactorId)
                if telemetry then
                    telemetry.ppm = CBRNSimulation.GetRoomPpm(def.interiorId)
                    telemetry.vesselRatedPsi = def.vesselRatedPsi

                    for _, playerId in ipairs(GetPlayers()) do
                        local ped = GetPlayerPed(playerId)
                        if ped and ped ~= 0 and #(GetEntityCoords(ped) - def.coords) <= 15.0 then
                            TriggerClientEvent('layer3_industrial_chem:client:telemetry', playerId, reactorId, telemetry)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('layer3_industrial_chem:server:chargeReagent', function(reactorId, itemName, massMg)
    local source = source
    if not IsSourceNearReactor(source, reactorId, 10.0) then return end
    ChemistryCore.ChargeReagent(reactorId, GetCitizenId(source), itemName, tonumber(massMg))
end)

RegisterNetEvent('layer3_industrial_chem:server:setCoolantValve', function(reactorId, percent)
    local source = source
    if not IsSourceNearReactor(source, reactorId, 10.0) then return end
    ChemistryCore.SetCoolantValve(reactorId, percent)
end)

RegisterNetEvent('layer3_industrial_chem:server:startSynthesis', function(reactorId, recipeKey)
    local source = source
    if not IsSourceNearReactor(source, reactorId, 10.0) then return end
    ChemistryCore.StartSynthesis(reactorId, GetCitizenId(source), recipeKey)
end)

RegisterNetEvent('layer3_industrial_chem:server:finalizeSynthesis', function(reactorId)
    local source = source
    if not IsSourceNearReactor(source, reactorId, 10.0) then return end
    local result = ChemistryCore.FinalizeSynthesis(reactorId)
    if result then
        TriggerClientEvent('layer3_industrial_chem:client:synthesisResult', source, result)
    end
end)

-- Bakim maliyeti Katman 2'ye tek yonlu (fire-and-forget) bir bildirim
-- olarak gonderilir; bakiye dogrulamasi Katman 2'nin kendi sorumlulugundadir
-- (gevsek baglantili mimari geregi, Katman 3 bir ledger tutmaz).
RegisterNetEvent('layer3_industrial_chem:server:performMaintenance', function(reactorId)
    local source = source
    if not IsSourceNearReactor(source, reactorId, 10.0) then return end

    local state = ChemistryCore.GetReactorState(reactorId)
    if not state then return end

    if GetResourceState(Config.Bridge.Layer2Resource) == 'started' then
        TriggerEvent('layer2_cybercomm:financial:recordTransaction', {
            citizenid = GetCitizenId(source),
            currency = 'XMR',
            amount = -Config.Equipment.maintenanceXmrCost,
            reason = 'lab_equipment_maintenance',
        })
    end

    state.wearRatio = math.max(0.0, state.wearRatio - Config.Equipment.maintenanceWearRecovery)
    ChemistryCore.SaveEquipmentWear(reactorId, state.wearRatio)
end)

RegisterNetEvent('layer3_industrial_chem:server:toggleVentilation', function(reactorId, state)
    local source = source
    if not IsSourceNearReactor(source, reactorId, 10.0) then return end
    local def = Config.Reactors[reactorId]
    if not def then return end
    CBRNSimulation.SetVentilation(def.interiorId, state)
end)

RegisterNetEvent('layer3_industrial_chem:server:toggleGasMask', function()
    local source = source
    CBRNSimulation.ToggleGasMask(source, not CBRNSimulation.IsGasMaskEquipped(source))
end)
