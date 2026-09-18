/*
    Dosya: vbsm_main\vbsm_core\cba_settings.sqf
    Proje: VBSM: Operational Environment Simulation (VBSM: OES)
    Katman: 0 - Çekirdek (Core)
    Açıklama:
        VBSM projesinin CBA Mission Settings menüsü üzerinden yönetilen
        tüm global ayarlarını tanımlar. Bu dosya CfgFunctions içinde
        "preInit = 1" bayrağıyla çağrılmalıdır; aksi halde CBA_Settings
        init zinciri devreye girmeden menüye eklenemez.
    Not: Yalnızca ayar TANIMLARI içerir; iş mantığı barındırmaz.
*/

// =============================================================================
// AYAR 1: VBSM_setting_maxCivilians
// Fiziksel olarak spawn edilebilecek maksimum sivil sayısı.
// Tip: SLIDER (SCALAR) | Varsayılan: 50 | Sınırlar: 0-200
// =============================================================================
[
    "VBSM_setting_maxCivilians",
    "SLIDER",
    [
        "[VBSM] Maksimum Sivil Sayısı",
        "Haritada aynı anda fiziksel olarak var olabilecek (spawn edilmiş) maksimum sivil sayısı. Sunucu/HC performansını doğrudan etkiler."
    ],
    "VBSM: Operational Environment Simulation",
    [0, 200, 50, 0],
    true,       // _isGlobal
    {},         // _script
    true        // _needRestart
] call CBA_fnc_addSetting;

// =============================================================================
// AYAR 2: VBSM_setting_enableSimulation
// Katman 1-8 ana güvenlik şalteri.
// Tip: CHECKBOX (BOOLEAN) | Varsayılan: true
// =============================================================================
[
    "VBSM_setting_enableSimulation",
    "CHECKBOX",
    [
        "[VBSM] Simülasyonu Etkinleştir",
        "VBSM: Operational Environment Simulation framework'ünün tamamını (Katman 1-8) açar veya kapatır."
    ],
    "VBSM: Operational Environment Simulation",
    true,
    true,       // _isGlobal
    {},
    true        // _needRestart
] call CBA_fnc_addSetting;

// =============================================================================
// AYAR 3: VBSM_setting_rutinHizi
// Sivil günlük rutin zaman akış çarpanı.
// Tip: LIST (SCALAR) | Seçenekler: 0.5 / 1 / 2 | Varsayılan: 1
// =============================================================================
[
    "VBSM_setting_rutinHizi",
    "LIST",
    [
        "[VBSM] Rutin Akış Hızı",
        "Sivil ajanların günlük rutin (yaşam döngüsü) zamanının akış çarpanı."
    ],
    "VBSM: Operational Environment Simulation",
    [
        [0.5, 1, 2],
        ["Yavaş (x0.5)", "Normal (x1)", "Hızlı (x2)"],
        1
    ],
    true,       // _isGlobal
    {},
    false       // _needRestart (canlı değişebilir)
] call CBA_fnc_addSetting;
