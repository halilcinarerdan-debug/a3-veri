class CfgFunctions {
    class vbs {
        // Kategori adi (Core) sadece dosya organizasyonu icindir; Arma 3
        // fonksiyon adlarini her zaman "<tag>_fnc_<isim>" olarak uretir.
        // Yani asagidaki tanimlar -> vbs_fnc_query, vbs_fnc_execute, ...
        class Core {
            file = QUOTE(PATHTOF(functions));

            // Sicak yol: mission start'ta onceden derlenir (ilk cagrida
            // derleme takilmasi olmasin diye).
            class query { preInit = 1; };
            class execute { preInit = 1; };
            class dispatch { preInit = 1; private = 1; };
            class onExtensionCallback { preInit = 1; private = 1; };

            // Soguk yol: tembel derleme yeterli.
            class sanitizeValue { private = 1; };
            class gcPending { private = 1; };
            class log { private = 1; };
        };
    };
};
