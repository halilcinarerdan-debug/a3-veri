/*
 * VBS_fnc_generateCivilian
 *
 * Verilen Ev/Is Yeri bina ciftinden sanal (fiziksel karsiligi olmayan) bir
 * sivil kaydi uretir ve VBS_fnc_insertCivilianAsync ile extDB3'e yazar.
 * HICBIR AI/nesne spawn ETMEZ.
 *
 * Params: [_homeBuilding OBJECT, _workBuilding OBJECT]
 */

params ["_homeBuilding", "_workBuilding"];

private _homePositions = _homeBuilding buildingPos -1;
private _workPositions = _workBuilding buildingPos -1;

private _homePos = if (count _homePositions > 0) then { selectRandom _homePositions } else { getPosATL _homeBuilding };
private _workPos = if (count _workPositions > 0) then { selectRandom _workPositions } else { getPosATL _workBuilding };

if (isNil "VBS_civCounter") then { VBS_civCounter = 0; };
VBS_civCounter = VBS_civCounter + 1;

private _nationalId = format ["%1%2", 100000 + (VBS_civCounter % 899999), 1000 + floor random 8999];

private _firstNames = [
    "Ahmet", "Mehmet", "Mustafa", "Ali", "Hasan", "Huseyin", "Ibrahim", "Yusuf", "Omer", "Emre",
    "Fatma", "Ayse", "Elif", "Zeynep", "Meryem", "Hatice", "Emine", "Sultan", "Sevgi", "Derya"
];
private _lastNames = [
    "Yilmaz", "Kaya", "Demir", "Celik", "Sahin", "Yildiz", "Aydin", "Ozturk", "Arslan", "Dogan",
    "Kilic", "Aslan", "Cetin", "Koc", "Kurt"
];
private _name = format ["%1 %2", selectRandom _firstNames, selectRandom _lastNames];

// RHS + vanilla sivil kiyafet havuzu. RHS classname'leri kurulu RHS surumune
// gore degisebilir - onceki yuklemeden sonra editor config browser ile
// dogrulayip guncelleyin.
private _civilianUniforms = [
    "C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F",
    "C_man_shorts_1_F", "C_man_shorts_1_black_F", "C_man_shorts_1_grey_F",
    "C_man_w_worker_F", "C_man_p_beggar_F", "C_man_p_fugitive_F",
    "C_man_sport_1_F", "C_man_sport_2_F", "C_man_sport_3_F",
    "rhsgref_uniform_civ1", "rhsgref_uniform_civ2"
];
private _inventory = str [selectRandom _civilianUniforms];

private _aceMedicalStatus = str [];

[
    _nationalId, _name, 0,
    _homePos, _workPos, _homePos,
    0, _aceMedicalStatus, _inventory, 1
] call VBS_fnc_insertCivilianAsync;
