/*
    Fonksiyon: AFTTP_fnc_initIntelModule
    Dosya:     fn_initIntelModule.sqf

    Bu dosya IKI FARKLI tetikleyiciyle calisan tek bir giris noktasidir:

    DAL A) Zeus modulu "AFTTP_ModuleRiotTrigger" haritaya yerlestirilip
           aktive edildiginde, CfgVehicles > EventHandlers > ADDON > init
           uzerinden [_logic] parametresiyle cagrilir. Sadece sunucuda
           (isServer) calisir ve o noktaya en yakin yerlesim biriminde
           aninda bir sivil ayaklanma (riot) tetikler.

    DAL B) CfgFunctions "postInit = 1" sayesinde, sunucu dahil HER
           MAKINEDE mission postInit sirasinda parametresiz (_this == [])
           olarak bir kez calisir ve:
             - 3 adet CBA_fnc_addSetting SLIDER'ini kaydeder
               (BLUFOR / OPFOR / INDEPENDENT sivil sempati baz degeri),
             - ACE3 Etkilesim Menusu'ne "Istihbarat Topla" aksiyonunu
               TEK SEFERDE, sinif bazli (ace_interact_menu_fnc_addActionToClass)
               olarak "Civilian" sinifina baglar (0 bottleneck, eachFrame yok),
             - CBA Class Event Handler (Civilian + InitPost) ile haritada
               dogan/spawn olan HER siville baslangic degiskenlerini atar,
             - Anti-spam / cooldown ve MP senkronizasyonu icin gereken
               tum server-authoritative yardimci fonksiyonlari tanimlar.

    Parametreler:
        DAL A icin: [_logic] <OBJECT (Zeus Logic)>
        DAL B icin: [] (bos)

    Donus: Yok
*/

params [["_logic", objNull, [objNull]]];

// ===========================================================================
// DAL A - Zeus "AFTTP_ModuleRiotTrigger" modulu yerlestirildi/aktive edildi
// ===========================================================================
if (!isNull _logic) exitWith {
    if (!isServer) exitWith {};

    private _pos = getPosATL _logic;
    private _town = [_pos] call AFTTP_fnc_getTownKey;

    ["riotStart", [_town, _pos, 400]] call AFTTP_fnc_heartsAndMinds;
};

// ===========================================================================
// DAL B - Mission postInit: Kalici Sivil Istihbarat Sistemi kurulumu
// ===========================================================================

// Bu dal her makinede sadece BIR KEZ calisir.
if (!isNil "AFTTP_intel_systemReady") exitWith {};
AFTTP_intel_systemReady = true;

// --- Sunucu tarafi veri havuzu (sempati / konum onbellegi) ----------------
if (isServer) then {
    if (isNil "AFTTP_sympathy") then { AFTTP_sympathy = createHashMap; };
    if (isNil "AFTTP_townPositions") then { AFTTP_townPositions = createHashMap; };
    if (isNil "AFTTP_intelPermanentlyDenied") then { AFTTP_intelPermanentlyDenied = createHashMap; };
};

// ---------------------------------------------------------------------------
// CBA Settings: 3 x Sivil Sempati SLIDER (0-100)
// ---------------------------------------------------------------------------
["AFTTP_sympathy_west", "SLIDER",
    ["[AFTTP] BLUFOR Sivil Sempati Baz Degeri", "Bolgedeki sivil halkin BLUFOR kuvvetlerine karsi baslangic sempati seviyesi (0-100)"],
    "AFTTP Kontrgerilla (COIN)",
    [0, 100, 60, 0],
    true
] call CBA_fnc_addSetting;

["AFTTP_sympathy_east", "SLIDER",
    ["[AFTTP] OPFOR Sivil Sempati Baz Degeri", "Bolgedeki sivil halkin OPFOR kuvvetlerine karsi baslangic sempati seviyesi (0-100)"],
    "AFTTP Kontrgerilla (COIN)",
    [0, 100, 40, 0],
    true
] call CBA_fnc_addSetting;

