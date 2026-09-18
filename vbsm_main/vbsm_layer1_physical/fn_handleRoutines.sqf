#include "\vbsm_main\vbsm_core\vbsm_cognitive_indices.hpp"
/*
    Fonksiyon: VBSM_fnc_handleRoutines
    Dosya    : vbsm_main\vbsm_layer1_physical\fn_handleRoutines.sqf
    Proje    : VBSM: Operational Environment Simulation (VBSM: OES)
    Katman   : 1 - Fiziksel Varlık / 2 - Bilişsel Ajan (Duygu)
    Ortam    : Yalnızca Sunucu (Dedicated/Listen) ve Headless Client (HC)
    Açıklama :
        VBSM_var_civilianPool içindeki tüm sivillerin rutin durumunu,
        yorgunluk seviyesini ve Katman 2 anlık korku değerini dayTime'a
        göre güncelleyen asenkron zaman motoru. Anlık korku belirlenen
        eşiği aşarsa rutin normal akıştan çıkarılıp PANIC_SHELTER'a
        zorlanır. waitUntil / eachFrame KULLANILMAZ; CBA_fnc_waitAndExecute
        ile öz-yinelemeli (recursive) olarak kendini yeniden zamanlar.

    Parametreler: Yok
    Dönüş       : Nothing (kendini kuyruğa yeniden alır)
*/

// -----------------------------------------------------------------------------
// AĞ KONTROLÜ (MP / HC UYUMLULUĞU)
// -----------------------------------------------------------------------------
if (!isServer && hasInterface) exitWith {};

// -----------------------------------------------------------------------------
// DÖNGÜ PERİYODU HESABI
// Varsayılan 30 sn (rutinHizi=1). x2 -> 15 sn, x0.5 -> 60 sn.
// -----------------------------------------------------------------------------
private _VARSAYILAN_PERIYOT = 30;
private _rutinHizi = missionNamespace getVariable ["VBSM_setting_rutinHizi", 1];
private _uykuSuresi = _VARSAYILAN_PERIYOT / (_rutinHizi max 0.1);

// -----------------------------------------------------------------------------
// ANA ŞALTER: kapalı ise güncelleme yapma, sadece yeniden zamanla.
// -----------------------------------------------------------------------------
if !(missionNamespace getVariable ["VBSM_setting_enableSimulation", true]) exitWith {
    [VBSM_fnc_handleRoutines, [], _uykuSuresi] call CBA_fnc_waitAndExecute;
};

// -----------------------------------------------------------------------------
// HAVUZ VARLIK KONTROLÜ
// initPhysicalLayer henüz çalışmadıysa boşuna iterasyon yapma.
// -----------------------------------------------------------------------------
if (isNil "VBSM_var_civilianPool") exitWith {
    [VBSM_fnc_handleRoutines, [], _uykuSuresi] call CBA_fnc_waitAndExecute;
};

// -----------------------------------------------------------------------------
// YORGUNLUK ADIM SABİTLERİ
// -----------------------------------------------------------------------------
private _YORGUNLUK_UYKU_AZALMA = 0.05;
private _YORGUNLUK_IS_ARTIS    = 0.03;
private _YORGUNLUK_IS_TAVAN    = 0.8;

// -----------------------------------------------------------------------------
// KATMAN 2: KORKU EŞİK VE SÖNÜMLENME SABİTLERİ
// Algı/Tetikleyici modülü (ileri katman) henüz devrede olmadığından, korku
// her döngüde koşulsuz sönümlenir; tetikleyici entegre edildiğinde bu sönüm
// yalnızca "bölgede aktif panik kaynağı yok" durumuna bağlanacaktır.
// -----------------------------------------------------------------------------
private _KORKU_PANIK_ESIGI    = 0.7;
private _KORKU_SONUMLENME     = 0.05;

// -----------------------------------------------------------------------------
// ANLIK SAAT
// -----------------------------------------------------------------------------
private _saat = dayTime; // 0..24

// -----------------------------------------------------------------------------
// HAVUZ TARAMASI
// _x, alt-diziye REFERANSTIR; _x set [...] doğrudan in-place mutasyon yapar
// (array kopyası yok, ekstra bellek tahsisi yok). Aynı kural, CIV_INDEX_EMOTION
// alt-dizisi için de geçerlidir: select ile alınan referans üzerinde set
// çağrılır.
// -----------------------------------------------------------------------------
{
    private _duyguYapisi = _x select CIV_INDEX_EMOTION;
    private _anlikKorku  = _duyguYapisi select 0;

    if (_anlikKorku > _KORKU_PANIK_ESIGI) then {
        // KATMAN 2 ÖNCELİĞİ: panik eşiği aşıldı, normal gündelik rutin bastırılır.
        _x set [CIV_INDEX_ROUTINE, "PANIC_SHELTER"];
    } else {
        if (_saat < 6) then {
            // GECE (00:00-06:00): uyku, yorgunluk azalır, envanter dokunulmaz.
            _x set [CIV_INDEX_ROUTINE, "SLEEPING"];
            _x set [CIV_INDEX_FATIGUE, ((_x select CIV_INDEX_FATIGUE) - _YORGUNLUK_UYKU_AZALMA) max 0];
        } else {
            if (_saat < 18) then {
                // GÜNDÜZ (06:00-18:00): iş, yorgunluk artar (tavana kadar).
                _x set [CIV_INDEX_ROUTINE, "WORKING"];
                _x set [CIV_INDEX_FATIGUE, ((_x select CIV_INDEX_FATIGUE) + _YORGUNLUK_IS_ARTIS) min _YORGUNLUK_IS_TAVAN];
            } else {
                // AKŞAM (18:00-24:00): serbest zaman, yorgunluk sabit.
                _x set [CIV_INDEX_ROUTINE, "IDLE"];
            };
        };
    };

    // KATMAN 2: korku zamanla yavaşça sönümlenir (taban 0'ın altına inmez).
    _duyguYapisi set [0, (_anlikKorku - _KORKU_SONUMLENME) max 0];
} forEach VBSM_var_civilianPool;

// -----------------------------------------------------------------------------
// ÖZ-YİNELEMELİ YENİDEN ZAMANLAMA
// waitUntil / eachFrame yerine CBA unscheduled kuyruğu — VM thread bloklanmaz.
// -----------------------------------------------------------------------------
[VBSM_fnc_handleRoutines, [], _uykuSuresi] call CBA_fnc_waitAndExecute;
