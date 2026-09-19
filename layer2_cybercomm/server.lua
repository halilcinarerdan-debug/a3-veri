--[[
    KATMAN 2 | SERVER :: Kaynak-of-Truth
    - Tum dogrulama, EXIF uretimi ve cuzdan islemleri BURADA.
    - Client'tan gelen hicbir koordinat/bakiye/mesaj ID'sine korukorune guvenilmez.

    Bu surumde 3 doktrinel ek modul bulunur (mevcut akislari BOZMAZ):
      1) SIGINT MOBILE TRACKER   -> Packet_Leak_Ratio, sinyal avcisi, lockdown
      2) FORENSIC DECAY          -> latent_print_weight + fingerprint_id
      3) POLICE HONEYPOT + CRYPTO-CHALLENGE -> ele gecirilmis hat + parola dogrulama

    Fiziksel katman: sunucu SADECE NE ZAMAN/NEREDE spawn/despawn olacagina
    karar verir (yasam dongusu otoritesi). Aracin/pedin gercekten olusturulmasi,
    surus AI'i ve silah/combat mantigi TAMAMEN client.lua'da (istemci tarafinda)
    calisir. Bu ayrim, agir dunya-etkilesim natiflerinin (CreateVehicle,
    CreatePed, TaskCombatPed vb.) sunucuyu degil, ilgili oyuncunun kendi
    istemcisini mesgul etmesini saglar (0.00 MS resmon hedefi).
]]

local Config = {
    Layer1ResourceName  = 'fivem_sigint_layer1',
    DefaultChannel      = 'ops-07',
    ChannelDisplayName  = 'OPSEC :: Kanal-07',
    DemoMode            = true,

    MaxMessageIdLength  = 128,
    MaxTextLength       = 1024,

    RateLimitWindow     = 1.0,
    RateLimitMaxHits    = 8,

    DeadDropClaimRadius = 3.0,
    WalletMaxDelta      = 500.0,   -- tek islemde kabul edilen max |delta| XMR
    ChannelHistoryCap   = 300,     -- kanal basi max mesaj (bellek)

    -- SIGINT MOBILE TRACKER
    HeartbeatTimeoutSeconds  = 8.0,   -- bu sure heartbeat gelmezse arayuz "kapali" sayilir
    LeakHeartbeatGain        = 2,     -- arayuz acik basina her heartbeat'te
    LeakMessageGain          = 10,    -- her metin mesaji yayininda (izleyen basina)
    LeakDeadDropGain         = 18,    -- her zula fotografi yayininda (izleyen basina)
    LeakDecayPerSecond       = 0.35,  -- zamanla dogal sizinti azalmasi
    LeakHunterThreshold      = 75,    -- bu esikte sinyal avcisi minibus baslar
    LeakLockdownThreshold    = 95,    -- bu esikte NUI gecici lockdown'a girer
    LeakPostLockdownResidual = 35,    -- lockdown sonrasi kalinti risk seviyesi
    LockdownDurationSeconds  = 45,
    HunterSpawnMinDistance   = 80.0,  -- oyuncunun ~80-100m yakininda dogar
    HunterSpawnMaxDistance   = 100.0,

    -- FORENSIC DECAY
    ForensicUndergroundThreshold = 60, -- adli sicil skoru bu degerin ustundeyse MariaDB eslesme bayragi
}

-- ============================================================
-- BELLEK-ICI STATE (Katman 1 entegre ise oradan cekilebilir)
-- ============================================================
local Channels          = {}   -- [channelId] = { messages = {} }
local Wallets           = {}   -- [identifier] = balance
local RateLimits        = {}   -- [src] = { hits, windowStart }
local DeadDrops         = {}   -- [messageId] = { coords, claimedBy, agentId }
local MessageIndex      = {}   -- [messageId] = { channelId, msg }

local UiHeartbeat       = {}   -- [src] = os.clock() (SIGINT)
local PacketLeak        = {}   -- [src] = { ratio, lastAt } (SIGINT)
local ActiveHunters     = {}   -- [src] = true (SIGINT)
local LockdownState     = {}   -- [src] = true (SIGINT)
local VerifiedChallenges = {}  -- [identifier..'|'..agentId] = true (CRYPTO-CHALLENGE)

