/*
    Fonksiyon: VBSM_fnc_handleRoutines
    Dosya    : vbsm_main\vbsm_layer1_physical\fn_handleRoutines.sqf
    Proje    : VBSM: Operational Environment Simulation (VBSM: OES)
    Katman   : 1 - Fiziksel Varlık (Sivil Havuzu, Envanter, Rutin)
    Ortam    : Yalnızca Sunucu (Dedicated/Listen Server) ve Headless Client (HC)

    Açıklama:
    VBSM_var_civilianPool içindeki tüm sivillerin rutin durumunu ve
    yorgunluk seviyesini oyunun anlık saatine (dayTime) göre güncelleyen
    asenkron zaman motorudur (scheduler). "waitUntil" veya "eachFrame"
    KULLANILMAZ; bunun yerine CBA_fnc_waitAndExecute ile öz-yinelemeli
    (recursive) olarak kendini yeniden zamanlar. Bu sayede unscheduled
    ortamda, VM thread'i bloklamadan, sunucu/HC tick oranına bağlı
    kalmadan çalışır.

    Parametreler: Yok

    Dönüş: Nothing (kendini CBA_fnc_waitAndExecute ile yeniden kuyruğa alır)
*/

// -----------------------------------------------------------------------------
// AĞ KONTROLÜ (MP / HC UYUMLULUĞU)
// Katman 1'in diğer fonksiyonlarıyla aynı standart: yalnızca Sunucu veya
// Headless Client üzerinde çalışır. Oyuncu (client) makinesinde fonksiyon
// hiçbir zamanlama zinciri başlatmadan sessizce sonlanır.
// -----------------------------------------------------------------------------
if (!isServer && hasInterface) exitWith {};

// -----------------------------------------------------------------------------
// DÖNGÜ PERİYODU HESABI
// Varsayılan periyot 30 saniyedir (VBSM_setting_rutinHizi = 1 iken).
// Rutin akış çarpanı yükseldikçe (ör. x2) rutin zamanı daha hızlı akıyormuş
// gibi hissettirmek için periyot kısalır; düştükçe (ör. x0.5) periyot uzar.
// -----------------------------------------------------------------------------
private _VARSAYILAN_PERIYOT = 30;
private _rutinHizi = missionNamespace getVariable ["VBSM_setting_rutinHizi", 1];
private _uykuSuresi = _VARSAYILAN_PERIYOT / (_rutinHizi max 0.1); // 0'a bölünmeye karşı koruma

// -----------------------------------------------------------------------------
// ANA ŞALTER KONTROLÜ
// Simülasyon CBA ayarından kapatılmışsa bu döngüde herhangi bir veri
// güncellemesi yapılmaz; motor tamamen durmak yerine düşük maliyetle
// beklemeye devam eder ki ayar tekrar açıldığında elle yeniden
// başlatmaya gerek kalmasın.
// -----------------------------------------------------------------------------
if !(missionNamespace getVariable ["VBSM_setting_enableSimulation", true]) exitWith {
    [VBSM_fnc_handleRoutines, [], _uykuSuresi] call CBA_fnc_waitAndExecute;
};

// -----------------------------------------------------------------------------
// YORGUNLUK ADIM SABİTLERİ
// Her döngüde ne kadar değişeceğini belirler; ince ayar için tek noktadan
// değiştirilebilir.
// -----------------------------------------------------------------------------
private _YORGUNLUK_UYKU_AZALMA = 0.05;
private _YORGUNLUK_IS_ARTIS = 0.03;
private _YORGUNLUK_IS_TAVAN = 0.8;

private _saat = dayTime; // 0 (00:00) ile 24 (24:00) arası SCALAR

// -----------------------------------------------------------------------------
// SİVİL HAVUZU TARAMASI
// _x, VBSM_var_civilianPool içindeki asıl alt diziye referanstır; "set" ile
// yapılan değişiklik havuzu kopyalamadan doğrudan günceller (ekstra bellek
// tahsisi yok, sunucu/HC dostu).
//
// Şablon indisleri: [0]_uid [1]_className [2]_kabileID [3]_envanter
//                    [4]_rutinDurumu [5]_evKonumu [6]_isKonumu [7]_saglik [8]_yorgunluk
// -----------------------------------------------------------------------------
{
    private _civ = _x;

    if (_saat >= 0 && _saat < 6) then {
        // GECE (00:00 - 06:00): sivil evde uyuyor, nakit parası dokunulmadan
        // korunuyor (İndis 3 -> _envanter, elle değiştirilmiyor).
        _civ set [4, "SLEEPING"];

        private _yorgunluk = _civ select 8;
        _civ set [8, (_yorgunluk - _YORGUNLUK_UYKU_AZALMA) max 0];
    } else {
        if (_saat >= 6 && _saat < 18) then {
            // GÜNDÜZ/İŞ (06:00 - 18:00): sivil çalışıyor, üretim anında
            // envanterine atanmış nakit parası zaten cebindedir.
            _civ set [4, "WORKING"];

            private _yorgunluk = _civ select 8;
            _civ set [8, (_yorgunluk + _YORGUNLUK_IS_ARTIS) min _YORGUNLUK_IS_TAVAN];
        } else {
            // AKŞAM/SOSYAL (18:00 - 24:00): serbest zaman, yorgunluk sabit kalır.
            _civ set [4, "IDLE"];
        };
    };
} forEach VBSM_var_civilianPool;

// -----------------------------------------------------------------------------
// ÖZ-YİNELEMELİ YENİDEN ZAMANLAMA
// waitUntil/eachFrame yerine CBA'nın unscheduled uyumlu kuyruk yapısı
// kullanılır; VM thread'i bloklanmaz.
// -----------------------------------------------------------------------------
[VBSM_fnc_handleRoutines, [], _uykuSuresi] call CBA_fnc_waitAndExecute;
