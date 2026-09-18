#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * Motorun native "ExtensionCallback" mission event handler'ina baglanir.
 * HERHANGI bir extension asenkron veri gonderdiginde tetiklenir; bu yuzden
 * ilk is her zaman gonderenin extDB3 olup olmadigini dogrulamaktir.
 *
 * extDB3, gonderilen "_function" (protokol) string'ini oldugu gibi geri
 * yankilar; cagri adini (callName) protokol sablonundaki son ':' segmenti
 * olarak geri cikariyoruz - bu, kullanilan extDB3 surumunun tam protokol
 * on-ekinden (numeric slot, "ASYNC" anahtar kelimesi vb.) bagimsiz calisir.
 *
 * Arguments:
 * 0: Extension adi <STRING>
 * 1: Gonderilen protokol/fonksiyon string'i (oldugu gibi yankilanir) <STRING>
 * 2: extDB3'un dondurdugu, Arma dizi-literal formatinda sonuc <STRING>
 *
 * Return Value:
 * None
 *
 * Public: no
 */

params ["_name", "_function", "_data"];

if (_name != DB_EXT_NAME) exitWith {};

private _segments = _function splitString ":";
private _callName = _segments select (count _segments - 1);

private _queue = GVAR(pending) getOrDefault [_callName, []];

if (_queue isEqualTo []) exitWith {
    [format ["Eslesmeyen extDB3 async yaniti (bekleyen kayit yok): %1", _callName]] call FUNC(log);
};

private _entry = _queue deleteAt 0;
GVAR(pending) set [_callName, _queue];

_entry params ["_callback", "_callbackArgs"];

// Guvenlik: "call compile" YERINE parseSimpleArray kullanilir - extDB3
// ciktisi calistirilabilir kod olarak DEGIL, sadece bir dizi literali
// olarak yorumlanir (rastgele kod calistirma riski yoktur).
private _rows = [];
try {
    _rows = parseSimpleArray _data;
} catch {
    [format ["extDB3 yaniti parse edilemedi (callName=%1): %2", _callName, _data]] call FUNC(log);
};

[_rows, _callbackArgs] call _callback;
