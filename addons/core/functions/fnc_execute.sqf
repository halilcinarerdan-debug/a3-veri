#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * extDB3 uzerinden ASENKRON bir INSERT/UPDATE/DELETE (yazma) calistirir.
 * Varsayilan kullanim tamamen "fire-and-forget"tir (callback verilmezse
 * kuyruk/eslestirme maliyeti bile olusturulmaz - en performansli yol).
 * Sadece kritik yazimlarin (ör. AAR analytics) basarisini dogrulamak
 * isterseniz opsiyonel bir callback verin.
 *
 * Arguments:
 * 0: extDB3 sql_custom_v2 ini'sindeki cagri adi <STRING> (ör. "VBS_MEMORY_INSERT")
 * 1: Prepared statement '?' yerlerine sirali baglanacak degerler <ARRAY>
 * 2: (Opsiyonel) Yazma onaylanunca/hata olunca calisacak kod <CODE>
 * 3: (Opsiyonel) _callback'e oldugu gibi iletilecek ek veri <ARRAY>
 *
 * Return Value:
 * Istek extDB3'e basariyla iletildi mi <BOOL>
 *
 * Example:
 * ["VBS_ANALYTICS_INSERT", ["RIOT_FORMED", getPosATL _marker select 0, ...]] call vbs_fnc_execute;
 *
 * Public: yes
 */

params [
    ["_callName", "", [""]],
    ["_params", [], [[]]],
    ["_callback", {}, [{}]],
    ["_callbackArgs", [], [[]]]
];

[_callName, _params, _callback, _callbackArgs] call FUNC(dispatch);
