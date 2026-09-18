CONFIG = {}

-- ===================== ZAMANLAYICI ARALIKLARI (ms) =====================
CONFIG.TICK = {
    SIGINT_MS          = 5000,      -- baz istasyonu üçgenleme döngüsü
    BIOMETRIC_MS       = 15000,     -- kortizol / yoksunluk / sorgu döngüsü
    PERSISTENCE_MS     = 600000,    -- 10 dakikalık toplu SQL flush
    STALE_TRANSMIT_MS  = 20000,     -- bu süre paket gelmezse "transmitting" bayrağı düşer
}

-- ===================== SIGINT / RF FİZİK PARAMETRELERİ =====================
-- Log-distance path loss modeli: RSSI(d) = TxPower - (RefLoss + 10*n*log10(d/d0))
CONFIG.RF = {
    TX_POWER_DBM       = 23.0,     -- tipik GSM el cihazı çıkış gücü
    PATH_LOSS_EXPONENT = 3.2,      -- şehir içi (urban) ortam katsayısı, tipik 2.7-3.5
    REFERENCE_DIST_M   = 1.0,
    REFERENCE_LOSS_DB  = 40.0,
    NOISE_FLOOR_DBM    = -100.0,
    SENSITIVITY_DBM    = -110.0,   -- bu değerin altı "duyulamaz" kabul edilir
}

-- Harita üzerine dağıtılmış kurgusal baz istasyonları
CONFIG.TOWERS = {
    { id = 1, name = 'Vinewood Tepesi',   coords = vector3(   190.0,   360.0,  105.0) },
    { id = 2, name = 'Liman Bölgesi',      coords = vector3(   850.0, -3100.0,    6.0) },
    { id = 3, name = 'Havaalanı Kulesi',    coords = vector3( -1000.0, -2600.0,   14.0) },
    { id = 4, name = 'Sandy Shores',        coords = vector3(  1650.0,  3700.0,   35.0) },
    { id = 5, name = 'Paleto Bay',          coords = vector3(  -420.0,  6100.0,   32.0) },
    { id = 6, name = 'Şehir Merkezi',       coords = vector3(  -260.0,  -830.0,   30.0) },
}

CONFIG.TRIANGULATION = {
    CONFIDENCE_BASE      = { [0] = 0.00, [1] = 0.15, [2] = 0.50, [3] = 0.80 },
    CONFIDENCE_MAX_3PLUS = 0.95,
    SNR_QUALITY_MIN      = 0.3,
    SNR_QUALITY_MAX      = 1.0,
    SNR_FLOOR_DB         = 0.0,
    SNR_CEIL_DB          = 25.0,
    ACCUMULATION_RATE    = 0.10,   -- her aktif tick'te hedef güvene yaklaşma oranı
    DECAY_RATE           = 0.12,   -- yayın kesilince güvenin sönme oranı
    SEARCH_RADIUS_MAX_M  = 2200.0,
    SEARCH_RADIUS_MIN_M  = 45.0,
}

-- ===================== NÖROKİMYASAL PARAMETRELER =====================
CONFIG.NEUROCHEMICAL = {
    CORTISOL_BASELINE_MIN      = 5.0,
    CORTISOL_BASELINE_MAX      = 25.0,
    CORTISOL_CRISIS_THRESHOLD  = 50.0,
    CORTISOL_DECAY_RATE        = 0.05,   -- bazale yaklaşma oranı (per tick)
    CORTISOL_ABS_MAX           = 90.0,
    DOPAMINE_SUPPRESSION_MAX   = 1.0,
    DOPAMINE_RECOVERY_RATE     = 0.01,
    SLEEP_DEBT_MAX             = 100.0,
    WITHDRAWAL_SATURATION_CUT  = 0.15,   -- bu doygunluğun altı yoksunluk sayılır
}

-- Kurgusal sentetik bileşik profilleri (gerçek madde adları kullanılmaz)
CONFIG.SUBSTANCE_PROFILES = {
    ['SYN-ALPHA'] = { half_life_min = 90,  dopamine_delta = 0.18, cortisol_rebound = 12.0 },
    ['SYN-BETA']  = { half_life_min = 240, dopamine_delta = 0.10, cortisol_rebound = 6.0  },
    ['SYN-GAMMA'] = { half_life_min = 35,  dopamine_delta = 0.25, cortisol_rebound = 20.0 },
}

-- ===================== KRİMİNALİSTİK PARAMETRELER =====================
CONFIG.FORENSIC = {
    PRINT_BASE_DECAY_PER_MIN = 0.006,
    DNA_BASE_DECAY_PER_MIN   = 0.003,
    HUMIDITY_REF_PCT         = 40.0,
    TEMP_REF_C               = 20.0,
    HUMIDITY_COEFF           = 0.012,
    TEMP_COEFF               = 0.020,
    DNA_HUMIDITY_COEFF       = 0.020,   -- DNA mikrobiyal bozunmaya daha duyarlı
}

-- ===================== EKONOMİK PROFİL =====================
CONFIG.ECONOMIC = {
    RISK_MIDPOINT_DEBT = 15000.0,   -- lojistik eğrinin orta noktası ($)
    RISK_SCALE         = 6000.0,
}

-- ===================== SORGU / BİLİŞSEL YÜK =====================
CONFIG.INTERROGATION = {
    LOAD_BASE                  = 10.0,
    LOAD_MAX                   = 100.0,
    METHOD_RATE                = { REID = 2.4, PEACE = 1.1 },
    SLEEP_DEBT_MULT            = 0.015,
    WITHDRAWAL_LOAD_BONUS      = 0.20,
    COUNSEL_PRESENT_REDUCTION  = 0.35,
    CONFESSION_MIDPOINT        = 55.0,
    CONFESSION_SIGMOID_K       = 8.0,
}

-- ===================== SUNUCU TARAFI DOĞRULAMA =====================
CONFIG.VALIDATION = {
    MAX_SPEED_MPS       = 120.0,  -- iki SIGINT tick'i arası fizik-dışı sıçrama eşiği
    MAX_EVENTS_PER_MIN  = 20,
}
