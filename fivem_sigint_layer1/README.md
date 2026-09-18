# Katman 1 — SIGINT, Kriminalistik ve Nörokimyasal İstihbaret Omurgası

Standalone FiveM sunucu modülü. Hiçbir gameplay framework'üne (ESX,
QBCore, vRP) bağımlılık yoktur; yalnızca DB sürücüsü olarak
[`oxmysql`](https://github.com/overextended/oxmysql) kullanılır.

Bu, daha büyük bir "Yeraltı Operasyon, Kriminalistik ve İstihbarat
Simülasyonu" projesinin 1. katmanıdır: ham veri üretimi, sunucu içi RAM
önbellekleme ve periyodik/kritik SQL kalıcılığı. Oyuncuya dönük
UI/etkileşim (telefon arayüzü, sorgu minigame'i, polis paneli vb.) bilinçli
olarak bu katmanın dışında bırakılmıştır; üst katmanlar aşağıdaki export
API'sini tüketir.

## Kurulum

1. `sql/sigint_layer1_schema.sql` dosyasını veritabanınıza uygulayın.
2. `fivem_sigint_layer1` klasörünü sunucu resource dizinine kopyalayın.
3. `server.cfg` içine `ensure oxmysql` sonrasına `ensure sigint_layer1`
   ekleyin.

## Mimari

| Dosya | Sorumluluk |
|---|---|
| `config.lua` | Tüm ayarlanabilir sabitler (zamanlayıcılar, RF fiziği, kule koordinatları, eşikler) |
| `cache.lua` | Ajan başına RAM state; tüm hesap SQL'e dokunmadan burada yapılır |
| `validation.lua` | Kimlik çözümleme, hız/mesafe mantıksallık denetimi, rate-limit, IMEI Luhn doğrulaması |
| `sigint_matrix.lua` | Baz istasyonu üçgenleme motoru + arama çemberi daralması |
| `forensic_index.lua` | Nem/sıcaklığa bağlı parmak izi / DNA bütünlük bozunumu |
| `neurochemical.lua` | Kortizol, dopamin baskılanması, kimyasal doygunluk ve yoksunluk |
| `economic_profile.lua` | Borç yükü → risk iştahı (lojistik fonksiyon) |
| `interrogation.lua` | PEACE/Reid protokolüne karşı bilişsel yük ve itiraf olasılığı |
| `persistence.lua` | Toplu (multi-row) `INSERT ... ON DUPLICATE KEY UPDATE` yazım katmanı |
| `main.lua` | 3 bağımsız thread'in orkestrasyonu + dışa açık export API |

### Performans ilkesi

Sunucu yalnızca **3 bağımsız thread** çalıştırır (SIGINT, biyometrik/sorgu,
persistence). Her thread kendi tick aralığında tüm ajanlar üzerinde tek bir
geçiş yapar; ara tick'lerde sunucu bu modül adına hiçbir iş yapmaz. SQL
yazımı yalnızca 10 dakikada bir toplu (bulk) sorgu ile veya kritik adli
olaylarda (yakalanma/ölüm/ihanet) tek ajan için anlık olarak gerçekleşir.

### Sunucu tarafı doğrulama

- Konum, RSSI, SNR ve üçgenleme güveni **yalnızca sunucunun kendi**
  `GetEntityCoords` ölçümünden hesaplanır; istemci yalnızca "yayın
  yapıyorum" bayrağını tetikler, hiçbir sayısal değer taşımaz.
  Bu sayede bir injector, sahte konum/sinyal verisi enjekte edemez.
- `RegisterForensicContact`, `ApplyStressSpike`, `ApplyDoseEvent`,
  `ApplyDebtChange` gibi hassas fonksiyonlar **ağ olayı değil, sunucu içi
  export'tur** — yalnızca güvenilir sunucu kaynaklı diğer resource'lar
  çağırabilir, istemciden doğrudan tetiklenemez.
- Tüm sayısal girdiler `Validation.ClampNumber` ile fiziksel/mantıksal
  sınırlara zorlanır; iki ölçüm arası fizik-dışı hız sıçramaları
  (`Validation.PlausibleMovement`) reddedilir.
- IMEI kayıtları standart Luhn algoritmasıyla doğrulanır.

## Formül özetleri

- **RSSI**: log-distance path loss modeli — `RSSI(d) = TxPower − (RefLoss + 10·n·log10(d/d0))`
- **Üçgenleme güveni**: duyulan kule sayısına göre taban güven × ortalama
  SNR kalitesi; her tick üstel yumuşatma (`ACCUMULATION_RATE`) ile hedefe
  yaklaşır, yayın kesilince `DECAY_RATE` ile söner.
- **Arama çemberi**: `radius = MinR + (MaxR − MinR) · (1 − confidence)`
- **Ağırlıklı merkez tahmini**: RSSI-ağırlıklı centroid (`w = 10^(RSSI/10)`)
- **Kortizol**: bazale üstel yaklaşım (`decayToward`), stres olaylarında
  anlık sıçrama; 50 ug/dL üstü `sigint_layer1:neurochemicalCrisis` event'i
  tetikler.
- **Kimyasal doygunluk**: standart farmakokinetik yarılanma ömrü —
  `S(t) = S0 · 0.5^(t / half_life)`
- **Risk iştahı**: borç endeksinin lojistik dönüşümü —
  `risk = 1 / (1 + e^(−(debt − midpoint)/scale))`
- **İtiraf olasılığı**: bilişsel yükün lojistik dönüşümü —
  `p = 1 / (1 + e^(−(load − midpoint)/k))`

## Export API (Katman 2+ için)

```lua
exports.sigint_layer1:RegisterDevice(identifier, imei, imsi)
exports.sigint_layer1:RegisterForensicContact(identifier, fingerprintId, dnaProfile, itemId, humidityPct, tempC)
exports.sigint_layer1:ApplyStressSpike(identifier, amount, reason)
exports.sigint_layer1:ApplyDoseEvent(identifier, compoundId, doseUnits)
exports.sigint_layer1:ApplyDebtChange(identifier, delta, reason)
exports.sigint_layer1:StartInterrogation(identifier, method, counselPresent) -- method: 'PEACE' | 'REID'
exports.sigint_layer1:StopInterrogation(identifier)
exports.sigint_layer1:TriggerCriticalEvent(identifier, reason) -- 'arrest' | 'death' | 'betrayal'
exports.sigint_layer1:GetAgentSnapshot(identifier)
```

İstemci tarafında (bir "sanal telefon" script'i tarafından) yalnızca tek bir
olay tetiklenir:

```lua
TriggerServerEvent('sigint_layer1:packetTransmit')
```

## Not

Tüm sentetik bileşik kodları (`SYN-ALPHA`, `SYN-BETA`, `SYN-GAMMA`) ve
kimyasal parametreler kurgusaldır; gerçek bir madde veya dozaja karşılık
gelmez. Bu modül GTA5/FiveM üzerinde çalışan kurgusal bir rol yapma
simülasyonu içindir.
