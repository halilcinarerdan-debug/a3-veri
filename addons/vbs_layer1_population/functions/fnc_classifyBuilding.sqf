/*
 * VBS_fnc_classifyBuilding
 *
 * Bina nesnesinin classname'ini CBA ayarindaki (vbs_layer1_workKeywords)
 * anahtar kelimelerle karsilastirir.
 *
 * Params: [_building OBJECT]
 * Returns: STRING ("HOME" | "WORK")
 */

params ["_building"];

private _className = toLowerANSI (typeOf _building);
private _keywords  = vbs_layer1_workKeywords;

private _isWork = (_keywords findIf {_className find (toLowerANSI _x) != -1}) != -1;

if (_isWork) exitWith {"WORK"};
"HOME"
