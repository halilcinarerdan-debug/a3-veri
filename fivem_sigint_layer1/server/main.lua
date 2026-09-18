-- =====================================================================
-- KATMAN 1 ORKESTRASYON
--
-- Yalnızca 3 bağımsız thread çalışır: SIGINT, biyometrik/sorgu ve
-- kalıcılık (persistence). Her thread, tüm ajanlar üzerinde TEK bir
-- geçiş yapar; CPU maliyeti O(çevrimiçi oyuncu + kayıtlı ajan) ile
-- sınırlıdır ve tick aralıkları dışında sunucuyu meşgul etmez.
-- =====================================================================

CreateThread(function()
    while true do
        Wait(CONFIG.TICK.SIGINT_MS)
        Sigint.RunTick()
    end
end)

CreateThread(function()
    while true do
        Wait(CONFIG.TICK.BIOMETRIC_MS)
        local dtSeconds = CONFIG.TICK.BIOMETRIC_MS / 1000.0
        for identifier, a in pairs(Cache.Agents) do
            Neurochemical.Tick(identifier, a, dtSeconds)
            Forensic.TickDecay(identifier, a)
            Interrogation.Tick(identifier, a)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(CONFIG.TICK.PERSISTENCE_MS)
        Persistence.FlushAll()
    end
end)

-- Oyuncu ayrılırken güncel verisini kaybetmemek için anlık flush
AddEventHandler('playerDropped', function()
    local src = source
    local identifier = Validation.ResolveIdentifier(src)
    if identifier and Cache.Get(identifier) then
        Persistence.FlushOne(identifier, 'player_dropped')
    end
end)

-- =====================================================================
-- DIŞA AÇIK API (Katman 2+ modülleri buradan tüketir)
-- =====================================================================

exports('RegisterDevice', Sigint.RegisterDevice)
exports('RegisterForensicContact', Forensic.ComputeContact)
exports('ApplyStressSpike', Neurochemical.ApplyStressSpike)
exports('ApplyDoseEvent', Neurochemical.ApplyDoseEvent)
exports('ApplyDebtChange', Economic.ApplyDebtChange)
exports('StartInterrogation', Interrogation.Start)
exports('StopInterrogation', Interrogation.Stop)

exports('TriggerCriticalEvent', function(identifier, reason)
    -- reason: 'arrest' | 'death' | 'betrayal' | ...
    Persistence.FlushOne(identifier, reason)
end)

exports('GetAgentSnapshot', function(identifier)
    local a = Cache.Get(identifier)
    if not a then return nil end
    return {
        sigint = {
            is_transmitting = a.sigint.is_transmitting,
            triangulation_confidence = a.sigint.triangulation_confidence,
            search_radius_m = a.sigint.search_radius_m,
        },
        forensic = {
            fingerprint_integrity = a.forensic.fingerprint_integrity,
            dna_integrity = a.forensic.dna_integrity,
        },
        neuro = {
            cortisol_level = a.neuro.cortisol_level,
            dopamine_suppression = a.neuro.dopamine_suppression,
            sleep_debt = a.neuro.sleep_debt,
            in_withdrawal = a.neuro.in_withdrawal or false,
        },
        economic = {
            debt_index = a.economic.debt_index,
            risk_appetite = a.economic.risk_appetite,
        },
        interrogation = {
            cognitive_load = a.interrogation.cognitive_load,
            confession_probability = a.interrogation.confession_probability,
        },
    }
end)
