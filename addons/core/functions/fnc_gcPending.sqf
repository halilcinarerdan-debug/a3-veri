#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * extDB3'ten hicbir zaman yanit gelmeyen (baglanti koptu, DB coktu, vb.)
 * kuyruk kayitlarini periyodik olarak temizler. CBA_fnc_addPerFrameHandler
 * ile birkac saniyede bir calisir - her frame degil.
 *
 * Arguments:
 * 0: CBA_fnc_addPerFrameHandler tarafindan iletilen args dizisi (kullanilmiyor) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Public: no
 */

private _now = diag_tickTime;
private _timeout = GVAR(asyncTimeout);

// toArray -> [[key, value], ...] bagimsiz bir kopya dondurur; kayit uzerinde
// gezerken ayni anda GVAR(pending)'i guncellemek guvenlidir.
{
    _x params ["_callName", "_queue"];
    private _kept = _queue select { (_now - (_x select 2)) < _timeout };

    if (count _kept != count _queue) then {
        [format ["%1 icin %2 zaman asimina ugramis async istek dusuruldu", _callName, (count _queue) - (count _kept)]] call FUNC(log);
    };

    GVAR(pending) set [_callName, _kept];
} forEach (GVAR(pending) toArray);
