-- =====================================================================
-- NÖROKİMYASAL DURUM: KORTİZOL, DOPAMİN BASKILANMASI, YOKSUNLUK
-- =====================================================================

Neurochemical = {}

local function decayToward(current, baseline, rate)
    return baseline + (current - baseline) * (1.0 - rate)
end

function Neurochemical.ApplyStressSpike(identifier, amount, reason)
    amount = Validation.ClampNumber(amount, 0, 40)
    local a = Cache.Ensure(identifier)
    local n = a.neuro

    n.cortisol_level = Validation.ClampNumber(
        n.cortisol_level + amount, 0, CONFIG.NEUROCHEMICAL.CORTISOL_ABS_MAX)
    Cache.MarkDirty(identifier)

    if n.cortisol_level >= CONFIG.NEUROCHEMICAL.CORTISOL_CRISIS_THRESHOLD then
        TriggerEvent('sigint_layer1:neurochemicalCrisis', identifier, n.cortisol_level, reason)
    end
end

function Neurochemical.ApplyDoseEvent(identifier, compoundId, doseUnits)
    local profile = CONFIG.SUBSTANCE_PROFILES[compoundId]
    if not profile then return false end

    doseUnits = Validation.ClampNumber(doseUnits, 0, 5)
    local a = Cache.Ensure(identifier)
    local n = a.neuro

    local sub = n.substances[compoundId]
    if not sub then
        sub = { saturation = 0.0, last_update_ms = GetGameTimer() }
        n.substances[compoundId] = sub
    end

    sub.saturation = Validation.ClampNumber(sub.saturation + doseUnits * 0.3, 0.0, 1.0)
    sub.last_update_ms = GetGameTimer()

    n.dopamine_suppression = Validation.ClampNumber(
        n.dopamine_suppression + profile.dopamine_delta, 0.0, CONFIG.NEUROCHEMICAL.DOPAMINE_SUPPRESSION_MAX)

    Cache.MarkDirty(identifier)
    Neurochemical.ApplyStressSpike(identifier, profile.cortisol_rebound * 0.3, 'substance_rebound')

    return true
end

local function tickSubstance(compoundId, sub, dtMin)
    local profile = CONFIG.SUBSTANCE_PROFILES[compoundId]
    if not profile then return end
    -- standart farmakokinetik yarılanma ömrü bozunumu: S(t) = S0 * 0.5^(t/half_life)
    sub.saturation = sub.saturation * (0.5 ^ (dtMin / profile.half_life_min))
end

function Neurochemical.Tick(identifier, a, dtSeconds)
    local n = a.neuro
    local dtMin = dtSeconds / 60.0

    n.cortisol_level = Validation.ClampNumber(
        decayToward(n.cortisol_level, n.cortisol_baseline, CONFIG.NEUROCHEMICAL.CORTISOL_DECAY_RATE),
        0, CONFIG.NEUROCHEMICAL.CORTISOL_ABS_MAX)

    n.dopamine_suppression = Validation.ClampNumber(
        n.dopamine_suppression - CONFIG.NEUROCHEMICAL.DOPAMINE_RECOVERY_RATE,
        0.0, CONFIG.NEUROCHEMICAL.DOPAMINE_SUPPRESSION_MAX)

    local inWithdrawal = false
    for compoundId, sub in pairs(n.substances) do
        tickSubstance(compoundId, sub, dtMin)
        if sub.saturation < CONFIG.NEUROCHEMICAL.WITHDRAWAL_SATURATION_CUT then
            inWithdrawal = true
        end
    end
    a.neuro.in_withdrawal = inWithdrawal

    if inWithdrawal then
        n.sleep_debt = Validation.ClampNumber(n.sleep_debt + 1.2, 0, CONFIG.NEUROCHEMICAL.SLEEP_DEBT_MAX)
        Neurochemical.ApplyStressSpike(identifier, 0.8, 'withdrawal')
    else
        n.sleep_debt = Validation.ClampNumber(n.sleep_debt - 0.4, 0, CONFIG.NEUROCHEMICAL.SLEEP_DEBT_MAX)
    end

    Cache.MarkDirty(identifier)
end
