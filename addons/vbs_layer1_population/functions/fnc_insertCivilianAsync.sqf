/*
 * VBS_fnc_insertCivilianAsync
 *
 * Bir sivil kaydini extDB3 SQL_CUSTOM_V2 "VBS_INSERT_CIVILIAN" prosedurune
 * callExtensionAsync ile yazar (motor-seviyesinde gercek asenkron cagri,
 * scheduler'i bloklamaz). Sorgu extdb3-conf.ini'de parametreli (prepared
 * statement) tanimlandigi icin SQL injection riski yoktur.
 *
 * Params: [
 *     _nationalId STRING, _name STRING, _clanId NUMBER,
 *     _homePos ARRAY, _workPos ARRAY, _currentPos ARRAY,
 *     _vehicleId NUMBER, _aceStatus STRING, _inventory STRING, _status NUMBER
 * ]
 */

params [
    "_nationalId", "_name", ["_clanId", 0],
    "_homePos", "_workPos", "_currentPos",
    ["_vehicleId", 0], ["_aceStatus", "[]"], ["_inventory", "[]"], ["_status", 1]
];

private _protocolId = vbs_layer1_extdb3ProtocolId;

private _payload = [
    _nationalId, _name, str _clanId,
    str _homePos, str _workPos, str _currentPos,
    str _vehicleId, _aceStatus, _inventory, str _status
] joinString "^";

"extDB3" callExtensionAsync format ["%1:VBS_INSERT_CIVILIAN:%2", _protocolId, _payload];
