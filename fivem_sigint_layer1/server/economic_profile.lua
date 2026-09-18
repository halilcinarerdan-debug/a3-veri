-- =====================================================================
-- AJAN EKONOMİK PROFİLİ: BORÇ YÜKÜ -> RİSK İŞTAHI
-- risk_appetite, debt_index'in lojistik (sigmoid) fonksiyonudur:
-- borç arttıkça rasyonel hayatta kalma güdüsüyle risk toleransı artar.
-- =====================================================================

Economic = {}

function Economic.ApplyDebtChange(identifier, delta, reason)
    delta = Validation.ClampNumber(delta, -1000000, 1000000)

    local a = Cache.Ensure(identifier)
    local e = a.economic

    e.debt_index = math.max(0.0, e.debt_index + delta)

    local x = (e.debt_index - CONFIG.ECONOMIC.RISK_MIDPOINT_DEBT) / CONFIG.ECONOMIC.RISK_SCALE
    e.risk_appetite = 1.0 / (1.0 + math.exp(-x))

    Cache.MarkDirty(identifier)
    return e.debt_index, e.risk_appetite
end
