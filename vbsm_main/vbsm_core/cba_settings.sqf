/*
    Dosya: vbsm_main\vbsm_core\cba_settings.sqf
    Proje: VBSM: Operational Environment Simulation (VBSM: OES)
    Katman: 0 - Çekirdek (Core)

    Açıklama:
    VBSM projesinin CBA Mission Settings (Ayarlar) menüsü üzerinden
    yönetilebilen tüm global değişkenlerini tanımlar. Bu dosyanın
    CfgFunctions içinde "preInit = 1" bayrağıyla (örn. VBSM_fnc_cbaSettings)
    çağrılması gerekir; aksi halde ayarlar CBA_Settings_fnc_init devreye
    girmeden önce menüye eklenemez ve varsayılan değerleriyle çalışmazlar.

    Not: Bu dosya yalnızca ayar TANIMLARINI içerir, iş mantığı barındırmaz.
    Tüm ayarlar "VBSM: Operational Environment Simulation" kategorisi
    altında toplanır ki oyun içi Ayarlar menüsünde dağınıklık oluşmasın.
*/

// =============================================================================
// AYAR 1: VBSM_setting_maxCivilians
// -----------------------------------------------------------------------------
// Haritada aynı anda FİZİKSEL olarak (spawn edilmiş, RV4 motorunda gerçek
// nesne olarak) bulunabilecek maksimum sivil sayısı. Katman 1 - Fiziksel
// Varlık havuzunun sunucu/HC üzerindeki üst sınırını belirler. Bu değer
// yükseldikçe sunucu/HC işlemci yükü artar, bu yüzden 200 ile sınırlanmıştır.
// Tip     : SLIDER (SCALAR)
// Varsayılan: 50
// Sınırlar  : 0 - 200
// =============================================================================
[
    "VBSM_setting_maxCivilians",                       // _setting     -> değişken adı
    "SLIDER",                                          // _settingType
    [
        "[VBSM] Maksimum Sivil Sayısı",
        "Haritada aynı anda fiziksel olarak var olabilecek (spawn edilmiş) maksimum sivil sayısı. Sunucu/HC performansını doğrudan etkiler."
    ],                                                  // _title [başlık, tooltip]
    "VBSM: Operational Environment Simulation",        // _category
    [0, 200, 50, 0],                                   // _valueInfo [_min, _max, _default, _trailingDecimals]
    true,                                               // _isGlobal    -> sunucu değeri tüm oturuma bağlayıcıdır
    {},                                                 // _script      -> anlık okunduğu için ek tetikleyici gerekmez
    true                                                // _needRestart -> havuz üst sınırı yalnızca misyon yeniden başında güvenli değişir
] call CBA_fnc_addSetting;

// =============================================================================
// AYAR 2: VBSM_setting_enableSimulation
// -----------------------------------------------------------------------------
// Tüm VBSM framework'ünü (Katman 1'den Katman 8'e kadar) tek noktadan
// açıp kapatan ana güvenlik şalteridir. Kapalıyken hiçbir VBSM PFH/döngüsü
// başlatılmaz; bu sayede framework, test veya sorun giderme amacıyla
// tamamen devre dışı bırakılabilir.
// Tip       : CHECKBOX (BOOLEAN)
// Varsayılan: true
// =============================================================================
[
    "VBSM_setting_enableSimulation",
    "CHECKBOX",
    [
        "[VBSM] Simülasyonu Etkinleştir",
        "VBSM: Operational Environment Simulation framework'ünün tamamını (Katman 1-8) açar veya kapatır."
    ],
    "VBSM: Operational Environment Simulation",
    true,                                               // varsayılan değer
    true,                                               // _isGlobal
    {},
    true                                                // _needRestart -> ana şalter oturum ortasında güvenle değiştirilemez
] call CBA_fnc_addSetting;

// =============================================================================
// AYAR 3: VBSM_setting_rutinHizi
// -----------------------------------------------------------------------------
// Sivil ajanların günlük rutin (yaşam döngüsü) zamanının akış çarpanı.
// Eğitim senaryosunun süresine göre rutin akışını yavaşlatmak veya
// hızlandırmak için kullanılır. Sabit seçenek listesi sunulur, serbest
// değer girişine izin verilmez.
// Tip       : LIST (SCALAR)
// Seçenekler: 0.5 / 1 / 2
// Varsayılan: 1 (Normal)
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
        [0.5, 1, 2],                                   // _values       -> gerçek dönüş değerleri
        ["Yavaş (x0.5)", "Normal (x1)", "Hızlı (x2)"],  // _valueTitles  -> menüde görünen etiketler
        1                                               // _defaultIndex -> "Normal (x1)" seçili gelir
    ],
    true,                                               // _isGlobal
    {},
    false                                               // _needRestart -> rutin hızı oturum içinde canlı olarak değiştirilebilir
] call CBA_fnc_addSetting;
