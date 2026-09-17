/*
    AFTTP_Civilian_Intel
    --------------------
    Kontrgerilla (COIN) Sivil Istihbarat & Sempati Addon'u.
    Mikero's PBO Project ile z\afttp\addons\civilian_intel altindan
    "AFTTP_Civilian_Intel.pbo" olarak paketlenmek uzere hazirlanmistir.
*/

class CfgPatches
{
    class AFTTP_Civilian_Intel
    {
        units[] = {"AFTTP_ModuleRiotTrigger"};
        weapons[] = {};
        requiredVersion = 2.14;

        // Zorunlu bagimliliklar (kullanici tarafindan katiyetle istenen 4 mod)
        // + ACE3 Etkilesim Menusu aksiyonlarinin (createAction/addActionToClass)
        //   gercekten var oldugu iki alt bilesen (ace_interaction, ace_interact_menu)
        //   teknik olarak zorunlu oldugu icin listeye eklenmistir.
        requiredAddons[] =
        {
            "A3_Modules_F",
            "cba_main",
            "ace_common",
            "lambs_danger",
            "ace_interaction",
            "ace_interact_menu"
        };

        author = "AFTTP";
        authors[] = {"AFTTP"};
        version = "1.0.0";
    };
};

// ---------------------------------------------------------------------------
// Zeus Modul Kategorisi (CfgFactionClasses)
// ---------------------------------------------------------------------------
class CfgFactionClasses
{
    class AFTTP_Milsim_Modules
    {
        displayName = "AFTTP - Kontrgerilla (COIN) Modulleri";
        priority = 6;
        side = 7; // sideLogic - modullerin gorunecegi bagimsiz Zeus kategorisi
    };
};

// ---------------------------------------------------------------------------
// Fonksiyon Kutuphanesi
// ---------------------------------------------------------------------------
class CfgFunctions
{
    class AFTTP
    {
        tag = "AFTTP";
        class CivilianIntel
        {
            class initIntelModule
            {
                file = "z\afttp\addons\civilian_intel\fn_initIntelModule.sqf";
                postInit = 1;
            };
            class heartsAndMinds
            {
                file = "z\afttp\addons\civilian_intel\fn_heartsAndMinds.sqf";
                postInit = 1;
            };
        };
    };
};

// ---------------------------------------------------------------------------
// MP Guvenligi: remoteExec beyaz listesi (server-authoritative mimari)
// ---------------------------------------------------------------------------
class CfgRemoteExec
{
    class Functions
    {
        mode = 1; // whitelist
        jip = 0;

        class AFTTP_fnc_serverGatherIntel { allowedTargets = 2; };   // client -> server
        class AFTTP_fnc_clientIntelFeedback { allowedTargets = 0; }; // server -> tekil client
        class AFTTP_fnc_syncSympathy { allowedTargets = 0; };        // server -> herkes
        class AFTTP_fnc_drawIntelMarker { allowedTargets = 0; };     // server -> herkes
        class AFTTP_fnc_deleteIntelMarker { allowedTargets = 0; };   // server -> herkes
        class AFTTP_fnc_startRiotLocal { allowedTargets = 0; };      // server -> herkes (local filtreli)
        class AFTTP_fnc_stopRiotLocal { allowedTargets = 0; };       // server -> herkes (local filtreli)
        class AFTTP_fnc_heartsAndMinds { allowedTargets = 2; };      // herhangi bir client -> server
    };
};

// ---------------------------------------------------------------------------
// Zeus Modulu: AFTTP_ModuleRiotTrigger
// ---------------------------------------------------------------------------
class CfgVehicles
{
    class Module_F;

    class AFTTP_ModuleRiotTrigger : Module_F
    {
        scope = 2;
        scopeCurator = 2;
        displayName = "AFTTP - Sivil Ayaklanma Tetikleyici";
        icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\intel_ca.paa";
        category = "Modules";
        faction = "AFTTP_Milsim_Modules";
        side = 7;
        isGlobal = 0;
        isTriggerActivated = 0;
        curatorCanAttach = 1;
        function = "AFTTP_fnc_initIntelModule";
        functionPriority = 1;

        class EventHandlers
        {
            class ADDON
            {
                // Modul haritaya yerlestirilip aktive edildiginde, ana fonksiyonu
                // logic nesnesiyle birlikte cagirir (isServer kontrolu fn_initIntelModule.sqf icinde yapilir).
                init = "[(_this select 0)] call AFTTP_fnc_initIntelModule;";
            };
        };

        class Arguments {};

        class ModuleDescription : ModuleDescription_F
        {
            description = "Zeus tarafindan haritaya yerlestirildiginde, en yakin yerlesim biriminde derhal bir sivil ayaklanma (riot) baslatir. O bolgedeki sempatiyi kritik seviyeye ceker ve LAMBS Danger FSM devretmesiyle sivilleri isyan davranisina sokar.";
        };
    };
};