["AFTTP_sympathy_indep", "SLIDER",
    ["[AFTTP] INDEPENDENT Sivil Sempati Baz Degeri", "Bolgedeki sivil halkin INDEPENDENT kuvvetlerine karsi baslangic sempati seviyesi (0-100)"],
    "AFTTP Kontrgerilla (COIN)",
    [0, 100, 50, 0],
    true
] call CBA_fnc_addSetting;

// ---------------------------------------------------------------------------
// Yardimci global fonksiyonlar (butun makinelerde tanimli)
// ---------------------------------------------------------------------------

// Bir pozisyona en yakin yerlesim biriminin benzersiz anahtarini dondurur.
// Ayni zamanda o yerlesim biriminin pozisyonunu (riot / aid taramasi icin) onbellege alir.
AFTTP_fnc_getTownKey = {
    params ["_pos"];

    private _locs = nearestLocations [_pos, ["NameCityCapital", "NameCity", "NameVillage"], 3000];
    if (_locs isEqualTo []) exitWith { "AFTTP_UnknownArea" };

    private _loc = _locs select 0;
    private _key = text _loc;

    if (isNil "AFTTP_townPositions") then { AFTTP_townPositions = createHashMap; };
    AFTTP_townPositions set [_key, locationPosition _loc];

    _key
};

// Belirli bir yerlesim biriminin, belirli bir taraf icin GUNCEL sempati puanini dondurur.
// Hic kayit yoksa CBA ayarlarindaki baz degeri kullanir.
AFTTP_fnc_getSympathy = {
    params ["_town", "_side"];

    private _default = 50;
    if (_side isEqualTo west) then { _default = AFTTP_sympathy_west; };
    if (_side isEqualTo east) then { _default = AFTTP_sympathy_east; };
    if (_side isEqualTo independent) then { _default = AFTTP_sympathy_indep; };

    if (isNil "AFTTP_sympathy") exitWith { _default };

    private _key = format ["%1#%2", _town, str _side];
    AFTTP_sympathy getOrDefault [_key, _default, true]
};

// ---------------------------------------------------------------------------
// ACE3 "Istihbarat Topla" aksiyonu: statement / condition
// ---------------------------------------------------------------------------

private _AFTTP_intelStatement = {
    params ["_target", "_player", "_params"];
    [_target, _player] remoteExec ["AFTTP_fnc_serverGatherIntel", 2];
};

private _AFTTP_intelCondition = {
    params ["_target", "_player", "_params"];
    alive _target
    && {side _target == civilian}
    && {!(_target getVariable ["AFTTP_intel_locked", false])}
};

private _AFTTP_intelAction = [
    "AFTTP_GatherIntel",
    "Istihbarat Topla",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa",
    _AFTTP_intelStatement,
    _AFTTP_intelCondition,
    {},
    [],
    "",
    4
] call ace_interact_menu_fnc_createAction;

// TEK SEFERLIK, sinif bazli baglama - "Civilian" sinifindaki HER nesne icin
// otomatik olarak gecerlidir. Per-object dongu / eachFrame yoktur.
["Civilian", 0, [], _AFTTP_intelAction] call ace_interact_menu_fnc_addActionToClass;

// ---------------------------------------------------------------------------
// CBA Class Event Handler: haritada dogan/spawn olan HER siville
// baslangic degiskenlerini atar (0 bottleneck, sadece bir kez per-unit).
// ---------------------------------------------------------------------------
["Civilian", "InitPost", {
    params ["_civilian"];
    if (isServer) then {
        if (isNil {_civilian getVariable "AFTTP_intel_locked"}) then {
            _civilian setVariable ["AFTTP_intel_locked", false, true];
            _civilian setVariable ["AFTTP_intel_cooldownUntil", 0];
            _civilian setVariable ["AFTTP_isRioting", false];
        };
    };
}, true] call CBA_fnc_addClassEventHandler;

