/*
    Fonksiyon: VBSM_fnc_initPhysicalLayer
    Dosya    : vbsm_main\vbsm_layer1_physical\fn_initPhysicalLayer.sqf
    Proje    : VBSM: Operational Environment Simulation (VBSM: OES)
    Katman   : 1 - Fiziksel Varlık
    Ortam    : Yalnızca Sunucu (Dedicated/Listen) ve Headless Client (HC)
    Açıklama :
        Katman 1'in temel veri iskeletini kurar. Sivil havuzu yalnızca
        sunucu/HC belleğinde saf ARRAY olarak tutulur; publicVariable
        EDİLMEZ. Client makinelerine yük bindirilmez.

    Havuz eleman şablonu (index bazlı):
        [0] _uid          : INTEGER  -> Benzersiz, artan kimlik
        [1] _className    : STRING   -> CfgVehicles sınıf adı
        [2] _kabileID     : INTEGER  -> Aile/kabile kimliği (Katman 3)
        [3] _envanter     : ARRAY    -> [_nakitPara, _esyalar, _yasadisi]
        [4] _rutinDurumu  : STRING   -> "SLEEPING" | "WORKING" | "IDLE" | "PANIC_SHELTER"
        [5] _evKonumu     : ARRAY    -> [x, y, z]
        [6] _isKonumu     : ARRAY    -> [x, y, z]
        [7] _saglik       : SCALAR   -> 0..1
        [8] _yorgunluk    : SCALAR   -> 0..1

        Katman 2 (Bilişsel Ajan) indisleri [9..13] için bkz:
        \vbsm_main\vbsm_core\vbsm_cognitive_indices.hpp

    Parametreler: Yok
    Dönüş: BOOLEAN -> true: başlatıldı | false: bu makinede çalıştırılmadı
*/

// -----------------------------------------------------------------------------
// AĞ KONTROLÜ (MP / HC UYUMLULUĞU)
// isServer=true (Dedicated/Listen)  -> geçer
// isServer=false, hasInterface=false (HC) -> geçer
// isServer=false, hasInterface=true (Client) -> sonlanır
// -----------------------------------------------------------------------------
if (!isServer && hasInterface) exitWith { false };

// -----------------------------------------------------------------------------
// ANA ŞALTER KONTROLÜ
// -----------------------------------------------------------------------------
if !(missionNamespace getVariable ["VBSM_setting_enableSimulation", true]) exitWith {
    false
};

// -----------------------------------------------------------------------------
// HAVUZ BAŞLATMA (idempotent)
// -----------------------------------------------------------------------------
if (isNil "VBSM_var_civilianPool") then {
    VBSM_var_civilianPool = [];
};

// Başarıyla başlatıldı
true