-- [src] = { [category] = { netId, netId, ... } } - en son spawn edilen fiziksel
-- varliklarin (minibus/ped) network ID'leri. Oyuncu aniden ayrilirsa (crash,
-- alt+f4) bu ID'ler uzerinden BASKA bir client'a "sil" komutu yayinlanarak
-- sahipsiz kalan varliklarin bellek/dunya sizintisina donusmesi engellenir.
local SpawnedEntities = {}

-- ============================================================
-- YARDIMCILAR
-- ============================================================
local function GetIdentifier(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1, 8) == 'license:' then return id end
    end
    return 'src:' .. tostring(src)
end

local function GetAgentDisplayName(agentId)
    return 'Ajan ' .. tostring(agentId):sub(-4)
end

local function GenerateMessageId(prefix)
    return string.format('%s_%d_%d', prefix or 'msg', os.time(), math.random(1000, 9999))
end

local function IsRequestAllowed(src)
    if not src or src <= 0 then return false end
    local now = os.clock()
    local b = RateLimits[src]
    if not b or (now - b.windowStart) > Config.RateLimitWindow then
        RateLimits[src] = { hits = 1, windowStart = now }
        return true
    end
    b.hits = b.hits + 1
    return b.hits <= Config.RateLimitMaxHits
end

-- ============================================================
-- KATMAN 1 KOPRUSU
-- ============================================================
local function GetAgentBiometrics(agentId)
    local fallback = {
        cortisol = 0, in_withdrawal = false,
        imei = 'N/A', device = 'Unknown Device',
    }
    if GetResourceState(Config.Layer1ResourceName) ~= 'started' then
        return fallback
    end
    local ok, data = pcall(function()
        return exports[Config.Layer1ResourceName]:GetAgentBiometrics(agentId)
    end)
    if not ok or type(data) ~= 'table' then return fallback end
    return {
        cortisol      = tonumber(data.cortisol) or 0,
        in_withdrawal = data.in_withdrawal == true,
        imei          = tostring(data.imei   or fallback.imei),
        device        = tostring(data.device or fallback.device),
    }
end

--- POLICE HONEYPOT icin: ajanin sorgu direnci cokmus mu (is_compromised)?
local function GetAgentComplianceState(agentId)
    local fallback = { is_compromised = false }
    if GetResourceState(Config.Layer1ResourceName) ~= 'started' then return fallback end
    local ok, data = pcall(function()
        return exports[Config.Layer1ResourceName]:GetAgentComplianceState(agentId)
    end)
    if not ok or type(data) ~= 'table' then return fallback end
    return { is_compromised = data.is_compromised == true }
end

--- FORENSIC DECAY icin: ajanin adli sicil agirligi (0-100).
local function GetAgentCriminalRecord(agentId)
    local fallback = { recordScore = 0 }
    if GetResourceState(Config.Layer1ResourceName) ~= 'started' then return fallback end
    local ok, data = pcall(function()
        return exports[Config.Layer1ResourceName]:GetAgentCriminalRecord(agentId)
    end)
    if not ok or type(data) ~= 'table' then return fallback end
    return { recordScore = tonumber(data.recordScore) or 0 }
end

-- CRYPTO-CHALLENGE icin varsayilan zaaf/trait havuzu (Katman 1 yoksa test amacli).
local DemoAgentTraits = {
    ['agent_ux91'] = {
        keywords     = { 'kumar', 'bahis', 'iddaa' },
        correctReply = 'Yine mi kumar lafi? Borcu kapatinca konusuruz, simdi ise odaklan.',
    },
    ['agent_kl04'] = {
        keywords     = { 'esrar', 'ot', 'yesil' },
        correctReply = 'O konuyu simdi acma, kafam yeterince dagilik zaten.',
    },
}

--- CRYPTO-CHALLENGE icin: ajanin gercekten bilecegi gizli zaaf/tetikleyici kelime.
--- Bu bilgi SADECE gercek ajanda (Katman 1) bulunur; ele gecirmis polis bunu BILEMEZ.
local function GetAgentSecretTrait(agentId)
    local fallback = DemoAgentTraits[agentId] or { keywords = {}, correctReply = 'Ne diyosun, anlamadim.' }
    if GetResourceState(Config.Layer1ResourceName) ~= 'started' then return fallback end
    local ok, data = pcall(function()
        return exports[Config.Layer1ResourceName]:GetAgentSecretTrait(agentId)
    end)
    if not ok or type(data) ~= 'table' or type(data.keywords) ~= 'table' then return fallback end
    return {
        keywords     = data.keywords,
        correctReply = tostring(data.correctReply or fallback.correctReply),
    }
