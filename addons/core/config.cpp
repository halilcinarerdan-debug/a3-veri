#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT_BEAUTIFIED);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"CBA_main", "CBA_settings", "coin_main"};
        author = "Bas Mimar ve Sef";
        VERSION_CONFIG;
    };
};

#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"
