#include "\vbsm_main\vbsm_core\vbsm_cognitive_indices.hpp"
/*
    Fonksiyon: VBSM_fnc_civPoolAdd
    Dosya    : vbsm_main\vbsm_layer1_physical\fn_civPoolAdd.sqf
    Proje    : VBSM: Operational Environment Simulation (VBSM: OES)
    Katman   : 1 - Fiziksel Varlık / 2 - Bilişsel Ajan (Kişilik-Duygu-İnanç)
    Ortam    : Yalnızca Sunucu (Dedicated/Listen) ve Headless Client (HC)
    Açıklama :
        [adet, kabileID] argümanlarını alır; haritada ünite doğurmadan,
        O(1) UID sayacı ile sanal sivil kayıtları üretip
        VBSM_var_civilianPool ana havuzuna pushBack eder. Her kayıt,
        Katman 2 kapsamında bir Kişilik Arketipine göre ağırlıklı
        olarak üretilir ve bu arketipe bağlı Duygu taban değerleriyle
        başlatılır. İndis tanımları için bkz:
        \vbsm_main\vbsm_core\vbsm_cognitive_indices.hpp

    Parametreler:
        0: _adet         <SCALAR>  -> Eklenecek sivil sayısı (>=1)
        1: _kabileIDParam<SCALAR>  -> Sabit kabile ID (>0). <=0 ise rastgele.

    Dönüş: ARRAY -> Bu çağrıda eklenen sivillerin _uid listesi
*/

// -----------------------------------------------------------------------------
// AĞ KONTROLÜ (MP / HC UYUMLULUĞU)
// -----------------------------------------------------------------------------
if (!isServer && hasInterface) exitWith { [] };

// -----------------------------------------------------------------------------
// PARAMETRE DOĞRULAMA
// -----------------------------------------------------------------------------
params [
    ["_adet", 0, [0]],
    ["_kabileIDParam", -1, [0]]
];

// Adet: sıfır veya negatifse çık; kayan nokta girişini güvenle floor'la
_adet = floor _adet;
if (_adet <= 0) exitWith { [] };

// Havuz yoksa uyar: initPhysicalLayer henüz çağrılmadı.
if (isNil "VBSM_var_civilianPool") then {
    VBSM_var_civilianPool = [];
};

// -----------------------------------------------------------------------------
// STATİK SINIF HAVUZU (RHS Civilian)
// -----------------------------------------------------------------------------
private _rhsCivClasses = [
    "rds_civil_assistant",
    "rds_civil_worker",
    "rds_civil_doctor",
    "rds_civil_villager",
    "rds_civil_merchant"
];

// -----------------------------------------------------------------------------
// KATMAN 2: KİŞİLİK ARKETİP TABLOSU
// Her arketip, [KorkuEşigi, İtaatEgilimi, MilliyetciAsilik, RusvetYatkinligi]
// için [min, max] aralığı tanımlar (0..1). Dağılım toplum profilini yansıtır:
// nüfusun çoğunluğu Korkak/İtaatkar, azınlığı Asi/Çıkarcı arketiptedir.
// -----------------------------------------------------------------------------
private _arketipSecimi = selectRandomWeighted [
    "KORKAK",   30,
    "ASI",      20,
    "ITAATKAR", 30,
    "CIKARCI",  20
];

private _kisilikAraliklari = switch (_arketipSecimi) do {
    // Korkak: kolay korkar, otoriteye itaat eder, asi eğilimi düşük.
    case "KORKAK": { [[0.05, 0.30], [0.55, 0.85], [0.05, 0.30], [0.30, 0.60]] };
    // Asi: korkuya karşı dirençli, itaat düşük, milliyetçi asilik yüksek.
    case "ASI": { [[0.65, 0.95], [0.10, 0.35], [0.60, 0.90], [0.05, 0.30]] };
    // İtaatkar: orta-yüksek korku direnci, itaat çok yüksek, asilik en düşük.
    case "ITAATKAR": { [[0.35, 0.65], [0.75, 0.95], [0.00, 0.20], [0.05, 0.25]] };
    // Çıkarcı: dengeli korku/itaat, düşük ideolojik bağlılık, yüksek rüşvet yatkınlığı.
    default { [[0.30, 0.60], [0.30, 0.55], [0.05, 0.25], [0.55, 0.85]] };
};

private _korkuAraligi      = _kisilikAraliklari select 0;
private _itaatAraligi      = _kisilikAraliklari select 1;
private _milliyetciAraligi = _kisilikAraliklari select 2;
private _rusvetAraligi     = _kisilikAraliklari select 3;

// -----------------------------------------------------------------------------
// KATMAN 2: İSTİHBARAT TOHUM HAVUZU (%15 enjeksiyon ihtimali)
// -----------------------------------------------------------------------------
private _istihbaratTipHavuzu = [
    ["MUHIMMAT_DEPOSU",  round (random 100)],
    ["IED_IHBARI",       [0, 0, 0]],
    ["DUSMAN_HAREKETI",  1 + floor (random 8)],
    ["SILAH_KAYNAGI",    round (random 100)]
];

