fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'A3-Veri :: Suc ve Istihbarat Simulasyonu'
description 'Katman 2 - Siber Suc Haberlesme Arayuzu (NUI) ve EXIF/Metadata Adli Analiz Motoru'
version '1.0.0'

-- Standalone: hicbir framework (QBCore/ESX/vRP) bagimliligi yoktur.
-- Katman 1 (MariaDB / Kortizol-Biyometri motoru) ile export uzerinden,
-- gevsek baglanti (loose coupling) kurar. Bkz. server.lua > Config.Layer1ResourceName

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
