// vbsm_main\config.cpp
class CfgPatches {
    class vbsm_main {
        name = "VBSM: Operational Environment Simulation";
        author = "Chief Architect & AI Team";
        url = "";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.10;
        requiredAddons[] = {"cba_main", "cba_settings"};
    };
};

class CfgFunctions {
    class VBSM { // Kod Tag'imiz
        class vbsm_core {
            file = "\vbsm_main\vbsm_core";
            class cbaSettings { preInit = 1; };
            // CBA ayarlarını oyun başlamadan yükler (fn_cbaSettings.sqf ile eşleşir)
        };
        class vbsm_layer1_physical {
            file = "\vbsm_main\vbsm_layer1_physical";
            class initPhysicalLayer { postInit = 1; };
            // Oyun başladığında otomatik tetiklenir
            class civPoolAdd {};
            class handleRoutines {};
        };
    };
};
