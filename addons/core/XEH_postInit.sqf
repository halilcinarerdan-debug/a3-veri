#include "script_component.hpp"

// Sadece server/HC uzerinde calisir; normal oyuncu istemcisinde extDB3 zaten
// yuklu olmayacagi icin bu katmanin tamami no-op kalir.
if !(GVAR(dbHost)) exitWith {};

// extDB3'un (ve genel olarak her extension'in) asenkron sonuclarini motora
// geri bildirdigi tek native mekanizma: "ExtensionCallback" mission event
// handler'i. Ana thread hicbir zaman callExtension sonucunu beklemek icin
// bloklanmiyor; sonuc ne zaman hazirsa buraya dusuyor.
addMissionEventHandler ["ExtensionCallback", { _this call FUNC(onExtensionCallback) }];

// Yanit alinamayan (extDB3 baglantisi koptu, DB cokme, vb.) kuyruk kayitlarini
// periyodik olarak temizle. Her frame degil, birkaç saniyede bir - performans.
[
    FUNC(gcPending),
    (GVAR(asyncTimeout) max 5) / 2,
    []
] call CBA_fnc_addPerFrameHandler;

[format ["VBS COIN extDB3 core baslatildi. dbHost=%1", GVAR(dbHost)]] call FUNC(log);
