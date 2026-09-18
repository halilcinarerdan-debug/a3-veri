--[[
    KATMAN 2 | SERVER
    ShadowLine :: Siber Suc Haberlesme Motoru + EXIF/Metadata Adli Analiz Ureticisi

    Güvenlik felsefesi (kritik):
    Istemci (NUI/client.lua) HICBIR ZAMAN guvenilir kaynak degildir. Hileli bir
    istemci NUI callback'lerini veya TriggerServerEvent argumanlarini elle
    tetikleyebilir. Bu yuzden:
      - Cuzdan bakiyesi, ajan biyometrisi, EXIF/GPS verisi SADECE bu dosyada
        uretilir/degistirilir; client asla bu degerleri sunucuya YAZAMAZ.
      - Client'tan gelen HER event; tip kontrolu, uzunluk siniri ve rate-limit
        (IsRequestAllowed) suzgecinden gecer.
      - Disaridan (Katman 1 / ajan AI script'i) bu modulu tetiklemek isteyen
        kod SADECE asagidaki exports('...') fonksiyonlarini kullanmalidir.
]]

local Config = {
    -- Katman 1 (MariaDB + Kortizol/Biyometri motoru) buraya export saglayan
    -- kaynagin adini yaz. Kaynak yoksa/baslamadiysa asagidaki DemoAgents'a
    -- otomatik dusulur (standalone calisabilirlik icin).
    Layer1ResourceName = 'layer1_biometrics',

    DefaultChannel = 'kanal-07',
    ChannelDisplayName = 'OPSEC :: Kanal-07',

    RateLimitMs = 1200,
    MaxStoredMessages = 200,

    -- Coklu oyunculu (co-op sorusturma) senaryolarinda true yapip sunucu.cfg'ye
    -- "add_ace identifier.xxxx cybercomm.member allow" eklenebilir. Tek
    -- oyunculu simulasyonda kapalidir; yine de rate-limit ve tip kontrolleri
    -- her zaman aktif kalir.
    RequireAcePermission = false,
    AcePermission = 'cybercomm.member',

    -- Katman 1 baglanana kadar modulun tek basina test edilebilmesi icin.
    -- Gercek entegrasyon tamamlaninca false yapilabilir.
    DemoMode = true,

    -- Kurgusal "gercek dunya formatinda" GPS uretimi icin sabit referans nokta.
    GpsAnchorLat = 34.0522,
    GpsAnchorLon = -118.2437,
}

-- ============================================================
-- YARDIMCI: KATMAN 1 ENTEGRASYON KOPRUSU (Ajan Biyometrisi)
-- ============================================================

local DemoAgents = {
    ['agent_ux91'] = { name = 'Dmitri "Fisilti" Volkov', streetSmarts = 71, composure = 64, cortisol = 22.4, withdrawalCrisis = false },
    ['agent_kl04'] = { name = 'Selin "Cam" Aydemir',     streetSmarts = 48, composure = 19, cortisol = 58.7, withdrawalCrisis = true  },
}

--- Katman 1'den (varsa) ajan biyometri verisini okur, yoksa demo/fallback dondurur.
--- Beklenen sekil: { name, streetSmarts, composure, cortisol, withdrawalCrisis }
local function GetAgentBiometrics(agentId)
    if GetResourceState(Config.Layer1ResourceName) == 'started' then
        local ok, data = pcall(function()
            return exports[Config.Layer1ResourceName]:GetAgentBiometrics(agentId)
        end)
        if ok and type(data) == 'table' then
            return data
        end
    end

    return DemoAgents[agentId] or {
        name = 'Bilinmeyen Ajan',
        streetSmarts = 50,
        composure = 50,
        cortisol = 20,
        withdrawalCrisis = false,
    }
end

local function GetAgentDisplayName(agentId)
    return GetAgentBiometrics(agentId).name
end

--- Ajan "soguk kanliligini" kaybetmis mi? (Kortizol 50+ μg/dL, yoksunluk
--- krizi veya composure cok dusukse mesajlar/EXIF bozulur.)
local function IsDestabilized(bio)
    return (bio.cortisol or 0) >= 50
        or bio.withdrawalCrisis == true
        or (bio.composure or 100) <= 25
end

-- ============================================================
-- MESAJ BOZULMA MOTORU (Kortizol -> Panik Metni)
-- ============================================================

local PANIC_INTERJECTIONS = {
    'bekle bi saniye', 'kalbim kut kut atiyo', 'biri beni izliyo galiba',
    'ellerim titriyo yaziyom', 'sicayik', 'burdan gitmem lazim', 'ses geldi',
}

--- intensity: 0..1 arasi bozulma siddeti. Deterministik degildir (server-side
--- math.random), boylece client bir sonraki metni tahmin/manipule edemez.
local function CorruptText(text, intensity)
    intensity = math.max(0, math.min(1, intensity))
    local chars = {}
    for i = 1, #text do
        chars[i] = text:sub(i, i)
    end

    for i = 1, #chars do
        if chars[i]:match('%a') and math.random() < (0.06 * intensity) then
            chars[i] = chars[i] .. chars[i] -- titreme/tekrar simulasyonu
        end
    end

    local corrupted = table.concat(chars)

    if math.random() < intensity then
        corrupted = corrupted .. ' ' .. PANIC_INTERJECTIONS[math.random(#PANIC_INTERJECTIONS)]
    end

    if math.random() < (intensity * 0.5) then
        corrupted = corrupted:upper()
    end

    return corrupted
end

-- ============================================================
-- EXIF / ADLI METADATA URETICISI
-- ============================================================

local BURNER_DEVICE_POOL = {
    'Nokia XR-71 (Yakilabilir Hat)',
    'Alcatel OneTouch S3 Bariyer',
    'ZTE Blade Karanlik-9',
    'Samsung Galaxy J1 Kayitsiz',
    'Huawei Y3 Anonim-Klon',
}

local function LuhnCheckDigit(numStr)
    local sum = 0
    local len = #numStr
    for i = 1, len do
        local d = tonumber(numStr:sub(len - i + 1, len - i + 1))
        if i % 2 == 1 then
            d = d * 2
            if d > 9 then d = d - 9 end
        end
        sum = sum + d
    end
    return (10 - (sum % 10)) % 10
end

--- Gercek bir cihaza ait olmayan, ancak Luhn algoritmasiyla gecerli formatta
--- 15 haneli kurgusal bir IMEI-benzeri kimlik uretir (adli-gorunum icin).
local function GenerateFakeImei()
    local body = {}
    for i = 1, 14 do
        body[i] = tostring(math.random(0, 9))
    end
    local bodyStr = table.concat(body)
    return bodyStr .. tostring(LuhnCheckDigit(bodyStr))
end

--- Oyun-ici (x, y) koordinatini "gercek dunya formatinda" ondalik enlem/boylama
--- cevirir. Gercek bir GPS/harita servisi degildir; sadece adli-analiz
--- panelinde okunabilir/tasinabilir bir formata donusum saglar.
local function WorldToGeo(coords)
    local metersPerDegreeLat = 111320.0
    local metersPerDegreeLon = metersPerDegreeLat * math.cos(math.rad(Config.GpsAnchorLat))

    local lat = Config.GpsAnchorLat + (coords.y / metersPerDegreeLat)
    local lon = Config.GpsAnchorLon + (coords.x / metersPerDegreeLon)
    return lat, lon
end

--- Zula fotografinin EXIF/metadata blogunu uretir. Ajan destabilize ise
--- GPS'te surukleme, saat senkron hatasi ve dusuk konum dogrulugu enjekte
--- edilir ("adli sapma") - oyuncu koordinatlara korukorune guvenemez.
local function BuildExifPayload(coords, bio)
    local destabilized = IsDestabilized(bio)
    local lat, lon = WorldToGeo(coords)
    local accuracyMeters = destabilized and math.random(80, 400) or math.random(3, 15)

    if destabilized then
        lat = lat + (math.random(-250, 250) / 100000)
        lon = lon + (math.random(-250, 250) / 100000)
    end

    local capturedAt = os.time()
    if destabilized and math.random() < 0.4 then
        capturedAt = capturedAt - math.random(600, 5400)
    end

    return {
        lat = tonumber(string.format('%.6f', lat)),
        lon = tonumber(string.format('%.6f', lon)),
        accuracyMeters = accuracyMeters,
        device = BURNER_DEVICE_POOL[math.random(#BURNER_DEVICE_POOL)],
        imei = GenerateFakeImei(),
        capturedAt = capturedAt,
        integrity = destabilized and 'suspect' or 'ok',
    }
end

-- ============================================================
-- KANAL / MESAJ DEPOSU (Sunucu Otoritesi)
-- ============================================================

local Channels = {}
local messageCounter = 0

local function GetChannel(channelId)
    if not Channels[channelId] then
        Channels[channelId] = { messages = {} }
    end
    return Channels[channelId]
end

local function GenerateMessageId(prefix)
    messageCounter = messageCounter + 1
    return ('%s_%d_%d'):format(prefix or 'msg', os.time(), messageCounter)
end

local function StoreMessage(channelId, msg)
    local channel = GetChannel(channelId)
    table.insert(channel.messages, msg)
    if #channel.messages > Config.MaxStoredMessages then
        table.remove(channel.messages, 1)
    end
end

local function GetChannelMessages(channelId)
    return GetChannel(channelId).messages
end

local function MarkMessageRead(channelId, messageId)
    for _, msg in ipairs(GetChannel(channelId).messages) do
        if msg.id == messageId then
            msg.read = true
            return true
        end
    end
    return false
end

-- ============================================================
-- GUVENLIK DUVARI (Rate-limit + Yetki Kontrolu)
-- ============================================================

local lastRequestAt = {}

local function IsAuthorizedMember(src)
    if type(src) ~= 'number' or GetPlayerName(src) == nil then
        return false
    end
    if Config.RequireAcePermission then
        return IsPlayerAceAllowed(src, Config.AcePermission)
    end
    return true
end

--- Her client->server istegi bu suzgecten gecmeli: bagli oyuncu mu, yetkili
--- mi, ve rate-limit asilmis mi. Basarisizsa istek sessizce reddedilir.
local function IsRequestAllowed(src)
    if not IsAuthorizedMember(src) then
        return false
    end

    local now = GetGameTimer()
    if now - (lastRequestAt[src] or 0) < Config.RateLimitMs then
        return false
    end

    lastRequestAt[src] = now
    return true
end

AddEventHandler('playerDropped', function()
    lastRequestAt[source] = nil
end)

-- ============================================================
-- CUZDAN (MONERO/XMR) - SUNUCU OTORITELI BAKIYE
-- ============================================================

local Wallets = {}

local function GetIdentifier(src)
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        if id:find('license:') then
            return id
        end
    end
    return 'source:' .. tostring(src)
end

local function GetWalletBalance(identifier)
    return Wallets[identifier] or 0.0
end

--- Cuzdan bakiyesini SADECE sunucu tarafi kod (Katman 1, gorev/satis
--- fonksiyonlari) degistirebilir. NUI/istemci bu fonksiyona asla dogrudan
--- erisemez.
local function AdjustWallet(identifier, delta, memo)
    local newBalance = math.max(0.0, (Wallets[identifier] or 0.0) + (tonumber(delta) or 0.0))
    Wallets[identifier] = newBalance

    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if GetIdentifier(pid) == identifier then
            TriggerClientEvent('cybercomm:walletUpdate', pid, { balance = newBalance, memo = memo })
        end
    end

    return newBalance
end

-- ============================================================
-- YAYIN (BROADCAST)
-- ============================================================

local function BroadcastToChannel(eventName, payload)
    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if IsAuthorizedMember(pid) then
            TriggerClientEvent(eventName, pid, payload)
        end
    end
end

-- ============================================================
-- IC FONKSIYONLAR (export'lar tarafindan sarilir)
-- ============================================================

local function SendAgentMessageInternal(agentId, text, channelId)
    if type(agentId) ~= 'string' or type(text) ~= 'string' or #text == 0 then
        return nil
    end

    channelId = channelId or Config.DefaultChannel
    local bio = GetAgentBiometrics(agentId)
    local destabilized = IsDestabilized(bio)

    local finalText = text
    if destabilized then
        local intensity = math.min(1, (((bio.cortisol or 0) - 40) / 40) + 0.3)
        finalText = CorruptText(text, intensity)
    end

    local msg = {
        id = GenerateMessageId('msg'),
        type = 'text',
        channelId = channelId,
        senderId = agentId,
        senderName = GetAgentDisplayName(agentId),
        text = finalText,
        degraded = destabilized,
        timestamp = os.time(),
        read = false,
    }

    StoreMessage(channelId, msg)
    BroadcastToChannel('cybercomm:newMessage', msg)
    return msg.id
end

local function CreateDeadDropInternal(agentId, coords, channelId, caption)
    if type(agentId) ~= 'string' or type(coords) ~= 'vector3' then
        return nil
    end

    channelId = channelId or Config.DefaultChannel
    local bio = GetAgentBiometrics(agentId)
    local exif = BuildExifPayload(coords, bio)

    local msg = {
        id = GenerateMessageId('drop'),
        type = 'photo',
        channelId = channelId,
        senderId = agentId,
        senderName = GetAgentDisplayName(agentId),
        caption = type(caption) == 'string' and caption or 'Zula birakildi. Sessizce teslim alin.',
        exif = exif,
        timestamp = os.time(),
        read = false,
    }

    StoreMessage(channelId, msg)
    BroadcastToChannel('cybercomm:newDeadDrop', msg)
    return msg.id
end

-- ============================================================
-- CLIENT -> SERVER OLAYLARI (guvenlik duvarindan gecer)
-- ============================================================

RegisterServerEvent('cybercomm:requestSync')
AddEventHandler('cybercomm:requestSync', function()
    local src = source
    if not IsRequestAllowed(src) then return end

    local identifier = GetIdentifier(src)
    local channelId = Config.DefaultChannel

    TriggerClientEvent('cybercomm:syncState', src, {
        channelId = channelId,
        channelName = Config.ChannelDisplayName,
        messages = GetChannelMessages(channelId),
        wallet = { balance = GetWalletBalance(identifier) },
    })
end)

RegisterServerEvent('cybercomm:markRead')
AddEventHandler('cybercomm:markRead', function(messageId)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(messageId) ~= 'string' or #messageId == 0 or #messageId > 128 then return end

    MarkMessageRead(Config.DefaultChannel, messageId)
end)

-- ============================================================
-- DISA ACIK API (Katman 1 / ajan AI script'leri buradan tetikler)
-- ============================================================

exports('SendAgentMessage', SendAgentMessageInternal)
exports('CreateDeadDrop', CreateDeadDropInternal)
exports('AdjustWallet', AdjustWallet)
exports('GetWalletBalance', GetWalletBalance)

-- ============================================================
-- DEMO MODU (Katman 1 baglanana kadar modulu tek basina test etmek icin)
-- ============================================================

CreateThread(function()
    if not Config.DemoMode then return end

    Wait(4000)
    SendAgentMessageInternal('agent_ux91', 'Konum guvenli, mal hazir. Onay bekliyorum.', Config.DefaultChannel)

    Wait(3000)
    CreateDeadDropInternal(
        'agent_kl04',
        vector3(215.4, -810.2, 30.7),
        Config.DefaultChannel,
        'Zula konumu ekte. Cabuk davranin, bolgede hareketlilik var.'
    )
end)
