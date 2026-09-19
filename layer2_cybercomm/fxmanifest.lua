fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'layer2_cybercomm'
author 'A3-Veri :: Suc ve Istihbarat Simulasyonu'
description 'Katman 2 - Siber Suc Haberlesme Arayuzu (NUI), EXIF/Metadata Analiz Motoru, SIGINT Takip ve Adli Sahtekarlik Tespiti'
version '1.2.0'

-- ============================================================
-- NUI KONFIGURASYONU
-- ============================================================
-- ui_page MUTLAKA resource kok dizininden baslamali.
-- ONEMLI: Bu yol ile asagidaki 'files' icindeki yol BIREBIR ayni olmali.
ui_page 'html/index.html'

-- NUI'nin ihtiyac duydugu HER dosya burada listelenmek ZORUNDA.
-- Buyuk-kucuk harf duyarlidir (Linux). Uzanti ile birlikte tam yaz.
files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

-- ============================================================
-- SCRIPT KATMANLARI
-- ============================================================
client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}
