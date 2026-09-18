#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * extDB3 uzerinden ASENKRON bir SELECT (okuma) sorgusu calistirir. Sonuc
 * asla senkron donmez; hazir oldugunda "_callback" cagrilir. Ana/sunucu
 * thread'i I/O icin ASLA bloklanmaz - bu yuzden donus degeri sadece
 * "istek extDB3'e iletildi mi" bilgisini tasir, DB sonucunu DEGIL.
 *
 * Sicak yol (crowd/riot kumelenmesi, komutan cache tick'i vb.) icin: tek
 * tek birim/sivil basina degil, birkaç saniyede bir calisan toplu bir
 * "master tick" sorgusu ile cagirin ve sonucu yerel bir HashMap'te
 * cache'leyin (bkz. proje notlari).
 *
 * Arguments:
 * 0: extDB3 sql_custom_v2 ini'sindeki cagri adi <STRING> (ör. "VBS_MEMORY_LOOKUP")
 * 1: Prepared statement '?' yerlerine sirali baglanacak degerler <ARRAY>
 * 2: Sonuc gelince calisacak kod: params ["_rows", "_args"] <CODE>
 *      _rows: parseSimpleArray ile guvenli sekilde parse edilmis satir dizisi
 * 3: (Opsiyonel) _callback'e oldugu gibi iletilecek ek veri <ARRAY>
 *
 * Return Value:
 * Istek extDB3'e basariyla iletildi mi <BOOL>
 *
 * Example:
 * ["VBS_MEMORY_LOOKUP", [_civilianId, _actorUID], {
 *     params ["_rows", "_args"];
 *     _args params ["_civilian"];
 *     if (count _rows > 0) then { ... daha once tanimis ... };
 * }, [_civilian]] call vbs_fnc_query;
 *
 * Public: yes
 */

params [
    ["_callName", "", [""]],
    ["_params", [], [[]]],
    ["_callback", {}, [{}]],
    ["_callbackArgs", [], [[]]]
];

if (_callback isEqualTo {}) then {
    ["vbs_fnc_query: callback olmadan cagrildi - okuma sonucunu almanin tek yolu callback'tir. Yazma islemi icin vbs_fnc_execute kullanin"] call FUNC(log);
};

[_callName, _params, _callback, _callbackArgs] call FUNC(dispatch);
