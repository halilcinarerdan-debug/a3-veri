/*
    Fonksiyon: AFTTP_fnc_heartsAndMinds
    Dosya:     fn_heartsAndMinds.sqf

    Dinamik Itibar / Populasyon Istikrari Motoru.

    Bu dosya da (fn_initIntelModule.sqf gibi) IKI modda calisan tek bir
    giris noktasidir:

    MOD A) Ic API cagrisi: ["riotStart", [_town, _pos, _radius]] veya
           ["riotStop", [_town]] seklinde CAGRILIR (postInit disinda,
           oyun ici herhangi bir anda). Sadece sunucuda islenir.

    MOD B) CfgFunctions "postInit = 1" ile parametresiz (_this == [])
           olarak HER MAKINEDE bir kez calisir ve:
             - Sivil olum takibi (CBA "Killed" class EH) -> yanlislikla/
               kasitli sivil oldurme sempatiyi hizla dusurur,
             - Havaya/pervasizca ates acma takibi (CBA "FiredNear" class EH)
               -> yakinlardaki sehrin sempatisini kademeli dusurur ve
               devam eden bir isyani aninda dagitir (uyari atesi etkisi),
             - Flashbang / patlama takibi (CBA "Explosion" class EH) ->
               devam eden bir isyani aninda dagitir,
             - ACE mühimmat/erzak kasasi teslimati taramasi (dusuk
               frekansli CBA_fnc_addPerFrameHandler, ASLA eachFrame degil)
               -> sempatiyi kalici olarak artirir ve sivilleri oyunculara
               el salladirir,
             - LAMBS Danger FSM ile uyumlu, MP-guvenli riot baslat/durdur
               fonksiyonlarini tanimlar.

    Parametreler:
        MOD A icin: [_action <STRING>, _data <ARRAY>]
        MOD B icin: [] (bos)

    Donus: Yok (riotStart/riotStop cagrilarinda da bos doner)
*/

params [["_action", "", [""]], ["_data", [], [[]]]];

// ===========================================================================
// MOD A - Ic API: riot baslat / durdur
// ===========================================================================
if (_action != "") exitWith {
    if (!isServer) exitWith {};

    if (isNil "AFTTP_riotActive") then { AFTTP_riotActive = createHashMap; };
    if (isNil "AFTTP_activeRiotCivilians") then { AFTTP_activeRiotCivilians = createHashMap; };

    switch (_action) do {
        case "riotStart": {
            _data params ["_town", "_pos", "_radius"];

            if (AFTTP_riotActive getOrDefault [_town, false]) exitWith {};
            AFTTP_riotActive set [_town, true];

            private _civilians = (_pos nearEntities [["Civilian"], _radius]) select { alive _x };
            AFTTP_activeRiotCivilians set [_town, _civilians];

            [_civilians] remoteExec ["AFTTP_fnc_startRiotLocal", 0];

            // Mudahale olmasa dahi 4 dakika sonra kendiliginden sakinlesir.
            [_town] spawn {
                params ["_town"];
                sleep 240;
                ["riotStop", [_town]] call AFTTP_fnc_heartsAndMinds;
            };
        };

        case "riotStop": {
            _data params ["_town"];

            if !(AFTTP_riotActive getOrDefault [_town, false]) exitWith {};
            AFTTP_riotActive set [_town, false];

            private _civilians = AFTTP_activeRiotCivilians getOrDefault [_town, []];
            [_civilians] remoteExec ["AFTTP_fnc_stopRiotLocal", 0];
        };
    };
};

// ===========================================================================
// MOD B - Mission postInit: Heart & Minds motorunun kurulumu
// ===========================================================================

if (!isNil "AFTTP_heartsAndMinds_ready") exitWith {};
AFTTP_heartsAndMinds_ready = true;

// ---------------------------------------------------------------------------
// Sunucu-yetkili sempati degistirici. Kritik esikte (<=5) o sehir/taraf
// icin istihbarat sansini KALICI olarak sifirlar ve otomatik riot tetikler.
// ---------------------------------------------------------------------------
AFTTP_fnc_adjustSympathy = {
    params ["_town", "_side", "_delta"];

    if (!isServer) exitWith {};
    if (isNil "AFTTP_sympathy") then { AFTTP_sympathy = createHashMap; };
    if (isNil "AFTTP_intelPermanentlyDenied") then { AFTTP_intelPermanentlyDenied = createHashMap; };
    if (isNil "AFTTP_townPositions") then { AFTTP_townPositions = createHashMap; };

    private _current = [_town, _side] call AFTTP_fnc_getSympathy;
    private _new = 0 max ((_current + _delta) min 100);
    private _key = format ["%1#%2", _town, str _side];

    AFTTP_sympathy set [_key, _new];
    [_key, _new] remoteExec ["AFTTP_fnc_syncSympathy", 0];

    if (_new <= 5) then {
        AFTTP_intelPermanentlyDenied set [_key, true];

        private _pos = AFTTP_townPositions getOrDefault [_town, [0, 0, 0]];
        if (_pos isNotEqualTo [0, 0, 0]) then {
            ["riotStart", [_town, _pos, 400]] call AFTTP_fnc_heartsAndMinds;
        };
    };

    _new
};