// -----------------------------------------------------------------------------
// O(1) UID SAYACI
// İlk çağrıda havuz bir kez taranır (one-shot O(n)); sonrası sabit maliyet.
// -----------------------------------------------------------------------------
if (isNil "VBSM_var_civPoolLastUID") then {
    private _maxUID = 0;
    {
        private _uid = _x param [CIV_INDEX_UID, 0, [0]];
        if (_uid > _maxUID) then { _maxUID = _uid };
    } forEach VBSM_var_civilianPool;
    VBSM_var_civPoolLastUID = _maxUID;
};

// -----------------------------------------------------------------------------
// ÜRETİM DÖNGÜSÜ
// -----------------------------------------------------------------------------
private _eklenenUIDler = [];
private _havuz = VBSM_var_civilianPool; // Referans — pushBack için tek nokta

for "_i" from 1 to _adet do {
    VBSM_var_civPoolLastUID = VBSM_var_civPoolLastUID + 1;
    private _uid = VBSM_var_civPoolLastUID;

    private _className = selectRandom _rhsCivClasses;

    private _kabileID = if (_kabileIDParam > 0) then {
        _kabileIDParam
    } else {
        selectRandom [1, 2, 3]
    };

    // Envanter: [nakit 10-100, [], []]
    private _nakitPara = 10 + floor (random 91);

    // --- KATMAN 2: KİŞİLİK (statik, arketipe göre ağırlıklı) ---
    private _korkuEsigi       = (_korkuAraligi select 0) + random ((_korkuAraligi select 1) - (_korkuAraligi select 0));
    private _itaatEgilimi     = (_itaatAraligi select 0) + random ((_itaatAraligi select 1) - (_itaatAraligi select 0));
    private _milliyetciAsilik = (_milliyetciAraligi select 0) + random ((_milliyetciAraligi select 1) - (_milliyetciAraligi select 0));
    private _rusvetYatkinligi = (_rusvetAraligi select 0) + random ((_rusvetAraligi select 1) - (_rusvetAraligi select 0));

    private _kisilikYapisi = [_korkuEsigi, _itaatEgilimi, _milliyetciAsilik, _rusvetYatkinligi];

    // --- KATMAN 2: DUYGU (dinamik, kişilikten türetilen taban değer) ---
    // Düşük korku eşiği -> yüksek başlangıç korkusu. Oyuncu güveni henüz
    // temas kurulmadığı için nötr başlar. Yerel öfke, milliyetçi/asi
    // eğilimin zemin seviyesini yansıtır.
    private _anlikKorku    = (1 - _korkuEsigi) * 0.3;
    private _oyuncuyaGuven = 0.5;
    private _yerelOfke     = _milliyetciAsilik * 0.3;

    private _duyguYapisi = [_anlikKorku, _oyuncuyaGuven, _yerelOfke];

    // --- KATMAN 2: HAFIZA ([GorulenOlaylar, BilinenIstihbarat], %15 tohum) ---
    private _bilinenIstihbarat = [];
    if (random 1 < 0.15) then {
        _bilinenIstihbarat pushBack (selectRandom _istihbaratTipHavuzu);
    };
    private _hafizaYapisi = [[], _bilinenIstihbarat];

    // --- KATMAN 2: İNANÇ (yarı-statik, -1..1) ---
    private _kabileBagliligi    = 0.3 + random 0.4;
    private _fraksiyonSempatisi = (_milliyetciAsilik - 0.5) * 2;
    private _inancYapisi = [_kabileBagliligi, _fraksiyonSempatisi];

    // --- KATMAN 2: NİYET (dinamik karar, Katman 1 için nötr başlangıç) ---
    private _niyetYapisi = ["NONE", 0];

    private _sivilKaydi = [
        _uid,                          // CIV_INDEX_UID
        _className,                    // CIV_INDEX_CLASS
        _kabileID,                     // CIV_INDEX_KABILE
        [_nakitPara, [], []],          // CIV_INDEX_INVENTORY
        "IDLE",                        // CIV_INDEX_ROUTINE
        [0, 0, 0],                     // CIV_INDEX_HOME
        [0, 0, 0],                     // CIV_INDEX_WORK
        1,                              // CIV_INDEX_HEALTH
        0,                              // CIV_INDEX_FATIGUE
        _kisilikYapisi,                 // CIV_INDEX_PERSONALITY
        _duyguYapisi,                   // CIV_INDEX_EMOTION
        _hafizaYapisi,                  // CIV_INDEX_MEMORY
        _inancYapisi,                   // CIV_INDEX_BELIEF
        _niyetYapisi                    // CIV_INDEX_INTENT
    ];

    _havuz pushBack _sivilKaydi;
    _eklenenUIDler pushBack _uid;
};

_eklenenUIDler
