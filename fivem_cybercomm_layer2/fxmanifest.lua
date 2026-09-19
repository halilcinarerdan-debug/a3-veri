-- Bu resource icin baseline bir manifest. Gercek projenizde zaten bir
-- fxmanifest.lua varsa, buradaki client_script/server_script/ui_page/files
-- girdilerini kendi manifestinize birlestirin.

fx_version 'cerulean'
game 'gta5'

name 'fivem_cybercomm_layer2'
description 'Standalone siber suc simulasyonu -- Katman 2 (Telegram NUI + MariaDB) + Katman 4 (Kriminalistik / Illegal GPS)'
version '1.7.0'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

client_script 'client.lua'
server_script 'server.lua'

dependency 'oxmysql'
