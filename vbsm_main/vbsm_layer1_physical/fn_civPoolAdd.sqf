/*
    Fonksiyon: VBSM_fnc_civPoolAdd
    Dosya    : vbsm_main\vbsm_layer1_physical\fn_civPoolAdd.sqf
    Proje    : VBSM: Operational Environment Simulation (VBSM: OES)
    Katman   : 1 - Fiziksel Varlık (Sivil Havuzu, Envanter, Rutin)
    Ortam    : Yalnızca Sunucu (Dedicated/Listen Server) ve Headless Client (HC)

    Açıklama:
    VBSM_var_civilianPool dizisini yeni sivil kayıtlarıyla doldurur. Bu
    fonksiyon SALT VERİ üretir; haritada hiçbir fiziksel nesne (createUnit
    vb.) OLUŞTURMAZ. Spawn işlemi Katman 5 - Sanal Dünya'nın sorumluluğundadır.

    Parametreler:
        0: _adet     SCALAR  -> Üretilecek sivil sayısı (zorunlu)
        1: _kabileID SCALAR  -> Atanacak kabile kimliği (opsiyonel, verilmezse rastgele 1/2/3)

    Kullanım Örnekleri:
        [10]    call VBSM_fnc_civPoolAdd;
        [5, 2]  call VBSM_fnc_civPoolAdd;

    Dönüş: ARRAY -> Bu çağrıda havuza eklenen sivillerin _uid listesi
*/

// -----------------------------------------------------------------------------
// AĞ KONTROLÜ (MP / HC UYUMLULUĞU)
// Katman 1 - fn_initPhysicalLayer.sqf ile aynı standart: yalnızca Sunucu
// veya Headless Client üzerinde çalışır. Oyuncu (client) makinesinde
// (isServer=false, hasInterface=true) fonksiyon sessizce sonlanır.
// -----------------------------------------------------------------------------
if (!isServer && hasInterface) exitWith {
    []
};

params [
    ["_adet", 0, [0]],
    ["_kabileIDParam", -1, [0]]
];

// Geçersiz/anlamsız istekleri en baştan ele
if (_adet <= 0) exitWith {
    []
};

// -----------------------------------------------------------------------------
// RHS SİVİL SINIF HAVUZU
// Yeni sivil üretilirken bu statik listeden rastgele bir sınıf seçilecektir.
// -----------------------------------------------------------------------------
private _rhsCivClasses = [
    "rds_civil_assistant",
    "rds_civil_worker",
    "rds_civil_doctor",
    "rds_civil_villager",
    "rds_civil_merchant"
];

// -----------------------------------------------------------------------------
// UID SAYACI
// VBSM_var_civilianPool içindeki her _uid tekil ve artan olmalıdır. Sayaç,
// ilk çağrıda mevcut havuz taranarak (varsa) en yüksek _uid'nin üzerine
// kurulur; sonraki çağrılarda O(1) olarak artırılır (tekrar tarama yapılmaz).
// -----------------------------------------------------------------------------
if (isNil "VBSM_var_civPoolLastUID") then {
    VBSM_var_civPoolLastUID = 99999;
    {
        private _existingUID = _x select 0;
        if (_existingUID > VBSM_var_civPoolLastUID) then {
            VBSM_var_civPoolLastUID = _existingUID;
        };
    } forEach VBSM_var_civilianPool;
};

private _eklenenUIDler = [];

// -----------------------------------------------------------------------------
// ÜRETİM DÖNGÜSÜ
// -----------------------------------------------------------------------------
for "_i" from 1 to _adet do {
    VBSM_var_civPoolLastUID = VBSM_var_civPoolLastUID + 1;
    private _uid = VBSM_var_civPoolLastUID;

    private _className = selectRandom _rhsCivClasses;

    private _kabileID = if (_kabileIDParam > 0) then {
        _kabileIDParam
    } else {
        selectRandom [1, 2, 3]
    };

    // _envanter: [_nakitPara, _tasınanEsyalar, _yasadisiObjeler]
    private _nakitPara = 10 + floor (random 91); // 10 - 100 arası
    private _envanter = [_nakitPara, [], []];

    private _rutinDurumu = "IDLE";
    private _evKonumu = [0, 0, 0];
    private _isKonumu = [0, 0, 0];
    private _saglik = 1;
    private _yorgunluk = 0;

    private _sivilKaydi = [
        _uid,
        _className,
        _kabileID,
        _envanter,
        _rutinDurumu,
        _evKonumu,
        _isKonumu,
        _saglik,
        _yorgunluk
    ];

    VBSM_var_civilianPool pushBack _sivilKaydi;
    _eklenenUIDler pushBack _uid;
};

_eklenenUIDler
