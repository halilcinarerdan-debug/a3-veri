/*
 * KATMAN 1 - Fiziksel Varlik: postInit
 * CBA ayarlarini kaydeder, extDB3 async callback dinleyicisini takar
 * ve sadece sunucuda harita nufus taramasini baslatir.
 */

// CBA_fnc_addSetting dizi (ARRAY) tipini desteklemedigi icin bu iki tablo
// duz global degisken olarak tanimlanir; sayisal/aralikli ayarlar asagida
// CBA Settings menusune ("VBS Layer 1" kategorisi) eklenir.
vbs_layer1_workKeywords = [
    "shop", "market", "ind_", "cargo", "hangar", "garage", "depot",
    "warehouse", "office", "fuelstation", "atc", "harbour", "port"
];
vbs_layer1_civiliansPerHome = [1, 3];

["vbs_layer1_workSearchRadius", "SLIDER",
    ["Bir evden en yakin is yerini ararken kullanilacak yaricap (metre)"],
    "VBS Layer 1",
    [50, 2000, 400, 0],
    1
] call CBA_fnc_addSetting;

["vbs_layer1_tileSize", "SLIDER",
    ["Harita taramasinda kullanilacak grid kare boyutu (metre) - dusuk deger = daha az anlik yuk, daha uzun sure"],
    "VBS Layer 1",
    [100, 1000, 300, 0],
    1
] call CBA_fnc_addSetting;

["vbs_layer1_tileSleep", "SLIDER",
    ["Her grid karesi taramasi arasindaki bekleme suresi (saniye) - sunucu FPS'ini korumak icin"],
    "VBS Layer 1",
    [0, 1, 0.05, 2],
    1
] call CBA_fnc_addSetting;

["vbs_layer1_insertBatchSleep", "SLIDER",
    ["Her sivil INSERT cagrisi arasindaki bekleme suresi (saniye) - extDB3 kuyrugunu bogmamak icin"],
    "VBS Layer 1",
    [0, 0.5, 0.02, 3],
    1
] call CBA_fnc_addSetting;

["vbs_layer1_extdb3ProtocolId", "SLIDER",
    ["extdb3-conf.ini icinde VBS_INSERT_CIVILIAN prosedurunu gosteren protokol numarasi"],
    "VBS Layer 1",
    [1, 20, 1, 0],
    1
] call CBA_fnc_addSetting;

if (!isServer) exitWith {};

addMissionEventHandler ["ExtensionCallback", VBS_fnc_extensionCallback];

[] call VBS_fnc_initPopulation;