// ---------------------------------------------------------------------------
// CBA Class Event Handler: sivil oldurme -> sempati cezasi
// ---------------------------------------------------------------------------
["Civilian", "Killed", {
    params ["_civilian", ["_killer", objNull]];

    if (!isServer) exitWith {};
    if (isNull _killer || {!isPlayer _killer}) exitWith {};

    private _town = [getPosATL _civilian] call AFTTP_fnc_getTownKey;
    [_town, side _killer, -25] call AFTTP_fnc_adjustSympathy;
}, true] call CBA_fnc_addClassEventHandler;

// ---------------------------------------------------------------------------
// CBA Class Event Handler: yakinda ates edildi -> pervasiz ates cezasi
// ve devam eden bir isyani aninda dagitir (uyari atesi etkisi).
// ---------------------------------------------------------------------------
["Civilian", "FiredNear", {
    params ["_civilian", "", "", "", "", "", "", ["_gunner", objNull]];

    if (isServer) then {
        if (!isNull _gunner && {isPlayer _gunner}) then {
            private _lastPenalty = _civilian getVariable ["AFTTP_lastFirePenalty", 0];
            if ((serverTime - _lastPenalty) > 10) then {
                _civilian setVariable ["AFTTP_lastFirePenalty", serverTime];
                private _town = [getPosATL _civilian] call AFTTP_fnc_getTownKey;
                [_town, side _gunner, -3] call AFTTP_fnc_adjustSympathy;
            };
        };

        if (_civilian getVariable ["AFTTP_isRioting", false]) then {
            private _town = [getPosATL _civilian] call AFTTP_fnc_getTownKey;
            ["riotStop", [_town]] call AFTTP_fnc_heartsAndMinds;
        };
    };
}, true] call CBA_fnc_addClassEventHandler;

// ---------------------------------------------------------------------------
// CBA Class Event Handler: yakinda patlama (Flashbang vb.) -> isyan dagilir.
// ---------------------------------------------------------------------------
["Civilian", "Explosion", {
    params ["_civilian"];

    if (isServer) then {
        if (_civilian getVariable ["AFTTP_isRioting", false]) then {
            private _town = [getPosATL _civilian] call AFTTP_fnc_getTownKey;
            ["riotStop", [_town]] call AFTTP_fnc_heartsAndMinds;
        };
    };
}, true] call CBA_fnc_addClassEventHandler;

// ---------------------------------------------------------------------------
// ACE Erzak/Muhimmat kasasi teslimati taramasi.
// eachFrame DEGILDIR: sadece sunucu, 20 saniyede bir, dusuk maliyetli
// bir kontrol yapar (CBA_fnc_addPerFrameHandler "interval" modunda).
// ---------------------------------------------------------------------------
if (isServer) then {
    [{
        if (isNil "AFTTP_townPositions") exitWith {};

        {
            private _crate = _x;
            if !(_crate getVariable ["AFTTP_aidClaimed", false]) then {
                private _town = [getPosATL _crate] call AFTTP_fnc_getTownKey;

                if (_town in AFTTP_townPositions) then {
                    private _nearPlayers = (_crate nearEntities [["Man"], 30]) select { isPlayer _x };

                    if (_nearPlayers isNotEqualTo []) then {
                        _crate setVariable ["AFTTP_aidClaimed", true];

                        private _deliverer = _nearPlayers select 0;
                        [_town, side _deliverer, 15] call AFTTP_fnc_adjustSympathy;

                        {
                            if (alive _x) then { _x playActionNow "Wave"; };
                        } forEach (_crate nearEntities [["Civilian"], 25]);
                    };
                };
            };
        } forEach (allMissionObjects "ReammoBox_F");
    }, 20, []] call CBA_fnc_addPerFrameHandler;
};

// ---------------------------------------------------------------------------
// Riot davranisi: LAMBS Danger FSM'inden kontrolu gecici olarak alir.
// SADECE unit'in LOCAL oldugu makinede calisir (remoteExec target 0).
// ---------------------------------------------------------------------------
AFTTP_fnc_startRiotLocal = {
    params ["_civilians"];

    {
        private _civ = _x;
        if (local _civ && {alive _civ}) then {
            // LAMBS Danger FSM'i devre disi birak - sivil dongulerini ezmesin diye
            // kontrolu gecici olarak biz aliyoruz.
            _civ setVariable ["lambs_danger_disableAI", true];

            _civ setCaptive false;
            _civ setUnitPos "UP";
            _civ setBehaviour "AWARE";
            _civ setCombatMode "RED";
            _civ setVariable ["AFTTP_isRioting", true];

            _civ spawn {
                params ["_civ"];
                while {alive _civ && {_civ getVariable ["AFTTP_isRioting", false]}} do {
                    private _targets = allPlayers select {
                        alive _x && {side _x != civilian} && {_civ distance _x < 60}
                    };

                    if (_targets isNotEqualTo []) then {
                        private _tgt = selectRandom _targets;
                        _civ doMove (getPosATL _tgt);
                    };

                    sleep (5 + random 5);
                };
            };
        };
    } forEach _civilians;
};

AFTTP_fnc_stopRiotLocal = {
    params ["_civilians"];

    {
        private _civ = _x;
        if (local _civ) then {
            _civ setVariable ["AFTTP_isRioting", false];
            _civ doStop [];
            _civ setBehaviour "SAFE";
            _civ setCombatMode "BLUE";
            _civ setUnitPos "AUTO";

            // Kontrolu guvenli sekilde LAMBS Danger FSM'ine geri devret.
            _civ setVariable ["lambs_danger_disableAI", false];
        };
    } forEach _civilians;
};
