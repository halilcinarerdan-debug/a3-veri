/*
 * VBS_fnc_initPopulation
 *
 * KATMAN 1 (Fiziksel Varlik) giris noktasi. Sadece sunucuda calisir ve
 * HICBIR AI/nesne SPAWN ETMEZ - sadece veritabani (vbs_civilians) doldurulur.
 *
 * Akis:
 *   1) extDB3 baglanti kontrolu (senkron, tek seferlik handshake)
 *   2) Harita binalarinin grid tabanli, parcali taranmasi (Ev / Is Yeri)
 *   3) Her Ev icin sanal sivil(ler) uretilip extDB3'e asenkron yazilmasi
 *
 * Params: -
 */

if (!isServer) exitWith {};
if (!isNil "VBS_layer1_populated") exitWith {};

VBS_layer1_populated = false;

[] spawn {
    private _version = "extDB3" callExtension "9:VERSION";
    if (_version == "") exitWith {
        diag_log "[VBS][Layer1] extDB3 uzantisina ulasilamadi - nufus taramasi iptal edildi.";
    };

    diag_log format ["[VBS][Layer1] extDB3 baglantisi dogrulandi (%1). Bina taramasi basliyor...", _version];

    private _scanResult = call VBS_fnc_scanCivilianBuildings;
    _scanResult params ["_homes", "_works"];

    if (count _homes == 0) exitWith {
        diag_log "[VBS][Layer1] Haritada uygun 'Ev' binasi bulunamadi - nufus uretimi atlandi.";
    };

    private _workTypes = [];
    { _workTypes pushBackUnique (typeOf _x); } forEach _works;

    private _perHomeRange = vbs_layer1_civiliansPerHome;
    private _searchRadius = vbs_layer1_workSearchRadius;
    private _insertSleep  = vbs_layer1_insertBatchSleep;
    private _totalGenerated = 0;

    {
        private _home = _x;
        private _homePos = getPosATL _home;

        private _nearWorks = if (count _workTypes > 0) then {
            nearestObjects [_homePos, _workTypes, _searchRadius]
        } else { [] };

        private _work = switch (true) do {
            case (count _nearWorks > 0): { _nearWorks select 0 };
            case (count _works > 0): { selectRandom _works };
            default { _home };
        };

        private _civCount = (_perHomeRange select 0) + floor random ((_perHomeRange select 1) - (_perHomeRange select 0) + 1);

        for "_i" from 1 to _civCount do {
            [_home, _work] call VBS_fnc_generateCivilian;
            _totalGenerated = _totalGenerated + 1;
            sleep _insertSleep;
        };
    } forEach _homes;

    VBS_layer1_populated = true;
    diag_log format ["[VBS][Layer1] Nufus taramasi tamamlandi. Toplam %1 sivil kaydi extDB3 kuyruguna yazildi.", _totalGenerated];
};
