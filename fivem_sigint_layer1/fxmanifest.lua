fx_version 'cerulean'
game 'gtav'
lua54 'yes'

name 'sigint_layer1'
author 'Katman 1 - SIGINT / Kriminalistik / Biyometrik İstihbaret'
description 'Standalone SIGINT, kriminalistik kontaminasyon, nörokimyasal ve sorgu simülasyon omurgası'
version '1.0.0'

-- Yalnızca veri tabanı sürücüsü bağımlılığı vardır; hiçbir
-- gameplay framework'üne (ESX/QBCore/vRP) bağımlılık yoktur.
dependencies {
    'oxmysql',
}

server_scripts {
    'server/config.lua',
    'server/cache.lua',
    'server/validation.lua',
    'server/sigint_matrix.lua',
    'server/forensic_index.lua',
    'server/neurochemical.lua',
    'server/economic_profile.lua',
    'server/interrogation.lua',
    'server/persistence.lua',
    'server/main.lua',
}
