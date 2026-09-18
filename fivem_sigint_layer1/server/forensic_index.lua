-- =====================================================================
-- KRİMİNALİSTİK KONTAMİNASYON ENDEKSİ
--
-- ComputeContact yalnızca güvenilir sunucu içi çağrılardan (export /
-- başka bir sunucu modülü) beslenmelidir; nem/sıcaklık gibi ortam
-- verisi bir istemci ağ olayından doğrudan alınmamalıdır.
-- =====================================================================

Forensic = {}

function Forensic.ComputeContact(identifier, fingerprintId, dnaProfile, itemId, humidityPct, tempC)
    local a = Cache.Ensure(identifier)

    humidityPct = Validation.ClampNumber(humidityPct, 0, 100)
    tempC = Validation.ClampNumber(tempC, -30, 60)

    local humidityFactor = 1.0 + CONFIG.FORENSIC.HUMIDITY_COEFF * (humidityPct - CONFIG.FORENSIC.HUMIDITY_REF_PCT)
    local tempFactor = 1.0 + CONFIG.FORENSIC.TEMP_COEFF * (tempC - CONFIG.FORENSIC.TEMP_REF_C)
    local dnaHumidityFactor = 1.0 + CONFIG.FORENSIC.DNA_HUMIDITY_COEFF * (humidityPct - CONFIG.FORENSIC.HUMIDITY_REF_PCT)

    local f = a.forensic
    f.fingerprint_id = fingerprintId
    f.dna_profile = dnaProfile
    f.item_id = itemId
    f.humidity_pct = humidityPct
    f.temp_c = tempC
    f.fingerprint_integrity = 100.0
    f.dna_integrity = 100.0
    f.print_decay_rate = CONFIG.FORENSIC.PRINT_BASE_DECAY_PER_MIN * math.max(0.1, humidityFactor * tempFactor)
    f.dna_decay_rate = CONFIG.FORENSIC.DNA_BASE_DECAY_PER_MIN * math.max(0.1, dnaHumidityFactor * tempFactor)
    f.last_contact_ms = GetGameTimer()
    f.has_active_trace = true

    Cache.MarkDirty(identifier)
    return true
end

-- Zamana bağlı üstel bozunum; biyometrik ana döngüden çağrılır.
function Forensic.TickDecay(identifier, a)
    local f = a.forensic
    if not f.has_active_trace then return end

    local elapsedMin = (GetGameTimer() - f.last_contact_ms) / 60000.0
    local newPrint = 100.0 * math.exp(-f.print_decay_rate * elapsedMin)
    local newDna = 100.0 * math.exp(-f.dna_decay_rate * elapsedMin)

    f.fingerprint_integrity = Validation.ClampNumber(newPrint, 0.0, 100.0)
    f.dna_integrity = Validation.ClampNumber(newDna, 0.0, 100.0)

    if f.fingerprint_integrity <= 0.01 and f.dna_integrity <= 0.01 then
        f.has_active_trace = false
    end

    Cache.MarkDirty(identifier)
end