end

-- ============================================================
-- EXIF URETIMI (stres bozulmasi dahil)
-- ============================================================
local function BuildExifPayload(coords, bio)
    local stressed = (bio.cortisol or 0) >= 50 or bio.in_withdrawal

    -- Normal jitter ~30 cm; stresli ajanlarda ~8 metre sapma (adli supheli)
    local jitter   = stressed and 0.008 or 0.0003
    local lat      = coords.x + (math.random() - 0.5) * jitter * 2
    local lon      = coords.y + (math.random() - 0.5) * jitter * 2
    local alt      = coords.z + (stressed and (math.random() - 0.5) * 1.5 or 0)
    local accuracy = stressed and math.random(120, 400) or math.random(3, 15)
    local ts       = os.time() + (stressed and math.random(-1800, 1800) or 0)

    -- Hex dump
    local bytes = {}
    for i = 1, 16 do bytes[i] = string.format('%02X', math.random(0, 255)) end
    if stressed then
        -- Panik imzasi: bilincli bozuk magic byte
        bytes[1], bytes[2] = 'FF', 'FE'
    end

    return {
        latitude         = lat,
        longitude        = lon,
        altitude         = alt,
        accuracy         = accuracy,
        device           = bio.device,
        imei             = bio.imei,
        timestamp        = ts,
        rawDump          = table.concat(bytes, ' '),
        integrityWarning = stressed,
    }
end

-- ============================================================
-- FORENSIC DECAY (Parmak Izi Bulasmasi)
-- ============================================================

