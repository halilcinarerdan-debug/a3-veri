fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'layer3_industrial_chem'
author 'a3-veri'
description 'Katman 3: Endustriyel Kimya Laboratuvari ve CBRN Simulasyon Motoru (Standalone)'
version '1.0.0'

shared_scripts {
    'config.lua'
}

-- Yukleme sirasi onemlidir: chemistry_core ve cbrn_simulation birbirlerinin
-- modul tablolarina (ChemistryCore / CBRNSimulation) global olarak referans
-- verir; main.lua ikisini de orkestra eden en son dosyadir.
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/chemistry_core.lua',
    'server/cbrn_simulation.lua',
    'server/main.lua'
}

client_scripts {
    'client/reactor_client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

-- Katman 1 (fivem_sigint_layer1) ve Katman 2 (layer2_cybercomm) BILEREK
-- fxmanifest bagimliligi olarak eklenmemistir: bu modul standalone calisir,
-- koprulenen her cagri calisma anida GetResourceState ile denetlenir.
dependencies {
    'oxmysql'
}
