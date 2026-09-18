// config.cpp icinde: #include "CfgFunctions.hpp"
//
// "file" yolu, addon'un $PBOPREFIX$ ile tanimlanan sanal mount noktasina
// gore verilir (bu addon icin $PBOPREFIX$ = "vbs\database" olmalidir),
// fiziksel repo klasoru (addons\database\...) degil. Her fonksiyon icin
// "file" acikca "fnc_" ile verildi; aksi halde motor varsayilan olarak
// "fn_<SinifAdi>.sqf" arar ve dosyalarimizi bulamaz.
class CfgFunctions
{
    class vbs
    {
        class database
        {
            class query
            {
                file = "vbs\database\functions\fnc_query.sqf";
            };
            class execute
            {
                file = "vbs\database\functions\fnc_execute.sqf";
            };
        };
    };
};
