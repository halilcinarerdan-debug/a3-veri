#define VBS_DB_PROTOCOL "SQL_CUSTOM_V2"

/*
 * Function: vbs_fnc_execute
 *
 * Description:
 *   extDB3 uzerinden asenkron INSERT/UPDATE/DELETE gonderir. "At ve unut":
 *   sonuc/onay beklenmez, callback tutulmaz, hicbir sekilde ana thread'i
 *   veya cagiran kodu bloklamaz. Riot/olay loglama gibi yuksek frekansli
 *   yazimlar icin tasarlanmistir.
 *
 * Arguments:
 *   0: _queryName <STRING> - extdb3-conf.ini SQL_CUSTOM_V2 blok adi
 *   1: _params    <ARRAY>  - Prepared statement input parametreleri (sirali)
 *
 * Return Value:
 *   BOOL - istegin extDB3'a gonderilip gonderilmedigi (DB yazma basarisi degil)
 *
 * Example:
 *   ["AddCivilianMemory", [_civilianId, _soldierUid, "ACE_ARREST", -20]] call vbs_fnc_execute;
 *
 * Public: Yes
 */

if (!isServer) exitWith {
    diag_log text "[VBS_DB] vbs_fnc_execute: sadece sunucu extDB3'e baglanir, cagri HC/client'tan reddedildi.";
    false
};

params [
    ["_queryName", "", [""]],
    ["_params", [], [[]]]
];

if (_queryName == "") exitWith {
    diag_log text "[VBS_DB] vbs_fnc_execute: bos query adi, istek reddedildi.";
    false
};

// Sadece extDB3 log korelasyonu icin; SQF tarafinda hicbir callback kaydi tutulmaz.
private _requestId = format ["%1%2", floor (diag_tickTime * 1000), floor (random 100000)];

// Parametreler ":" ile ayrilir; deger icinde ":" gecmemesi extdb3-conf.ini
// SQL_CUSTOM_V2 protokolunun kendi kisitidir, bu katmanda escape edilmez.
private _paramStr = "";
{
    _paramStr = _paramStr + ":" + (if (_x isEqualType "") then { _x } else { str _x });
} forEach _params;

"extDB3" callExtension format ["%1:%2:%3%4", _requestId, VBS_DB_PROTOCOL, _queryName, _paramStr];

true
