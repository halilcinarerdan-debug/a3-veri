/*
 * VBS_fnc_scanCivilianBuildings
 *
 * Haritadaki tum "House" tipi binalari grid tabanli, parcalar halinde
 * (her kare arasinda sleep) tarar ve classname'e gore "Ev" / "Is Yeri"
 * olarak ikiye ayirir. Sunucu FPS'ini tek seferde dusurmemek icin
 * tum sonuc tek bir nearestObjects cagrisiyla degil, kucuk grid
 * parcalari halinde toplanir.
 *
 * Sadece bina nesnelerini toplar - HICBIR AI/nesne spawn ETMEZ.
 *
 * Params: -
 * Returns: [ARRAY _homes, ARRAY _works]
 */

private _tileSize  = vbs_layer1_tileSize;
private _tileSleep = vbs_layer1_tileSleep;
private _mapSize   = worldSize;

private _seen  = createHashMap;
private _homes = [];
private _works = [];

private _gx = 0;
while {_gx < _mapSize} do {
    private _gy = 0;
    while {_gy < _mapSize} do {
        private _center = [_gx + _tileSize * 0.5, _gy + _tileSize * 0.5, 0];
        private _radius = _tileSize * 0.75;

        {
            private _building = _x;
            private _key = netId _building;

            if (isNil {_seen get _key} && {count (_building buildingPos -1) > 0}) then {
                _seen set [_key, true];

                if (([_building] call VBS_fnc_classifyBuilding) == "WORK") then {
                    _works pushBack _building;
                } else {
                    _homes pushBack _building;
                };
            };
        } forEach (nearestObjects [_center, ["House"], _radius]);

        sleep _tileSleep;
        _gy = _gy + _tileSize;
    };
    _gx = _gx + _tileSize;
};

diag_log format ["[VBS][Layer1] Grid taramasi tamamlandi: %1 ev, %2 is yeri bulundu.", count _homes, count _works];

[_homes, _works]
