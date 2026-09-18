/*
 * VBS_fnc_extensionCallback
 *
 * "ExtensionCallback" Mission Event Handler - extDB3'ten donen asenkron
 * sonuclari yakalar. Fire-and-forget mimari oldugu icin sadece hata
 * loglamasi yapar; basarili yazimlar sessizce gecilir (log spam onlenir).
 *
 * Params: [_name STRING, _function STRING, _data STRING]
 */

params ["_name", "_function", "_data"];

if (_name != "extDB3") exitWith {};

// extDB3 basari/hata on-eki surume gore degisebilir ("[1,...]" = basarili
// varsayimi buradadir) - kurulu extDB3 wiki'nize gore dogrulayin.
if ((_data select [0, 2]) != "[1") then {
    diag_log format ["[VBS][Layer1] extDB3 HATA -> fonksiyon: %1 | veri: %2", _function, _data];
};
