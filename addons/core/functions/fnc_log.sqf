#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * VBS_COIN_DEBUGLOG ayari acikken RPT'ye satir yazar. Uretimde kapali
 * kalmasi beklenir; bu yuzden her cagrida once ucuz bir bool kontrolu yapilir.
 *
 * Arguments:
 * 0: Mesaj <STRING>
 *
 * Return Value:
 * None
 *
 * Public: no
 */

params [["_message", "", [""]]];

if !(GVAR(debugLog)) exitWith {};

diag_log text format ["[VBS_COIN][extDB3] %1", _message];
