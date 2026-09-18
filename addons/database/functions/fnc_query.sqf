#define VBS_DB_PROTOCOL "SQL_CUSTOM_V2"
#define VBS_DB_TIMEOUT_SEC 30

/*
 * Function: vbs_fnc_query
 *
 * Description:
 *   extDB3 uzerinden asenkron SELECT/CUSTOM okuma sorgusu gonderir. "extDB3"
 *   callExtension cagrisi sadece istegi extDB3'un kendi worker thread'ine
 *   kuyruklar ve aninda doner; ana thread bu cagriyla asla DB/network
 *   suresince bloklanmaz. Sonuc hazir oldugunda motor "ExtensionCallback"
 *   mission event handler'ini tetikler, biz de bu event'i kendi
 *   requestId -> callback eslesme tablomuzla dogru cagirana yonlendiririz.
 *
 * Arguments:
 *   0: _queryName     <STRING> - extdb3-conf.ini SQL_CUSTOM_V2 blok adi
 *   1: _params        <ARRAY>  - Prepared statement input parametreleri (sirali)
 *   2: _callback      <CODE>   - Sonuc gelince calisir. _this: [_resultRaw, _callbackArgs]
 *   3: _callbackArgs  <ANY>    - (Optional) callback'e oldugu gibi geri verilecek ek veri
 *
 * Return Value:
 *   BOOL - istegin extDB3'a gonderilip gonderilmedigi (DB sonucunun kendisi degil)
 *
 * Example:
 *   ["GetHighRiotCivilians", ["Altis"], {
 *       params ["_resultRaw", "_args"];
 *       systemChat _resultRaw;
 *   }] call vbs_fnc_query;
 *
 * Public: Yes
 */

if (!isServer) exitWith {
    diag_log text "[VBS_DB] vbs_fnc_query: sadece sunucu extDB3'e baglanir, cagri HC/client'tan reddedildi.";
    false
};

params [
    ["_queryName", "", [""]],
    ["_params", [], [[]]],
    ["_callback", {}, [{}]],
    ["_callbackArgs", [], [[]]]
];

if (_queryName == "") exitWith {
    diag_log text "[VBS_DB] vbs_fnc_query: bos query adi, istek reddedildi.";
    false
};

// Global callback dispatcher + bekleyen istek tablosu ilk cagrida bir kez kurulur.
if (isNil "vbs_database_pendingCallbacks") then {
    missionNamespace setVariable ["vbs_database_pendingCallbacks", createHashMap];

    addMissionEventHandler ["ExtensionCallback", {
        params ["_name", "_function", "_data"];
        if (_name != "extDB3") exitWith {};

        // extDB3, gonderdigimiz requestId'yi donen verinin basina "requestId:payload"
        // seklinde ekler; eslemeyi extDB3'un ic protokolune (_function alanina) degil
        // buna gore yapiyoruz.
        private _sepPos = _data find ":";
        if (_sepPos == -1) exitWith {};

        private _requestId = _data select [0, _sepPos];
        private _resultRaw = _data select [_sepPos + 1];

        private _pending = missionNamespace getVariable ["vbs_database_pendingCallbacks", createHashMap];
        private _entry = _pending getOrDefault [_requestId, []];
        if (_entry isEqualTo []) exitWith {};

        _pending deleteAt _requestId;
        [_resultRaw, (_entry select 1)] call (_entry select 0);
    }];

    // Cevabi hic gelmeyen (extDB3 hatasi/timeout) istekleri periyodik temizler,
    // uzun sureli calisan dedicated server'da hashmap'in siniirsiz buyumesini onler.
    [{
        private _pending = missionNamespace getVariable ["vbs_database_pendingCallbacks", createHashMap];
        private _now = diag_tickTime;
        {
            private _entry = _pending get _x;
            if ((_now - (_entry select 2)) > VBS_DB_TIMEOUT_SEC) then {
                diag_log text format ["[VBS_DB] vbs_fnc_query: %1 istegi timeout, temizlendi.", _x];
                _pending deleteAt _x;
            };
        } forEach (keys _pending);
    }, 60, []] call CBA_fnc_addPerFrameHandler;
};

private _requestId = format ["%1%2", floor (diag_tickTime * 1000), floor (random 100000)];

private _pending = missionNamespace getVariable ["vbs_database_pendingCallbacks", createHashMap];
_pending set [_requestId, [_callback, _callbackArgs, diag_tickTime]];

// Parametreler ":" ile ayrilir; deger icinde ":" gecmemesi extdb3-conf.ini
// SQL_CUSTOM_V2 protokolunun kendi kisitidir, bu katmanda escape edilmez.
private _paramStr = "";
{
    _paramStr = _paramStr + ":" + (if (_x isEqualType "") then { _x } else { str _x });
} forEach _params;

"extDB3" callExtension format ["%1:%2:%3%4", _requestId, VBS_DB_PROTOCOL, _queryName, _paramStr];

true
