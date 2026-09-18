#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * vbs_fnc_query ve vbs_fnc_execute'un ortak, private gonderim mantigi.
 * extDB3'e ASENKRON bir SQL_CUSTOM_V2 cagrisi gonderir; sonuc/onay hicbir
 * zaman burada beklenmez (senkron callExtension YOK, ana thread bloklanmaz).
 * Cagrinin kendisini gondermek icin kullanilan callExtension array-form
 * cagrisi anlik/ucuzdur (extension'a bir mesaj birakir, DB I/O'sunu
 * extDB3'un kendi worker thread'i yapar).
 *
 * Arguments:
 * 0: extDB3 sql_custom_v2 ini'sindeki cagri adi <STRING>
 * 1: Prepared statement '?' yerlerine sirali baglanacak degerler <ARRAY>
 * 2: (Opsiyonel) Sonuc/onay gelince calisacak kod: params ["_rows","_args"] <CODE>
 * 3: (Opsiyonel) _callback'e oldugu gibi iletilecek ek veri <ARRAY>
 *
 * Return Value:
 * Gonderim basarili mi (extDB3 istegi kabul etti mi; DB sonucu DEGIL) <BOOL>
 *
 * Public: no
 */

params [
    ["_callName", "", [""]],
    ["_params", [], [[]]],
    ["_callback", {}, [{}]],
    ["_callbackArgs", [], [[]]]
];

if (_callName == "") exitWith {
    ["dispatch: bos callName ile cagrildi, iptal edildi"] call FUNC(log);
    false
};

if !(GVAR(dbHost)) exitWith {
    [format ["dispatch cagrildi ama bu makine DB host degil (sadece server/HC calisir): %1", _callName]] call FUNC(log);
    false
};

if !(GVAR(enabled)) exitWith { false };

// Callback varsa, ExtensionCallback ile eslestirmek uzere FIFO kuyruguna ekle.
// Ayni callName icin extDB3'un yanitlari, gonderilme sirasiyla ayni sirada
// dondugu varsayilir (bkz. fnc_onExtensionCallback.sqf).
if !(_callback isEqualTo {}) then {
    private _queue = GVAR(pending) getOrDefault [_callName, []];
    _queue pushBack [_callback, _callbackArgs, diag_tickTime];
    GVAR(pending) set [_callName, _queue];
};

private _boundParams = _params apply { [_x] call FUNC(sanitizeValue) };
private _function = format [GVAR(dbProtocolTemplate), _callName];

private _result = DB_EXT_NAME callExtension [_function, _boundParams];
_result params [["_output", "", [""]], ["_errorCode", 0, [0]]];

if (_errorCode != 0) then {
    [format ["extDB3 gonderim hatasi (errorCode=%1, output=%2) cagri=%3", _errorCode, _output, _callName]] call FUNC(log);
};

_errorCode == 0
