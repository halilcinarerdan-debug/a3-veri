# fivem_cybercomm_layer2 :: Katman 4

Standalone (framework'suz) FiveM siber suc simulasyonu — Katman 2 (Telegram
tarzi NUI + MariaDB/oxmysql) uzerine insa edilmis **Katman 4: Kriminalistik,
Gizli Parmak Izleri ve Illegal GPS Navigasyon Terminali** eklentisi.

## Kurulum

1. `sql/katman4_migration.sql` dosyasini HeidiSQL (veya kullandiginiz DB
   yonetim araci) ile bir kez calistirin.
2. Kaynagi sunucuya ekleyin ve `ensure fivem_cybercomm_layer2` ile baslatin
   (veya kendi mevcut Katman 2 resource'unuzdaki dosyalari bu surumlerle
   degistirin).
3. Sunucu konsolunda `[layer2][KATMAN4] ... OK.` satirlarini goruyorsaniz
   sema saglikli demektir. `bulunamadi` uyarisi gorurseniz migration'i
   calistirip resource'u yeniden baslatin.

## Katman 4 neler ekliyor

### 1) Illegal GPS Navigasyon Terminali
NUI'ye gomulu bir koordinat terminali. Oyuncu ajanin mesajindan/EXIF
panelinden okudugu Enlem/Boylam degerlerini ELLE girer, "ROTA HESAPLA"
butonu `client.lua` uzerinden yerel `SetNewWaypoint(x, y)` native'ini
tetikler. Hicbir blip/marker olusturulmaz; sadece GTA V'in kendi
radar/minimap rota cizgisi devreye girer. Tamamen istemci-yerel, sunucuya
istek gitmez.

### 2) Gizli Parmak Izleri (Latent Prints)
`cybercomm:claimDeadDrop` tetiklendiginde, paketi fiziken kaldiran oyuncunun
`latent_print_weight` katsayisi hesaplanir:

- **Iklim bileseni**: sanal sicaklik/nem (mevcut Katman 2 mantigi).
- **Stres bileseni (YENI)**: oyuncunun kortizol seviyesi ve yoksunluk
  durumu (Katman 1 bridge — el teri / epitel doku transferi simulasyonu).

Sonuc, `sigint_cellular_matrix.latent_print_weight` sutununa **asenkron**
(`oxmysql:execute`, fire-and-forget) olarak yazilir; ana akis bloklanmaz.

### 3) AFIS Soguk Vaka Kaydi
Agirlik `Config.ForensicUndergroundThreshold` (%60) esigini gectiginde,
`sigint_afis_cold_cases` tablosuna "faili mechul" bir vaka kaydi dusurulur
(parmak izi ID'si, supheli identifier, zula mesaj ID'si, konum, iklim,
agirlik). Bu, Katman 3 (polis/narkotik) tarafinin **ileride** geriye donuk
AFIS eslestirmesi yapabilecegi kalici kriminal altyapidir. Bu resource
kendi polis arayuzunu icermez; sadece iki export ile kopru sunar:

- `exports.fivem_cybercomm_layer2:GetPendingAfisCases(limit)`
- `exports.fivem_cybercomm_layer2:MarkAfisCaseMatched(caseId)`

## Degismeyenler

Mevcut anti-exploit bariyerleri (rate limit, dead-drop mesafe kontrolu,
wallet delta capi), Packet Leak / Lockdown motoru ve Katman 1 kopru
export'lari **degistirilmedi**. Tum yeni DB yazimlari `CreateThread` +
`SafeExecute` uzerinden asenkron yurur.
