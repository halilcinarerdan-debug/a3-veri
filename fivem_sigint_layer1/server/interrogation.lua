-- =====================================================================
-- SORGU BİLİŞSEL YÜKÜ: PEACE / REID PROTOKOLÜNE DİRENÇ
--
-- cognitive_load; sorgu yöntemi, uyku borcu ve yoksunluk durumuna göre
-- birikir. confession_probability, bu yükün lojistik (sigmoid)
-- dönüşümüdür ve yalnızca bir olasılık üretir — nihai kararı çağıran
-- (sorgu/RP) sistemi verir, bu modül asla otomatik itiraf tetiklemez.
-- =====================================================================

Interrogation = {}

local function sigmoid(x)
    return 1.0 / (1.0 + math.exp(-x))
end

function Interrogation.Start(identifier, method, counselPresent)
    if method ~= 'REID' and method ~= 'PEACE' then return false end

    local a = Cache.Ensure(identifier)
    local i = a.interrogation
    i.active = true
    i.method = method
    i.counsel_present = counselPresent and true or false
    i.session_started_ms = GetGameTimer()

    Cache.MarkDirty(identifier)
    return true
end

function Interrogation.Stop(identifier)
    local a = Cache.Get(identifier)
    if not a then return end
    a.interrogation.active = false
    Cache.MarkDirty(identifier)
end

function Interrogation.Tick(identifier, a)
    local i = a.interrogation
    if not i.active then return end

    local rate = CONFIG.INTERROGATION.METHOD_RATE[i.method] or 1.0
    local sleepPenalty = a.neuro.sleep_debt * CONFIG.INTERROGATION.SLEEP_DEBT_MULT
    local withdrawalPenalty = a.neuro.in_withdrawal and CONFIG.INTERROGATION.WITHDRAWAL_LOAD_BONUS or 0.0
    local counselReduction = i.counsel_present and CONFIG.INTERROGATION.COUNSEL_PRESENT_REDUCTION or 0.0

    local delta = rate * (1.0 + sleepPenalty + withdrawalPenalty) * (1.0 - counselReduction)

    i.cognitive_load = Validation.ClampNumber(
        i.cognitive_load + delta, 0, CONFIG.INTERROGATION.LOAD_MAX)

    i.confession_probability = sigmoid(
        (i.cognitive_load - CONFIG.INTERROGATION.CONFESSION_MIDPOINT) / CONFIG.INTERROGATION.CONFESSION_SIGMOID_K)

    Cache.MarkDirty(identifier)
end
