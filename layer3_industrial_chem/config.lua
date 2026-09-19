Config = {}

-- ============================================================
-- KATMAN 1 / KATMAN 2 KOPRU (BRIDGE) AYARLARI
-- Bu kaynaklar sert bagimlilik degildir (fxmanifest 'dependencies'
-- listesinde YOKTUR). Sunucuda bulunmazlarsa modul, asagidaki notr
-- varsayilan degerlerle tamamen bagimsiz (standalone) calismaya devam eder.
-- ============================================================
Config.Bridge = {
    Layer1Resource = 'fivem_sigint_layer1',
    Layer2Resource = 'layer2_cybercomm',

    -- exports["fivem_sigint_layer1"]:GetAgentBiometrics(citizenId) bulunamazsa
    -- kullanilacak klinik-notr biyometri tablosu.
    FallbackBiometrics = {
        cortisol = 12.0,   -- ug/dL, dinlenme araligi ortasi
        withdrawal = 0.0,  -- 0.0 - 1.0 (yoksunluk siddeti)
    },
}

-- ============================================================
-- REAKTOR TANIMLARI
-- ============================================================
Config.Reactors = {
    ['reactor_industrial_01'] = {
        label = 'Endustriyel Reaktor Unitesi #1',
        coords = vec3(1200.0, -3100.0, -38.0),
        interiorId = 'lab_interior_01',      -- CBRN oda/hacim kimligi
        ventVolumeM3 = 220.0,                -- odanin toplam havalandirilan hacmi (m3)
        vesselRatedPsi = 185.0,               -- kabin patlama (rupture) basinci
        ambientTempC = 21.0,
    },
}

-- ============================================================
-- REAKSIYON TARIFLERI
-- ONEMLI: Bu tablo gercek bir yasadisi madde uretim prosedurunu
-- TEMSIL ETMEZ. Reaktif etiketleri kurgusal RP esyalaridir; molar
-- kutle, ideal oran ve termodinamik katsayilar sadece oyun ici
-- ekonomi/fizik dengelemesi amaciyla secilmis KURGUSAL sabitlerdir.
-- ============================================================
Config.Recipes = {
    ['synth_alpha'] = {
        label = 'Sentez Protokolu ALFA',
        productItem = 'chem_product_alpha',
        outputGasType = 'TOXIC_ANALOG_A', -- kacak/patlama aninda salinan kurgusal toksik gaz sinifi

        reagents = {
            { item = 'reagent_precursor_x', label = 'Prekursor Bilesik-X', molarMass = 90.0, idealMolarRatio = 2 },
            { item = 'reagent_amine_y',     label = 'Amin Bilesik-Y',      molarMass = 30.0, idealMolarRatio = 1, phWeight = -0.4 },
            { item = 'reagent_catalyst_z',  label = 'Metalik Katalizor-Z', molarMass = 27.0, idealMolarRatio = 3 },
            { item = 'reagent_acid_w',      label = 'Endustriyel Asit-W',  molarMass = 36.0, idealMolarRatio = 4, phWeight = 1.0 },
        },

        exothermicCoefficient = 220.0,   -- mol basina W esdegeri isi katsayisi (illustrative)
        baseYieldMgPerMol = 150.0,

        -- Reaksiyon hizi Van't Hoff / Q10 kurali ile modellenir: hiz,
        -- referans sicakliktan (referenceTempC) her q10IntervalC santigrat
        -- derece uzaklastikca q10Coefficient kati kadar degisir. Bu, gercek
        -- kimyasal kinetikte yaygin kullanilan bir yaklasik Arrhenius
        -- formudur ve oyun ici ayarlanabilirligi kolaylastirir.
        baseRateConstant = 1.0,
        referenceTempC = 20.0,
        q10Coefficient = 2.3,
        q10IntervalC = 10.0,
    },
}

-- ============================================================
-- TERMAL / BASINC FIZIGI
-- ============================================================
Config.Thermal = {
    physicsTickMs = 1000,
    criticalTempC = 110.0,        -- kullanici tanimli kritik esik
    runawayTempC = 145.0,         -- geri donusu olmayan termal kacis esigi
    thermalMassJPerC = 4200.0,    -- reaktor + icerik isi kapasitesi (J/°C)
    kelvinOffset = 273.15,

    -- Sogutma, sabit bir "guc" degil, sicaklik farkiyla orantili bir isi
    -- transfer katsayisidir (gercek bir esanjor gibi): W = iletkenlik *
    -- (tempC - ambientTempC). Bu, valf %100 acikken bile reaktorun ortam
    -- sicakliginin ALTINA (fiziksel olarak imkansiz bir sekilde) sonsuza
    -- kadar sogumasini engeller.
    passiveConductanceWPerC = 6.5,    -- valf kapaliyken pasif kap kaybi
    coolantConductanceWPerC = 200.0,  -- valf %100 acikken ek sogutma iletkenligi
}

-- ============================================================
-- EKIPMAN ASINMASI (deterministik, sans/zar tabanli DEGIL)
-- ============================================================
Config.Equipment = {
    wearPerCycle = 0.015,             -- basarili/basarisiz her tam sentezde asinma artisi
    wearPerRunawaySecond = 0.02,      -- termal kacis surerken saniye basi ek asinma
    maintenanceXmrCost = 45.0,
    maintenanceWearRecovery = 0.35,
    sealPermeabilityConst = 0.0006,   -- asinma * basinc farki -> sizinti akisi katsayisi
}

-- ============================================================
-- CBRN / PPM SIMULASYONU
-- ============================================================
Config.CBRN = {
    tickMs = 1000,
    irritantPpm = 10.0,
    dangerousPpm = 50.0,                 -- tibbi mudahale/asfiksi baslangic esigi
    lethalExposureSeconds = 120.0,
    naturalInfiltrationM3PerMin = 2.5,   -- havalandirma kapaliyken dogal hava degisimi
    activeVentilationM3PerMin = 140.0,   -- havalandirma aciliginda hava degisim orani
    explosionGasSpike = 42000.0,         -- patlama aninda odaya salinan ani gaz yuku (ppm*m3)
    contaminationRadius = 18.0,
    contaminationDecayPerHour = 0.6,     -- kontaminasyonun saatlik dogal azalisi (bilgilendirme amacli)
}
