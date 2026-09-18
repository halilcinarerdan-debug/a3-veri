/*
    Fonksiyon: VBSM_fnc_initPhysicalLayer
    Dosya    : vbsm_main\vbsm_layer1_physical\fn_initPhysicalLayer.sqf
    Proje    : VBSM: Operational Environment Simulation (VBSM: OES)
    Katman   : 1 - Fiziksel Varlık (Sivil Havuzu, Envanter, Rutin)
    Ortam    : Yalnızca Sunucu (Dedicated/Listen Server) ve Headless Client (HC)

    Açıklama:
    Katman 1'in temel veri iskeletini kurar. Bu fonksiyon CfgFunctions
    içinde "VBSM" tag'i altında VBSM_fnc_initPhysicalLayer olarak kayıtlı
    olmalı ve misyon başlangıcında (initServer.sqf veya preInit) çağrılmalıdır.

    Mimari kural: Oyuncu (Client) makinelerine KESİNLİKLE yük bindirilmez.
    Sivil havuzu verisi yalnızca sunucu/HC belleğinde saf bir ARRAY olarak
    tutulur ve publicVariable EDİLMEZ; client'lara yalnızca gerektiğinde
    (bir sivil spawn/despawn edildiğinde) hafif, seçilmiş veri gönderilecektir
    (bu senkronizasyon ileri katmanların sorumluluğundadır).

    Parametreler: Yok

    Dönüş: BOOLEAN -> true: başlatma yapıldı / false: bu makinede çalıştırılmadı
*/

// -----------------------------------------------------------------------------
// AĞ KONTROLÜ (MP / HC UYUMLULUĞU)
// Bu katman yalnızca Sunucu veya Headless Client üzerinde başlatılmalıdır.
// isServer      -> true: Dedicated Server veya Listen Server (host)
// hasInterface  -> true: bu makinede bir oyuncu arayüzü (ekran) var demektir
//
// Bir oyuncu (client) makinesinde isServer=false VE hasInterface=true olur;
// bu durumda fonksiyon hiçbir şey yapmadan sessizce sonlanır. Headless Client
// ise isServer=false ANCAK hasInterface=false olduğundan bu kontrolden geçip
// çalışmaya devam eder.
// -----------------------------------------------------------------------------
if (!isServer && hasInterface) exitWith {
    false
};

// -----------------------------------------------------------------------------
// ANA ŞALTER KONTROLÜ
// CBA ayarından ("vbsm_core\cba_settings.sqf" -> VBSM_setting_enableSimulation)
// simülasyon kapatılmışsa Katman 1 hiç başlatılmaz.
// -----------------------------------------------------------------------------
if !(missionNamespace getVariable ["VBSM_setting_enableSimulation", true]) exitWith {
    false
};

// -----------------------------------------------------------------------------
// VBSM_var_civilianPool
// Katman 1'in tekil doğruluk kaynağıdır (Single Source of Truth). Sunucu/HC
// belleğinde saf bir ARRAY olarak tutulur; her eleman bir sivilin fiziksel
// varlık verisini temsil eder (henüz spawn edilmemiş "sanal" siviller de
// bu havuzda saklanır, bkz. Katman 5 - Sanal Dünya).
//
// İleride bu diziye eklenecek her elemanın şablonu (Katman 2 ve sonrasıyla
// birlikte genişletilecektir):
//
//   [_uid, _className, _kabileID, _envanter, _rutinDurumu, _evKonumu, _isKonumu, _saglik, _yorgunluk]
//
//     _uid          STRING  -> Sivilin benzersiz kimliği (ör: "civ_0001")
//     _className    STRING  -> Spawn edilecek CfgVehicles sınıf adı
//     _kabileID     STRING  -> Bağlı olduğu aile/kabile kimliği (Katman 3)
//     _envanter     ARRAY   -> Taşıdığı eşyaların listesi (Katman 1 envanter verisi)
//     _rutinDurumu  STRING  -> Anlık rutin durumu (ör: "uyuyor", "iste", "evde")
//     _evKonumu     ARRAY   -> Ev pozisyonu [x, y, z]
//     _isKonumu     ARRAY   -> Iş/görev pozisyonu [x, y, z]
//     _saglik       SCALAR  -> Sağlık durumu (0-1 arası)
//     _yorgunluk    SCALAR  -> Yorgunluk seviyesi (0-1 arası)
//
// Başlangıçta havuz boştur; siviller ileriki katmanlar tarafından üretilip
// bu diziye eklenecektir.
// -----------------------------------------------------------------------------
if (isNil "VBSM_var_civilianPool") then {
    VBSM_var_civilianPool = [];
};

// Katman 1 bu makinede başarıyla başlatıldı.
true