// ---------------------------------------------------------------------------
// Sunucu-yetkili (server-authoritative) istihbarat toplama mantigi.
// Client, ACE aksiyonu tetiklendiginde bunu [2] (sadece sunucu) hedefiyle
// remoteExec eder; TUM dogrulama ve kilit islemleri burada, sunucuda yapilir.
// ---------------------------------------------------------------------------
AFTTP_fnc_serverGatherIntel = {
    params ["_civilian", "_player"];

    if (!isServer) exitWith {};
    if (isNull _civilian || {!alive _civilian} || {isNull _player} || {!alive _player}) exitWith {};

    private _requester = owner _player;

    // --- ANTI-SPAM / COOLDOWN: sunucu tarafinda dogrulanir ----------------
    private _now = serverTime;
    private _cooldownUntil = _civilian getVariable ["AFTTP_intel_cooldownUntil", 0];
    if (_now < _cooldownUntil) exitWith {
        ["AFTTP_Refuse"] remoteExec ["AFTTP_fnc_clientIntelFeedback", _requester];
    };

    // --- TERCUMAN KONTROLU: sadece BLUFOR (west) icin gecerlidir ----------
    private _hasInterpreter = true;
    if (side _player == west) then {
        private _interpreters = (_player nearEntities [["Man"], 15]) select {
            alive _x && {_x getVariable ["AFTTP_isInterpreter", false]}
        };
        _hasInterpreter = (_interpreters isNotEqualTo []) || {_player getVariable ["AFTTP_isInterpreter", false]};
    };

    if (!_hasInterpreter) exitWith {
        ["AFTTP_NoInterpreter"] remoteExec ["AFTTP_fnc_clientIntelFeedback", _requester];
    };

    // --- Kilit + 300 sn (5 dk) cooldown, sunucu tarafinda uygulanir -------
    _civilian setVariable ["AFTTP_intel_locked", true, true];
    _civilian setVariable ["AFTTP_intel_cooldownUntil", _now + 300, true];

    [
        {
            params ["_civ"];
            if (!isNull _civ) then {
                _civ setVariable ["AFTTP_intel_locked", false, true];
            };
        },
        [_civilian],
        300
    ] call CBA_fnc_waitAndExecute;

    // --- Sempati -> istihbarat verme sansi ---------------------------------
    private _town = [getPosATL _civilian] call AFTTP_fnc_getTownKey;
    private _sympathy = [_town, side _player] call AFTTP_fnc_getSympathy;

    private _deniedKey = format ["%1#%2", _town, str (side _player)];
    private _permanentlyDenied = false;
    if (!isNil "AFTTP_intelPermanentlyDenied") then {
        _permanentlyDenied = AFTTP_intelPermanentlyDenied getOrDefault [_deniedKey, false];
    };

    private _chance = if (_permanentlyDenied) then { 0 } else { 5 max _sympathy };

    if ((random 100) < _chance) then {
        private _types = ["IED", "PATROL", "AMBUSH"];
        private _type = selectRandom _types;

        // Gercek (sunucu bilgisi) tehdit konumu
        private _truePos = _civilian getPos [50 + random 250, random 360];

        // Haritaya cizilecek isaretin 200m hata payli, bulanik konumu
        private _errAngle = random 360;
        private _errDist = random 200;
        private _errorPos = [
            (_truePos select 0) + _errDist * sin _errAngle,
            (_truePos select 1) + _errDist * cos _errAngle,
            0
        ];

        private _hasMap = "ItemMap" in (items _player);

        if (_hasMap) then {
            private _markerName = format ["AFTTP_intel_%1_%2", netId _civilian, round _now];
            [_markerName, _errorPos, _type] remoteExec ["AFTTP_fnc_drawIntelMarker", 0];

            // 180 sn (3 dk) sonra asenkron olarak haritadan otomatik silinir.
            [_markerName] spawn {
                params ["_marker"];
                sleep 180;
                [_marker] remoteExec ["AFTTP_fnc_deleteIntelMarker", 0];
            };
        };

        // "Surada IED var" -> gercek bir mayin objesi, tamamen sunucu tarafinda spawn edilir.
        if (_type == "IED") then {
            private _mine = createMine ["APERSMine", _truePos, [], 0];
            _mine setVariable ["AFTTP_intelSpawned", true];
        };

        [(if (_hasMap) then {"AFTTP_Success"} else {"AFTTP_SuccessNoMap"}), _type] remoteExec ["AFTTP_fnc_clientIntelFeedback", _requester];
    } else {
        ["AFTTP_NoIntel"] remoteExec ["AFTTP_fnc_clientIntelFeedback", _requester];
    };
};

