#include "script_component.hpp"

ADDON = false;

// --- Durum (state) ---------------------------------------------------------
// GVAR(dbHost): Bu makine extDB3'e dogrudan baglanmasi beklenen makine mi?
// (Dedicated server VEYA Headless Client. Normal oyuncu istemcisi ASLA degil.)
GVAR(dbHost) = isServer || {!hasInterface};

// callName (STRING) -> [[_callback, _callbackArgs, _queuedAt], ...] (FIFO kuyruk)
// extDB3'ten gelen ExtensionCallback yaniti, ayni callName icin gonderilme
// sirasina gore eslestirilir (bkz. fnc_onExtensionCallback.sqf).
GVAR(pending) = createHashMap;

// --- CBA Settings ------------------------------------------------------------
// Sadece DB host makinelerde anlamli; ama tum makinelerde ayni tanimlanmali
// (CBA settings global registry gerektirir).
[QGVAR(enabled), "CHECKBOX",
    ["VBS COIN: Veritabani Baglantisi", "Kapatilirsa tum vbs_fnc_query / vbs_fnc_execute cagrilari sessizce no-op olur (fail-safe kill-switch)."],
    "VBS COIN - extDB3", true, 1] call CBA_fnc_addSetting;

[QGVAR(dbProtocolTemplate), "EDITBOX",
    ["VBS COIN: extDB3 Protokol Sablonu", "Kurulu extDB3 surumunuzun SQL_CUSTOM_V2 cagri formatina gore duzenleyin. %1 yerine cagri adi (ör. VBS_MEMORY_INSERT) yazilir."],
    "VBS COIN - extDB3", "9:SQL_CUSTOM_V2:ASYNC:%1", 1] call CBA_fnc_addSetting;

[QGVAR(asyncTimeout), "SLIDER",
    ["VBS COIN: Asenkron Zaman Asimi (sn)", "Bu sureden uzun yanit alinamayan istekler kuyruktan dusurulur (bellek sizintisini onler)."],
    "VBS COIN - extDB3", [5, 60, 15, 0], 1] call CBA_fnc_addSetting;

[QGVAR(debugLog), "CHECKBOX",
    ["VBS COIN: Hata Ayiklama Loglari", "RPT dosyasina extDB3 katmani icin ayrintili log yazar."],
    "VBS COIN - extDB3", false, 1] call CBA_fnc_addSetting;

ADDON = true;