--- FiveM'de sunucu tarafinda dogrudan/guvenilir bir sicaklik-nem natifi
--- yoktur (hava durumu genelde client-only ve resource'a gore degisir).
--- Bu yuzden sunucunun kendi bagimsiz "sanal iklim" modeli kullanilir:
--- gunun saatine bagli deterministik bir taban egri + hafif rastgelelik.
local function GetVirtualClimate()
    local hour = tonumber(os.date('%H')) or 12
    local baseTemp = 14 + math.sin((hour / 24) * math.pi * 2) * 10 -- ~4C - ~24C araligi
    local temperature = baseTemp + (math.random(-20, 20) / 10)
    local humidity = math.max(10, math.min(100, 55 + math.random(-15, 25)))
    return temperature, humidity
end

--- Gercek bir parmak izi degil; ajan basina SABIT (deterministik) adli-gorunum
--- kimligi. GetHashKey (joaat) hem client hem server'da mevcut ve guvenilirdir.
local function GenerateFingerprintId(agentId)
    -- GetHashKey (joaat) negatif 32-bit degerler dondurebilir; Lua 5.4'te
    -- lua_Integer 64-bit oldugundan %X isaretli sayida 16 haneli cikti
    -- uretir. 0xFFFFFFFF ile maskeleyip her zaman temiz 8 haneli hex almak
    -- icin bit AND uygulanir.
    local hash = GetHashKey('fingerprint:' .. tostring(agentId)) & 0xFFFFFFFF
    return ('LP-%08X'):format(hash)
end

--- "Zulayi Teslim Al" tetiklendiginde cagrilir. Cevresel kosullara gore izin
--- okunabilirligini (latent_print_weight) hesaplar ve gerekiyorsa Katman 1'e
--- (MariaDB underground_dealers) eslesme bayragi tetikler.
local function BuildForensicDecay(agentId)
    local temperature, humidity = GetVirtualClimate()

    -- Ideal iz korunumu ~22C ve ~%60 nem civarinda olur; sapma arttikca
    -- latent_print_weight (izin okunabilirligi) duser.
    local tempDelta     = math.abs(temperature - 22)
    local humidityDelta = math.abs(humidity - 60)
    local latentPrintWeight = math.max(0, math.min(100,
        100 - (tempDelta * 2.2) - (humidityDelta * 0.8) + math.random(-5, 5)
    ))

    local fingerprintId = GenerateFingerprintId(agentId)
    local record = GetAgentCriminalRecord(agentId)
    local matchesUndergroundDealers = record.recordScore >= Config.ForensicUndergroundThreshold

    if matchesUndergroundDealers then
        -- Gercek MariaDB sorgusu Katman 1'in sorumlulugundadir; burada sadece
        -- bayrak tetiklenir ve (varsa) Katman 1'e bildirilir.
        TriggerEvent('sigint:undergroundDealerMatch', agentId, fingerprintId, record.recordScore)
        if GetResourceState(Config.Layer1ResourceName) == 'started' then
            pcall(function()
                exports[Config.Layer1ResourceName]:FlagUndergroundDealerMatch(agentId, fingerprintId)
            end)
        end
    end

    return {
        fingerprintId          = fingerprintId,
        latentPrintWeight      = tonumber(string.format('%.1f', latentPrintWeight)),
        temperature            = tonumber(string.format('%.1f', temperature)),
        humidity               = humidity,
        undergroundDealerMatch = matchesUndergroundDealers,
    }
end

-- ============================================================
-- DEPOLAMA
-- ============================================================
local function GetChannel(channelId)
    if not Channels[channelId] then Channels[channelId] = { messages = {} } end
    return Channels[channelId]
end

local function StoreMessage(channelId, msg)
    local ch = GetChannel(channelId)
    ch.messages[#ch.messages + 1] = msg
    MessageIndex[msg.id] = { channelId = channelId, msg = msg }
    while #ch.messages > Config.ChannelHistoryCap do
        local removed = table.remove(ch.messages, 1)
        if removed then MessageIndex[removed.id] = nil end
    end
end

local function GetChannelMessages(channelId)
    local ch = GetChannel(channelId)
    local out = {}
    for i, m in ipairs(ch.messages) do out[i] = m end
    return out
end

local function MarkMessageRead(channelId, messageId)
    local e = MessageIndex[messageId]
    if e and e.msg then e.msg.read = true end
end

-- ============================================================
-- CUZDAN (yalnizca server-side cagirilabilir)
-- ============================================================
local function GetWalletBalance(identifier)
    return Wallets[identifier] or 0.0
end

local function AdjustWallet(identifier, delta, reason)
    if type(identifier) ~= 'string' then return false, 'invalid_identifier' end
    delta = tonumber(delta)
    if not delta then return false, 'invalid_delta' end
    if math.abs(delta) > Config.WalletMaxDelta then
        print(('[layer2] Wallet delta reddedildi: %s | %s | %.4f'):format(identifier, tostring(reason), delta))
        return false, 'delta_too_large'
    end
    Wallets[identifier] = (Wallets[identifier] or 0.0) + delta
    if Wallets[identifier] < 0 then Wallets[identifier] = 0.0 end
    return true, Wallets[identifier]
end

-- ============================================================
-- BROADCAST
-- ============================================================
local function BroadcastToChannel(eventName, msg)
    TriggerClientEvent(eventName, -1, msg)
end

-- ============================================================
-- SIGINT MOBILE TRACKER (Sinyal Avcisi Minibus)
-- ============================================================

local function IsUiConsideredOpen(src)
    local last = UiHeartbeat[src]
    return last ~= nil and (os.clock() - last) <= Config.HeartbeatTimeoutSeconds
end

local function GetLeakRatio(src)
    local st = PacketLeak[src]
    if not st then return 0 end
    local elapsed = os.clock() - st.lastAt
    local decayed = st.ratio - (elapsed * Config.LeakDecayPerSecond)
    return math.max(0, decayed)
end

local function SetLeakRatio(src, value)
    PacketLeak[src] = { ratio = math.max(0, math.min(100, value)), lastAt = os.clock() }
end

local function BumpLeakRatio(src, delta)
    SetLeakRatio(src, GetLeakRatio(src) + delta)
end

local EvaluateLeakThresholds -- forward declare (StartSigintHunter/TriggerLockdown birbirini referans eder)

--- Bir kategori icin en son kaydedilen fiziksel varlik kaydini temizler ve
--- (varsa) ilgili client'a "sunucu artik bunlari takip etmiyor" bilgisini
--- vermek yerine, sadece bookkeeping'i sifirlar - asil silme komutu ayri
--- olarak (despawn event'i ile) ilgili client'a gonderilir.
local function ForgetSpawnedEntities(src, category)
    if SpawnedEntities[src] then
        SpawnedEntities[src][category] = nil
    end
end

local function DespawnHunter(src)
    TriggerClientEvent('cybercomm:despawnHunterVehicle', src)
    ForgetSpawnedEntities(src, 'hunter')
end

local function StartSigintHunter(src)
    if ActiveHunters[src] then return end
    ActiveHunters[src] = true

    local ped = GetPlayerPed(src)
    if ped == 0 then ActiveHunters[src] = nil return end

    local origin = GetEntityCoords(ped)
    local angle = math.random() * 2 * math.pi
    local spawnDist = math.random(Config.HunterSpawnMinDistance, Config.HunterSpawnMaxDistance)
    local spawnCoords = vector3(
        origin.x + math.cos(angle) * spawnDist,
        origin.y + math.sin(angle) * spawnDist,
        origin.z
    )

    -- Fiziksel spawn karari + surus AI'i client.lua'ya devredilir (bkz. dosya
    -- basi not). Sunucu sadece YASAM DONGUSUNU (ne zaman spawn/despawn) yonetir.
    TriggerClientEvent('cybercomm:spawnHunterVehicle', src, { coords = spawnCoords })
    TriggerClientEvent('cybercomm:sigintProximity', src, { active = true, intensity = 1.0 })

    CreateThread(function()
        while ActiveHunters[src] do
            Wait(3000)

            if LockdownState[src] then
                ActiveHunters[src] = nil
                DespawnHunter(src)
                break
            end

            local currentPed = GetPlayerPed(src)
            if currentPed == 0 or not DoesEntityExist(currentPed) then
                ActiveHunters[src] = nil
                DespawnHunter(src)
                break
            end

            local ratio = GetLeakRatio(src)
            if ratio < Config.LeakHunterThreshold then
                -- Sinyal soguyor, avci vazgeciyor: fiziksel varliklar temizlenir.
                ActiveHunters[src] = nil
                TriggerClientEvent('cybercomm:sigintProximity', src, { active = false })
                DespawnHunter(src)
                break
            end
        end
    end)
end

local function TriggerLockdown(src)
    if LockdownState[src] then return end
    LockdownState[src] = true
    ActiveHunters[src] = nil -- avci gorevini lockdown'a devretti

    TriggerClientEvent('cybercomm:lockdown', src, {
        active  = true,
        seconds = Config.LockdownDurationSeconds,
    })
    TriggerEvent('sigint:lockdownTriggered', src)

    CreateThread(function()
        Wait(Config.LockdownDurationSeconds * 1000)
        LockdownState[src] = nil
        SetLeakRatio(src, Config.LeakPostLockdownResidual)
        TriggerClientEvent('cybercomm:lockdown', src, { active = false })
    end)
end

EvaluateLeakThresholds = function(src)
    local ratio = GetLeakRatio(src)

    if ratio >= Config.LeakLockdownThreshold and not LockdownState[src] then
        TriggerLockdown(src)
    elseif ratio >= Config.LeakHunterThreshold and not ActiveHunters[src] and not LockdownState[src] then
        StartSigintHunter(src)
    end
end

--- Mesaj/zula yayinlandiginda, arayuzu ACIK olan tum oyuncularin sizinti
--- oranini artirir (torbacilar veri yukledikce sizinti buyur).
local function BumpLeakForOpenViewers(delta)
    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if IsUiConsideredOpen(pid) then
            BumpLeakRatio(pid, delta)
            EvaluateLeakThresholds(pid)
        end
    end
end

RegisterServerEvent('cybercomm:heartbeat')
AddEventHandler('cybercomm:heartbeat', function()
    local src = source
    if not src or src <= 0 then return end
    UiHeartbeat[src] = os.clock()
    BumpLeakRatio(src, Config.LeakHeartbeatGain)
    EvaluateLeakThresholds(src)
end)

-- Client, kendi spawn ettigi fiziksel varliklarin network ID'lerini burada
-- kayit ettirir (bkz. client.lua NetworkRegisterEntities). Bu, sadece
-- "oyuncu aniden ayrilirsa kim temizleyecek" sorusuna cevap vermek icindir;
-- normal despawn akisinda (ratio dususu/lockdown) ayni client zaten kendi
-- varliklarini temizler.
RegisterServerEvent('cybercomm:registerSpawnedEntities')
AddEventHandler('cybercomm:registerSpawnedEntities', function(category, netIds)
    local src = source
    if not src or src <= 0 then return end
    if type(category) ~= 'string' or type(netIds) ~= 'table' then return end
    SpawnedEntities[src] = SpawnedEntities[src] or {}
    SpawnedEntities[src][category] = netIds
end)

RegisterServerEvent('cybercomm:unregisterSpawnedEntities')
AddEventHandler('cybercomm:unregisterSpawnedEntities', function(category)
    local src = source
    if not src or src <= 0 then return end
    if type(category) ~= 'string' then return end
    ForgetSpawnedEntities(src, category)
end)

-- CIV-AMBUSH / ShotSpotter: client, pusu catismasinin basladigi ani bildirir.
-- Harita/dispatch gorunumu ayri bir sistemin (Katman 3) sorumlulugundadir;
-- burada sadece dogrulanmis (rate-limitli, tip kontrollu) tetikleyici
-- yayinlanir.
RegisterServerEvent('cybercomm:reportShotSpotter')
AddEventHandler('cybercomm:reportShotSpotter', function(coords)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(coords) ~= 'vector3' then return end
    TriggerEvent('sigint:shotSpotterAlert', src, coords)
end)

-- ============================================================
-- IC MESAJ URETIMI (SendAgentMessage / CreateDeadDrop ortak govdesi)
-- ============================================================

local POLICE_HONEYPOT_LINES = {
    'Teslimat onaylanmistir. Belirtilen konuma ilerleyiniz.',
    'Talebiniz islem kaydina alinmistir. Standart prosedur uygulanacaktir.',
    'Baglanti guvenlik protokolune uygun sekilde surdurulmektedir.',
    'Rapor iletilmistir. Bir sonraki adim icin bekleyiniz.',
    'Bilgi dogrulanmistir. Islem devam etmektedir.',
}

local GENERIC_CHALLENGE_REPLIES = {
    'Anlamadim, ne demek istiyorsun?',
    'Bos ver simdi onu, ise odaklanalim.',
    'Konu disi soru sorma, vaktim yok.',
    'O ne alakasi simdi bununla?',
}

local function EmitTextMessage(agentId, channelId, text)
    local msg = {
        id         = GenerateMessageId('msg'),
        type       = 'text',
        channelId  = channelId,
        senderId   = agentId,
        senderName = GetAgentDisplayName(agentId),
        text       = text,
        timestamp  = os.time(),
        read       = false,
    }
    StoreMessage(channelId, msg)
    BroadcastToChannel('cybercomm:newMessage', msg)
    return msg
end

-- ============================================================
-- DISA ACIK API (Katman 1 buradan tetikler)
-- ============================================================
local function SendAgentMessageInternal(agentId, text, channelId)
    if type(agentId) ~= 'string' or type(text) ~= 'string' then return nil end
    if #text > Config.MaxTextLength then text = text:sub(1, Config.MaxTextLength) end

    channelId = channelId or Config.DefaultChannel
    local compliance = GetAgentComplianceState(agentId)

    if compliance.is_compromised then
        -- POLICE HONEYPOT: sorgu direnci cokmus ajanin eski agresif/kumarbaz
        -- uslubu tamamen silinir; hat artik resmi/soguk bir "operator"
        -- tarafindan kullanilir. Oyuncuya bu durum ACIKCA bildirilmez -
        -- ancak Crypto-Challenge ile fark edilebilir (bkz. asagida).
        text = POLICE_HONEYPOT_LINES[math.random(#POLICE_HONEYPOT_LINES)]
    else
        local bio      = GetAgentBiometrics(agentId)
        local stressed = (bio.cortisol or 0) >= 50 or bio.in_withdrawal
        if stressed then
            -- Panik harf tekrarlari: %15 olasilikla karakter 3'lenir
            text = text:gsub('%a', function(c)
                return math.random() < 0.15 and (c .. c .. c) or c
            end)
        end
    end

    local msg = EmitTextMessage(agentId, channelId, text)
    BumpLeakForOpenViewers(Config.LeakMessageGain)
    return msg.id
end

local function CreateDeadDropInternal(agentId, coords, channelId, caption)
    if type(agentId) ~= 'string' or type(coords) ~= 'vector3' then return nil end

    channelId = channelId or Config.DefaultChannel
    local bio  = GetAgentBiometrics(agentId)
    local exif = BuildExifPayload(coords, bio)

    -- DIKKAT: gercek koordinatlar (trueCoords) client'a GONDERILMEZ.
    local msg = {
        id         = GenerateMessageId('drop'),
        type       = 'photo',
        channelId  = channelId,
        senderId   = agentId,
        senderName = GetAgentDisplayName(agentId),
        caption    = type(caption) == 'string' and caption
                     or 'Zula birakildi. Sessizce teslim alin.',
        exif       = exif,          -- sadece goruntuleme icin (bozulmus olabilir)
        timestamp  = os.time(),
        read       = false,
        claimed    = false,
    }

    StoreMessage(channelId, msg)

    -- Gercek koordinatlar sunucuda tutulur; agentId FORENSIC DECAY ve
    -- CRYPTO-CHALLENGE dogrulamasinda kullanilmak uzere saklanir.
    DeadDrops[msg.id] = {
        coords    = vector3(coords.x, coords.y, coords.z),
        claimedBy = nil,
        agentId   = agentId,
    }

    BroadcastToChannel('cybercomm:newDeadDrop', msg)
    BumpLeakForOpenViewers(Config.LeakDeadDropGain)
    return msg.id
end

exports('SendAgentMessage',  SendAgentMessageInternal)
exports('CreateDeadDrop',    CreateDeadDropInternal)
exports('AdjustWallet',      AdjustWallet)
exports('GetWalletBalance',  GetWalletBalance)
exports('GetPacketLeakRatio', function(src) return GetLeakRatio(src) end)
exports('IsAgentHoneypotted', function(agentId) return GetAgentComplianceState(agentId).is_compromised end)

-- ============================================================
-- CLIENT -> SERVER (KATI DOGRULAMA)
-- ============================================================

RegisterServerEvent('cybercomm:requestSync')
AddEventHandler('cybercomm:requestSync', function()
    local src = source
    if not IsRequestAllowed(src) then return end
    local identifier = GetIdentifier(src)
    TriggerClientEvent('cybercomm:syncState', src, {
        channelId   = Config.DefaultChannel,
        channelName = Config.ChannelDisplayName,
        messages    = GetChannelMessages(Config.DefaultChannel),
        wallet      = { balance = GetWalletBalance(identifier) },
    })
end)

RegisterServerEvent('cybercomm:markRead')
AddEventHandler('cybercomm:markRead', function(messageId)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(messageId) ~= 'string' or #messageId == 0
       or #messageId > Config.MaxMessageIdLength then return end
    MarkMessageRead(Config.DefaultChannel, messageId)
end)

-- POLICE HONEYPOT & CRYPTO-CHALLENGE: oyuncu ajana gizli bir guvenlik
-- ifadesi gonderir. Cevap, ajanin gercek zaafina (Katman 1) gore mi yoksa
-- jenerik/alakasiz mi oldugu uzerinden oyuncunun kendi yorumuna birakilir -
-- sistem "dogru/yanlis" diye bir HUD gostermez (arcade degil).
RegisterServerEvent('cybercomm:sendChallenge')
AddEventHandler('cybercomm:sendChallenge', function(agentId, phrase)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(agentId) ~= 'string' or type(phrase) ~= 'string' then return end
    if #phrase == 0 or #phrase > 200 then return end

    local identifier = GetIdentifier(src)
    -- "Parolasiz teslim alma" kontrolu icin: bu ajana en az bir dogrulama
    -- girisimi yapildigi isaretlenir (sonuc basarili olmasa dahi).
    VerifiedChallenges[identifier .. '|' .. agentId] = true

    local compliance   = GetAgentComplianceState(agentId)
    local trait        = GetAgentSecretTrait(agentId)
    local phraseLower  = phrase:lower()

    local matchesTrait = false
    for _, kw in ipairs(trait.keywords or {}) do
        if phraseLower:find(kw, 1, true) then
            matchesTrait = true
            break
        end
    end

    local replyText
    if compliance.is_compromised or not matchesTrait then
        -- Ele gecirmis polis gercek zaafi BILEMEZ; alakasiz bir ifadeye de
        -- gercek ajan jenerik tepki verir. Oyuncu farki OKUYARAK cikarir.
        replyText = GENERIC_CHALLENGE_REPLIES[math.random(#GENERIC_CHALLENGE_REPLIES)]
    else
        replyText = trait.correctReply
    end

    EmitTextMessage(agentId, Config.DefaultChannel, replyText)
end)

-- ZULA TESLIM ALMA: konum dogrulamasi + parola dogrulamasi zorunlu (anti-exploit)
RegisterServerEvent('cybercomm:claimDeadDrop')
AddEventHandler('cybercomm:claimDeadDrop', function(messageId)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(messageId) ~= 'string' or #messageId > Config.MaxMessageIdLength then return end

    local drop = DeadDrops[messageId]
    if not drop then
        TriggerClientEvent('cybercomm:notify', src, { message = 'Zula bulunamadi.' })
        return
    end
    if drop.claimedBy then
        TriggerClientEvent('cybercomm:notify', src, { message = 'Bu zula zaten teslim alindi.' })
        return
    end

    -- Konum dogrulamasi: oyuncunun anlik ped pozisyonu
    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local pcoords = GetEntityCoords(ped)
    local dist    = #(pcoords - drop.coords)

    if dist > Config.DeadDropClaimRadius then
        print(('[layer2] ANTI-EXPLOIT: %s | %s | mesafe=%.2fm'):format(
            GetIdentifier(src), messageId, dist))
        TriggerClientEvent('cybercomm:notify', src, { message = 'Zula cok uzakta. Yaklas ve tekrar dene.' })
        return
    end

    local identifier = GetIdentifier(src)

    -- FORENSIC DECAY: teslim alma anindaki cevresel kosullara gore parmak
    -- izi bulasmasi uretilir (hem verifiye olsun olmasin, iz zaten birakilir).
    local forensics = BuildForensicDecay(drop.agentId)

    drop.claimedBy = identifier
    local entry = MessageIndex[messageId]
    if entry and entry.msg then
        entry.msg.claimed   = true
        entry.msg.claimedBy = identifier
        entry.msg.forensics = forensics
    end

    -- POLICE HONEYPOT / CRYPTO-CHALLENGE: bu ajan icin daha once HIC
    -- dogrulama (parola) girisimi yapilmamissa, "parolasiz teslim alma"
    -- sivil pusuyu tetikler. Odul verilmez.
    local verified = VerifiedChallenges[identifier .. '|' .. tostring(drop.agentId)]
    if not verified then
        if entry and entry.msg then entry.msg.ambushed = true end

        print(('[layer2] PAROLASIZ TESLIM ALMA: %s | ajan=%s | mesaj=%s'):format(
            identifier, tostring(drop.agentId), messageId))

        TriggerClientEvent('cybercomm:notify', src, {
            message = 'UYARI: Konum guvenli degildi. Bir sey ters gitti...',
        })
        -- Fiziksel pusu (NOOSE/SWAT spawn + saldiri) client.lua'da tetiklenir.
        -- Yerel 'sigint:*' event'i ayrica baska sistemlerin (Katman 3, log,
        -- dispatch) de tepki verebilmesi icin korunur.
        TriggerClientEvent('cybercomm:triggerAmbush', src, { coords = drop.coords })
        TriggerEvent('sigint:civilianAmbushTriggered', src, drop.coords, drop.agentId)
        return
    end

    -- Odul: server-side rastgele (asla client'tan gelmez)
    local reward = math.random(50, 150) / 100.0
    AdjustWallet(identifier, reward, 'deaddrop_claim')

    TriggerClientEvent('cybercomm:walletUpdate', src, {
        balance = GetWalletBalance(identifier),
    })
    TriggerClientEvent('cybercomm:notify', src, {
        message = string.format('Zula teslim alindi. +%.4f XMR', reward),
    })
end)

AddEventHandler('playerDropped', function()
    local src = source
    RateLimits[src]         = nil
    UiHeartbeat[src]        = nil
    PacketLeak[src]         = nil
    ActiveHunters[src]      = nil
    LockdownState[src]      = nil

    -- Oyuncu aniden ayrilirsa (crash/alt+f4), kendi spawn ettigi fiziksel
    -- varliklari (minibus, ped) artik temizleyecek bir client kalmaz. Bu
    -- yuzden network ID'leri KALAN tum client'lara yayinlanir; hangisi o
    -- entity'yi cozebiliyorsa siler (bkz. client.lua ForceDeleteNetworkEntities).
    local owned = SpawnedEntities[src]
    if owned then
        for _, netIds in pairs(owned) do
            if #netIds > 0 then
                TriggerClientEvent('cybercomm:forceDeleteNetworkEntities', -1, netIds)
            end
        end
        SpawnedEntities[src] = nil
    end
end)

-- ============================================================
-- DEMO MODU
-- ============================================================
CreateThread(function()
    if not Config.DemoMode then return end
    Wait(4000)
    SendAgentMessageInternal('agent_ux91',
        'Konum guvenli, mal hazir. Onay bekliyorum.', Config.DefaultChannel)

    Wait(3000)
    CreateDeadDropInternal('agent_kl04',
        vector3(215.4, -810.2, 30.7), Config.DefaultChannel,
        'Zula konumu ekte. Cabuk davranin, bolgede hareketlilik var.')
end)