// ---------------------------------------------------------------------------
// Sunucu -> tekil istemci: oyuncuya sonucu bildirir (hint).
// ---------------------------------------------------------------------------
AFTTP_fnc_clientIntelFeedback = {
    params [["_code", "", [""]], ["_type", "", [""]]];

    private _threatNames = createHashMapFromArray [
        ["IED", "El yapimi patlayici (IED)"],
        ["PATROL", "Dusman devriyesi"],
        ["AMBUSH", "Pusu bolgesi"]
    ];

    private _msg = switch (_code) do {
        case "AFTTP_Refuse": { "Sivil: 'Sana zaten anlatacak bir seyim yok, beni rahat birak!'" };
        case "AFTTP_NoInterpreter": { "Sivil: 'Anlamiyorum...' (Yaninda gorevli bir Tercuman olmadan iletisim kuramazsin.)" };
        case "AFTTP_NoIntel": { "Sivil: 'Bilmiyorum, gercekten bir sey gormedim.'" };
        case "AFTTP_Success": { format ["Sivil konustu! Tespit edilen tehdit: %1", (_threatNames getOrDefault [_type, _type])] };
        case "AFTTP_SuccessNoMap": { "Sivil konustu, fakat uzerinde Taktik Harita (ItemMap) olmadigi icin bilgiyi isaretleyemedin!" };
        default { "" };
    };

    if (_msg != "") then { hint _msg; };
};

// ---------------------------------------------------------------------------
// Sunucu -> herkes: sempati onbellegini yerel olarak gunceller (HUD/UI icin).
// ---------------------------------------------------------------------------
AFTTP_fnc_syncSympathy = {
    params ["_key", "_value"];
    if (isNil "AFTTP_sympathy") then { AFTTP_sympathy = createHashMap; };
    AFTTP_sympathy set [_key, _value];
};

// ---------------------------------------------------------------------------
// Sunucu -> herkes: istihbarat marker'ini YEREL olarak cizer / siler.
// ---------------------------------------------------------------------------
AFTTP_fnc_drawIntelMarker = {
    params ["_markerName", "_pos", "_type"];

    if (_markerName in allMapMarkers) exitWith {};

    private _marker = createMarkerLocal [_markerName, _pos];
    _marker setMarkerShapeLocal "ELLIPSE";
    _marker setMarkerBrushLocal "SolidBorder";
    _marker setMarkerSizeLocal [200, 200];
    _marker setMarkerColorLocal "ColorRed";
    _marker setMarkerAlphaLocal 0.6;

    private _labels = createHashMapFromArray [
        ["IED", "Supheli Bolge - IED"],
        ["PATROL", "Supheli Bolge - Dusman Devriyesi"],
        ["AMBUSH", "Supheli Bolge - Pusu"]
    ];
    _marker setMarkerTextLocal (_labels getOrDefault [_type, "Supheli Bolge"]);
};

AFTTP_fnc_deleteIntelMarker = {
    params ["_markerName"];
    if (_markerName in allMapMarkers) then {
        deleteMarkerLocal _markerName;
    };
};
