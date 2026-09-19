--[[
    KATMAN 2 | SERVER :: Kaynak-of-Truth
    v1.6.0 revizyonlari (Dual-Hook Sync + Bootstrap Edition):
      - HandlePlayerSync(src): cybercomm:requestSync ve
        layer2_cybercomm:server:RequestTelegramFeed eventlerini TEK
        noktada birlestirir. Istemci-server kanca uyumsuzlugu bitti.
      - SeedDefaultChannelIfEmpty(): Kanal bos ise agent_kl04 dead-drop
        + agent_ux91 text mesajini SESSIZ modda enjekte eder.
        Boylece NUI'ye giden messages dizisi asla bos kalmaz.
      - CreateDeadDropInternal / SendAgentMessageInternal: 'silent'
        parametresi eklendi (bootstrap sirasinda broadcast ve leak
        bump'i engeller; duplicate NUI balonu olusmaz).
      - Startup seed thread'i: ilk oyuncu F6 basmadan kanal dolu olur.
      - v1.5.0 SafSync zırhları korundu (pcall + fallback).

    v1.7.0 revizyonlari (KATMAN 4 :: Kriminalistik ve Gizli Parmak Izleri):
      - BuildForensicDecay(agentId, claimantIdentifier, messageId, coords):
        latentPrintWeight artik sadece kozmetik degil; iklim (sicaklik/nem)
        VE zulayi fiziken kaldiran oyuncunun kortizol/yoksunluk durumuna
        (el teri + epitel doku transferi) bagli olarak dinamik hesaplanir.
      - PersistLatentPrint(): son olculen katsayi sigint_cellular_matrix
        tablosundaki latent_print_weight sutununa ASENKRON (SafeExecute,
        fire-and-forget) yazilir. Ana akisi asla bloklamaz.
      - LogAfisColdCase(): agirlik Config.ForensicUndergroundThreshold'u
        (%60) gectiginde sigint_afis_cold_cases tablosuna "faili mechul"
        bir soguk vaka kaydi dusurulur. Bu, Katman 3 (polis) tarafinin
        ileride AFIS eslestirmesi yapabilecegi kalici kriminal altyapidir.
      - Sema saglik kontrolu (ColumnHealth / AfisHealth): migration
        (sql/katman4_migration.sql) henuz calistirilmamissa yazimlar
        sessizce atlanir, resource CRASH OLMAZ (mevcut DbHealth zirh
        deseniyle birebir tutarli).
      - Mevcut anti-exploit / rate-limit / lockdown bariyerlerine
        DOKUNULMADI; tum yeni DB yazimlari CreateThread + SafeExecute
        araciligiyla asenkron yurutulur (0.00 ms resmon).

    Tablo: sigint_cellular_matrix
      - citizen_identifier      (PK)
      - crypto_balance          (DECIMAL)
      - is_compromised          (INT)
      - crypto_challenge_phrase (VARCHAR NULL)
      - latent_print_weight     (DECIMAL NULL)  -- KATMAN 4

    Tablo: sigint_afis_cold_cases (KATMAN 4, bkz. sql/katman4_migration.sql)
      - case_id, fingerprint_id, suspect_identifier, dead_drop_message_id,
        latent_print_weight, temperature_c, humidity_pct, pos_x/y/z,
        matched, logged_at
]]

local oxmysql = exports.oxmysql

local Config = {
    Layer1ResourceName  = 'fivem_sigint_layer1',
    DefaultChannel      = 'ops-07',
    ChannelDisplayName  = 'OPSEC :: Kanal-07',
    DemoMode            = false,

    MaxMessageIdLength  = 128,
    MaxTextLength       = 1024,

    RateLimitWindow     = 1.0,
    RateLimitMaxHits    = 8,

    DeadDropClaimRadius = 3.0,
    WalletMaxDelta      = 500.0,
    ChannelHistoryCap   = 300,

    HeartbeatTimeoutSeconds  = 8.0,
    LeakHeartbeatGain        = 2,
    LeakMessageGain          = 10,
    LeakDeadDropGain         = 18,
    LeakDecayPerSecond       = 0.35,
    LeakHunterThreshold      = 75,
    LeakLockdownThreshold    = 95,
    LeakPostLockdownResidual = 35,
    LockdownDurationSeconds  = 45,
    HunterSpawnMinDistance   = 80.0,
    HunterSpawnMaxDistance   = 100.0,

    ForensicUndergroundThreshold = 60,

    -- KATMAN 4: el teri / epitel doku transferi katkisi
    LatentPrintCortisolWeight    = 25,  -- kortizol 0-100 -> +0..+25 puan
    LatentPrintWithdrawalBonus   = 8,   -- yoksunluk titremesi -> ek +8 puan

    ShotSpotterCooldownSeconds = 3.0,
    ShotSpotterMaxDistance     = 15.0,
    ShotSpotterWorldBound      = 5000.0,

    StaleEntityCleanupSeconds  = 600,

    DbWriteBackIntervalMs      = 2000,
    DbTableName                = 'sigint_cellular_matrix',
    DbAfisTableName            = 'sigint_afis_cold_cases', -- KATMAN 4
}

-- ============================================================
-- BELLEK-ICI STATE
-- ============================================================
local Channels           = {}
local RateLimits         = {}
local DeadDrops          = {}
local MessageIndex       = {}

local UiHeartbeat        = {}
local PacketLeak         = {}
local ActiveHunters      = {}
local LockdownState      = {}
local VerifiedChallenges = {}

local SpawnedEntities    = {}
local ShotSpotterCooldown = {}

local AccountCache  = {}
local LoadingQueue  = {}

-- v1.6.0: Bootstrap bayraklari
local BootstrapState = {
    seeded = false,
}

local DbHealth = {
    full_schema_ok = nil,
    last_probe_at  = 0,
}

-- KATMAN 4: migration henuz calistirilmadiysa yazimlari sessizce atlamak icin
local ColumnHealth = {
    latent_print_ok = nil, -- nil = henuz probe edilmedi, true/false = sonuc
}
local AfisHealth = {
    table_ok = nil,
}

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

local function IsPlayerAlive(src)
    local ped = GetPlayerPed(src)
    if ped == 0 or not DoesEntityExist(ped) then return false end
    if IsEntityDead(ped) then return false end
    return true
end

local function IsPlayerStillConnected(src)
    return GetPlayerName(src) ~= nil
end

-- ============================================================
-- v1.5.0 | DB KATMANI — CELIK GIBI ZIRHLI
-- ============================================================

local function SafeExecuteSync(query, params)
    local ok, result = pcall(function()
        return oxmysql:executeSync(query, params)
    end)
    if not ok then return nil, tostring(result) end
    return result, nil
end

local function SafeExecute(query, params)
    local ok, err = pcall(function()
        return oxmysql:execute(query, params)
    end)
    return ok, err
end

local function DbFetchRow(identifier)
    local q1 = ('SELECT crypto_balance, is_compromised, crypto_challenge_phrase '
                .. 'FROM %s WHERE citizen_identifier = ? LIMIT 1')
               :format(Config.DbTableName)
    local rows, err = SafeExecuteSync(q1, { identifier })

    if rows and rows[1] then
        DbHealth.full_schema_ok = true
        local r = rows[1]
        return {
            crypto_balance          = tonumber(r.crypto_balance) or 0.0,
            is_compromised          = tonumber(r.is_compromised) or 0,
            crypto_challenge_phrase = r.crypto_challenge_phrase,
        }
    end

    if rows and not rows[1] then
        DbHealth.full_schema_ok = true
        return nil
    end

    DbHealth.full_schema_ok = false
    local q2 = ('SELECT crypto_balance FROM %s '
                .. 'WHERE citizen_identifier = ? LIMIT 1')
               :format(Config.DbTableName)
    local rows2 = SafeExecuteSync(q2, { identifier })

    if rows2 and rows2[1] then
        return {
            crypto_balance          = tonumber(rows2[1].crypto_balance) or 0.0,
            is_compromised          = 0,
            crypto_challenge_phrase = nil,
        }
    end

    if err then
        print(('[layer2] DB FATAL fetch: %s | %s'):format(identifier, err))
    end
    return nil
end

local function DbInsertRow(identifier)
    -- imei sutunu bazi semalarda NOT NULL'dir; NULL ile explicit set edilir.
    local q1 = ('INSERT IGNORE INTO %s '
                .. '(citizen_identifier, crypto_balance, is_compromised, imei) '
                .. 'VALUES (?, 0, 0, NULL)'):format(Config.DbTableName)
    local rows, err = SafeExecuteSync(q1, { identifier })
    if rows then return true end

    -- Fallback: imei sutunu hic yoksa
    local q2 = ('INSERT IGNORE INTO %s '
                .. '(citizen_identifier, crypto_balance, is_compromised) '
                .. 'VALUES (?, 0, 0)'):format(Config.DbTableName)
    local rows2 = SafeExecuteSync(q2, { identifier })
    if rows2 then return true end

    if err then
        print(('[layer2] DB FATAL insert: %s | %s'):format(identifier, err))
    end
    return false
end

local function RowToAccount(row)
    return {
        balance                 = tonumber(row.crypto_balance) or 0.0,
        is_compromised          = tonumber(row.is_compromised) == 1,
        crypto_challenge_phrase = row.crypto_challenge_phrase,
        dirty                   = false,
    }
end

local function LoadAccountFromDb(identifier)
    local row = DbFetchRow(identifier)
    if not row then
        DbInsertRow(identifier)
        return {
            balance                 = 0.0,
            is_compromised          = false,
            crypto_challenge_phrase = nil,
            dirty                   = false,
        }
    end
    return RowToAccount(row)
end

local function EnsureAccount(identifier, cb)
    if type(identifier) ~= 'string' or #identifier == 0 then
        if cb then
            pcall(cb, {
                balance = 0.0, is_compromised = false,
                crypto_challenge_phrase = nil, dirty = false,
            })
        end
        return nil
    end

    local cached = AccountCache[identifier]
    if cached then
        if cb then pcall(cb, cached) end
        return cached
    end

    local queue = LoadingQueue[identifier]
    if queue then
        if cb then queue[#queue + 1] = cb end
        return nil
    end

    LoadingQueue[identifier] = cb and { cb } or {}

    CreateThread(function()
        local ok, acc = pcall(LoadAccountFromDb, identifier)
        if not ok or type(acc) ~= 'table' then
            acc = {
                balance = 0.0, is_compromised = false,
                crypto_challenge_phrase = nil, dirty = false,
            }
        end
        AccountCache[identifier] = acc

        local waiting = LoadingQueue[identifier]
        LoadingQueue[identifier] = nil
        if waiting then
            for _, fn in ipairs(waiting) do
                local okcb, errcb = pcall(fn, acc)
                if not okcb then
                    print('[layer2] EnsureAccount cb error: ' .. tostring(errcb))
                end
            end
        end
    end)

    return nil
end

local function FlushAccount(identifier)
    local acc = AccountCache[identifier]
    if not acc or not acc.dirty then return end
    acc.dirty = false

    local q = ('UPDATE %s SET crypto_balance = ? WHERE citizen_identifier = ?')
              :format(Config.DbTableName)
    local ok = SafeExecute(q, { acc.balance, identifier })
    if not ok then
        acc.dirty = true
    end
end

-- ============================================================
-- KATMAN 4 | DB YAZIMLARI — GIZLI PARMAK IZLERI / AFIS
-- Tumu SafeExecute (asenkron, fire-and-forget) uzerinden yurur;
-- ana oyun thread'ini veya claimDeadDrop akisini ASLA bloklamaz.
-- ============================================================

local function PersistLatentPrint(identifier, weight)
    if ColumnHealth.latent_print_ok == false then return end
    if type(identifier) ~= 'string' or type(weight) ~= 'number' then return end

    local q = ('UPDATE %s SET latent_print_weight = ? WHERE citizen_identifier = ?')
              :format(Config.DbTableName)
    local ok = SafeExecute(q, { weight, identifier })
    if not ok then
        print(('[layer2][KATMAN4] latent_print_weight yazilamadi: %s')
            :format(identifier))
    end
end

local function LogAfisColdCase(caseData)
    if AfisHealth.table_ok == false then return end
    if type(caseData) ~= 'table' or type(caseData.identifier) ~= 'string' then return end

    local coords = caseData.coords
    local posX = coords and coords.x or 0.0
    local posY = coords and coords.y or 0.0
    local posZ = coords and coords.z or 0.0

    local q = ('INSERT INTO %s '
        .. '(fingerprint_id, suspect_identifier, dead_drop_message_id, '
        .. 'latent_print_weight, temperature_c, humidity_pct, pos_x, pos_y, pos_z) '
        .. 'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'):format(Config.DbAfisTableName)

    local ok = SafeExecute(q, {
        caseData.fingerprintId,
        caseData.identifier,
        caseData.messageId,
        caseData.weight,
        caseData.temperature,
        caseData.humidity,
        posX, posY, posZ,
    })

    if ok then
        -- HeidiSQL / admin konsolundan izlenebilir net bir kriminal iz kaydi
        print(('[layer2][KATMAN4] AFIS SOGUK VAKA :: fp=%s suspect=%s agirlik=%.1f%% '
            .. 'mesaj=%s konum=(%.2f, %.2f, %.2f)')
            :format(caseData.fingerprintId, caseData.identifier, caseData.weight,
                    tostring(caseData.messageId), posX, posY, posZ))
    else
        print(('[layer2][KATMAN4] AFIS kayit HATASI: fp=%s suspect=%s')
            :format(caseData.fingerprintId, caseData.identifier))
    end
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

local function GetAgentComplianceState(agentId)
    local acc = AccountCache[agentId]
    if acc then return { is_compromised = acc.is_compromised } end

    local fallback = { is_compromised = false }
    if GetResourceState(Config.Layer1ResourceName) ~= 'started' then return fallback end
    local ok, data = pcall(function()
        return exports[Config.Layer1ResourceName]:GetAgentComplianceState(agentId)
    end)
    if not ok or type(data) ~= 'table' then return fallback end
    return { is_compromised = data.is_compromised == true }
end

local function GetAgentCriminalRecord(agentId)
    local fallback = { recordScore = 0 }
    if GetResourceState(Config.Layer1ResourceName) ~= 'started' then return fallback end
    local ok, data = pcall(function()
        return exports[Config.Layer1ResourceName]:GetAgentCriminalRecord(agentId)
    end)
    if not ok or type(data) ~= 'table' then return fallback end
    return { recordScore = tonumber(data.recordScore) or 0 }
end

-- ============================================================
-- EXIF URETIMI
-- ============================================================
local function BuildExifPayload(coords, bio)
    local stressed = (bio.cortisol or 0) >= 50 or bio.in_withdrawal

    local jitter   = stressed and 0.008 or 0.0003
    local lat      = coords.x + (math.random() - 0.5) * jitter * 2
    local lon      = coords.y + (math.random() - 0.5) * jitter * 2
    local alt      = coords.z + (stressed and (math.random() - 0.5) * 1.5 or 0)
    local accuracy = stressed and math.random(120, 400) or math.random(3, 15)
    local ts       = os.time() + (stressed and math.random(-1800, 1800) or 0)

    local bytes = {}
    for i = 1, 16 do bytes[i] = string.format('%02X', math.random(0, 255)) end
    if stressed then
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
-- FORENSIC DECAY
-- ============================================================
local function GetVirtualClimate()
    local hour = tonumber(os.date('%H')) or 12
    local baseTemp = 14 + math.sin((hour / 24) * math.pi * 2) * 10
    local temperature = baseTemp + (math.random(-20, 20) / 10)
    local humidity = math.max(10, math.min(100, 55 + math.random(-15, 25)))
    return temperature, humidity
end

local function GenerateFingerprintId(agentId)
    local hash = GetHashKey('fingerprint:' .. tostring(agentId)) & 0xFFFFFFFF
    return ('LP-%08X'):format(hash)
end

--- v1.7.0 (KATMAN 4): claimantIdentifier/messageId/coords eklendi.
--- agentId    : zulayi birakan ajan (mevcut "yeralti satici" recordScore
---              kontrolu icin -- DAVRANIS DEGISMEDI).
--- claimant*  : paketi FIZIKEN kaldiran oyuncu -- yeni latent-print /
---              AFIS zincirinin sahibi budur.
local function BuildForensicDecay(agentId, claimantIdentifier, messageId, coords)
    local temperature, humidity = GetVirtualClimate()

    local tempDelta     = math.abs(temperature - 22)
    local humidityDelta = math.abs(humidity - 60)
    local baseWeight = 100 - (tempDelta * 2.2) - (humidityDelta * 0.8) + math.random(-5, 5)

    -- KATMAN 4: el teri / epitel doku transferi -- kaldiran oyuncunun
    -- kortizol (stres) ve yoksunluk durumu izin daha net/agir birakilmasina
    -- neden olur (fazla terleme -> daha iyi latent print aderansi).
    local stressBonus = 0
    if type(claimantIdentifier) == 'string' then
        local claimantBio = GetAgentBiometrics(claimantIdentifier)
        stressBonus = math.min(Config.LatentPrintCortisolWeight,
            ((claimantBio.cortisol or 0) / 100) * Config.LatentPrintCortisolWeight)
        if claimantBio.in_withdrawal then
            stressBonus = stressBonus + Config.LatentPrintWithdrawalBonus
        end
    end

    local latentPrintWeight = math.max(0, math.min(100, baseWeight + stressBonus))

    local fingerprintId = GenerateFingerprintId(agentId)
    local record = GetAgentCriminalRecord(agentId)
    local matchesUndergroundDealers =
        record.recordScore >= Config.ForensicUndergroundThreshold

    if matchesUndergroundDealers then
        TriggerEvent('sigint:undergroundDealerMatch', agentId, fingerprintId, record.recordScore)
        if GetResourceState(Config.Layer1ResourceName) == 'started' then
            pcall(function()
                exports[Config.Layer1ResourceName]:FlagUndergroundDealerMatch(agentId, fingerprintId)
            end)
        end
    end

    local forensics = {
        fingerprintId          = fingerprintId,
        latentPrintWeight      = tonumber(string.format('%.1f', latentPrintWeight)),
        temperature            = tonumber(string.format('%.1f', temperature)),
        humidity               = humidity,
        undergroundDealerMatch = matchesUndergroundDealers,
    }

    -- KATMAN 4: DB yazimlari + AFIS esik kontrolu -- her zaman ASENKRON.
    -- Bu thread claimDeadDrop'un donus degerini ASLA bekletmez.
    if type(claimantIdentifier) == 'string' then
        CreateThread(function()
            PersistLatentPrint(claimantIdentifier, forensics.latentPrintWeight)

            if forensics.latentPrintWeight >= Config.ForensicUndergroundThreshold then
                LogAfisColdCase({
                    fingerprintId = fingerprintId,
                    identifier    = claimantIdentifier,
                    messageId     = messageId,
                    weight        = forensics.latentPrintWeight,
                    temperature   = forensics.temperature,
                    humidity      = forensics.humidity,
                    coords        = coords,
                })
                TriggerEvent('sigint:afisColdCaseLogged',
                    claimantIdentifier, fingerprintId, forensics.latentPrintWeight)
            end
        end)
    end

    return forensics
end

-- ============================================================
-- DEPOLAMA (RAM — mesaj gecmisi)
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
-- CUZDAN
-- ============================================================
local function GetWalletBalance(identifier)
    local acc = AccountCache[identifier]
    if acc then return acc.balance end
    return 0.0
end

local function AdjustWallet(identifier, delta, reason)
    if type(identifier) ~= 'string' then return false, 'invalid_identifier' end
    delta = tonumber(delta)
    if not delta then return false, 'invalid_delta' end
    if math.abs(delta) > Config.WalletMaxDelta then
        print(('[layer2] Wallet delta reddedildi: %s | %s | %.4f')
            :format(identifier, tostring(reason), delta))
        return false, 'delta_too_large'
    end

    local acc = AccountCache[identifier]
    if acc then
        acc.balance = math.max(0.0, acc.balance + delta)
        acc.dirty   = true
        return true, acc.balance
    end

    EnsureAccount(identifier, function(a)
        if type(a) == 'table' then
            a.balance = math.max(0.0, (a.balance or 0.0) + delta)
            a.dirty   = true
        end
    end)
    return true, delta
end

-- ============================================================
-- BROADCAST
-- ============================================================
local function BroadcastToChannel(eventName, msg)
    TriggerClientEvent(eventName, -1, msg)
end

-- ============================================================
-- SIGINT MOBILE TRACKER
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
    PacketLeak[src] = {
        ratio  = math.max(0, math.min(100, value)),
        lastAt = os.clock(),
    }
end

local function BumpLeakRatio(src, delta)
    SetLeakRatio(src, GetLeakRatio(src) + delta)
end

local EvaluateLeakThresholds

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
    local spawnDist = math.random(
        math.floor(Config.HunterSpawnMinDistance),
        math.floor(Config.HunterSpawnMaxDistance)
    )
    local spawnCoords = vector3(
        origin.x + math.cos(angle) * spawnDist,
        origin.y + math.sin(angle) * spawnDist,
        origin.z
    )

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
    ActiveHunters[src] = nil

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
    elseif ratio >= Config.LeakHunterThreshold
       and not ActiveHunters[src]
       and not LockdownState[src] then
        StartSigintHunter(src)
    end
end

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

-- ============================================================
-- ENTITY CLEANUP
-- ============================================================
local function TryServerDeleteNetEntities(netIds)
    local remaining = {}
    for _, netId in ipairs(netIds) do
        if type(netId) == 'number' then
            local ent = NetworkGetEntityFromNetworkId(netId)
            if ent and ent ~= 0 and DoesEntityExist(ent) then
                SetEntityAsMissionEntity(ent, true, true)
                DeleteEntity(ent)
            else
                remaining[#remaining + 1] = netId
            end
        end
    end
    return remaining
end

RegisterServerEvent('cybercomm:registerSpawnedEntities')
AddEventHandler('cybercomm:registerSpawnedEntities', function(category, netIds)
    local src = source
    if not src or src <= 0 then return end
    if type(category) ~= 'string' or type(netIds) ~= 'table' then return end
    SpawnedEntities[src] = SpawnedEntities[src] or {}
    SpawnedEntities[src][category] = {
        netIds     = netIds,
        lastUpdate = os.time(),
    }
end)

RegisterServerEvent('cybercomm:unregisterSpawnedEntities')
AddEventHandler('cybercomm:unregisterSpawnedEntities', function(category)
    local src = source
    if not src or src <= 0 then return end
    if type(category) ~= 'string' then return end
    ForgetSpawnedEntities(src, category)
end)

-- ============================================================
-- SHOTSPOTTER
-- ============================================================
RegisterServerEvent('cybercomm:reportShotSpotter')
AddEventHandler('cybercomm:reportShotSpotter', function(coords)
    local src = source
    if not src or src <= 0 then return end
    if not IsRequestAllowed(src) then return end

    if type(coords) ~= 'vector3' then return end
    if coords.x ~= coords.x or coords.y ~= coords.y or coords.z ~= coords.z then
        return
    end

    local bound = Config.ShotSpotterWorldBound
    if math.abs(coords.x) > bound or math.abs(coords.y) > bound then return end

    local now  = os.clock()
    local last = ShotSpotterCooldown[src]
    if last and (now - last) < Config.ShotSpotterCooldownSeconds then
        return
    end

    if not IsPlayerAlive(src) then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)

    local dist = #(pedCoords - coords)
    if dist > Config.ShotSpotterMaxDistance then
        print(('[layer2] ANTI-EXPLOIT ShotSpotter: %s | mesafe=%.2fm')
            :format(GetIdentifier(src), dist))
        return
    end

    local weapon = GetSelectedPedWeapon(ped)
    if weapon == GetHashKey('WEAPON_UNARMED') then return end

    ShotSpotterCooldown[src] = now
    TriggerEvent('sigint:shotSpotterAlert', src, coords)
end)

-- ============================================================
-- IC MESAJ URETIMI
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

--- v1.6.0: 'silent' parametresi. true ise BroadcastToChannel VE
--- BumpLeakForOpenViewers atlanir (bootstrap icin kritik).
local function EmitTextMessage(agentId, channelId, text, silent)
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
    if not silent then
        BroadcastToChannel('cybercomm:newMessage', msg)
    end
    return msg
end

-- ============================================================
-- DISA ACIK API
-- ============================================================
local function SendAgentMessageInternal(agentId, text, channelId, silent)
    if type(agentId) ~= 'string' or type(text) ~= 'string' then return nil end
    if #text > Config.MaxTextLength then text = text:sub(1, Config.MaxTextLength) end

    channelId = channelId or Config.DefaultChannel
    local compliance = GetAgentComplianceState(agentId)

    if compliance.is_compromised then
        text = POLICE_HONEYPOT_LINES[math.random(#POLICE_HONEYPOT_LINES)]
    else
        local bio      = GetAgentBiometrics(agentId)
        local stressed = (bio.cortisol or 0) >= 50 or bio.in_withdrawal
        if stressed then
            text = text:gsub('%a', function(c)
                return math.random() < 0.15 and (c .. c .. c) or c
            end)
        end
    end

    local msg = EmitTextMessage(agentId, channelId, text, silent)
    if not silent then
        BumpLeakForOpenViewers(Config.LeakMessageGain)
    end
    return msg.id
end

local function CreateDeadDropInternal(agentId, coords, channelId, caption, silent)
    if type(agentId) ~= 'string' or type(coords) ~= 'vector3' then return nil end

    channelId = channelId or Config.DefaultChannel
    local bio  = GetAgentBiometrics(agentId)
    local exif = BuildExifPayload(coords, bio)

    local msg = {
        id         = GenerateMessageId('drop'),
        type       = 'photo',
        channelId  = channelId,
        senderId   = agentId,
        senderName = GetAgentDisplayName(agentId),
        caption    = type(caption) == 'string' and caption
                     or 'Zula birakildi. Sessizce teslim alin.',
        exif       = exif,
        timestamp  = os.time(),
        read       = false,
        claimed    = false,
    }

    StoreMessage(channelId, msg)
    DeadDrops[msg.id] = {
        coords    = vector3(coords.x, coords.y, coords.z),
        claimedBy = nil,
        agentId   = agentId,
    }

    if not silent then
        BroadcastToChannel('cybercomm:newDeadDrop', msg)
        BumpLeakForOpenViewers(Config.LeakDeadDropGain)
    end
    return msg.id
end

-- ============================================================
-- v1.6.0 BOOTSTRAP: Kanal bos ise sessizce tohumla
-- ============================================================
local function SeedDefaultChannelIfEmpty()
    if BootstrapState.seeded then return end

    local ch = GetChannel(Config.DefaultChannel)
    if ch and #ch.messages > 0 then
        BootstrapState.seeded = true
        return
    end

    -- agent_ux91 text mesaji (sessiz)
    SendAgentMessageInternal('agent_ux91',
        'Konum guvenli, mal hazir. Onay bekliyorum.',
        Config.DefaultChannel, true)

    -- agent_kl04 dead-drop (sessiz, NUI'ye newDeadDrop eventi GITMEZ)
    CreateDeadDropInternal('agent_kl04',
        vector3(215.4, -810.2, 30.7),
        Config.DefaultChannel,
        'Zula konumu ekte. Cabuk davranin, bolgede hareketlilik var.',
        true)

    BootstrapState.seeded = true
    print('[layer2] Bootstrap: kanal seed edildi (agent_ux91 + agent_kl04)')
end

-- ============================================================
-- v1.6.0 MERKEZI SYNC MOTORU
-- cybercomm:requestSync VE layer2_cybercomm:server:RequestTelegramFeed
-- eventlerinin IKISINI de yakalar.
-- ============================================================
local function HandlePlayerSync(src)
    if not src or src <= 0 then return end
    if not IsRequestAllowed(src) then return end

    -- 1) Kanal bos ise sessizce seed et (idempotent, sync oncesi)
    SeedDefaultChannelIfEmpty()

    -- 2) DB'den (veya cache'ten) hesabi yukle, hazir olunca sync gonder
    local identifier = GetIdentifier(src)
    EnsureAccount(identifier, function(acc)
        if not IsPlayerStillConnected(src) then return end

        local messages = GetChannelMessages(Config.DefaultChannel)

        TriggerClientEvent('cybercomm:syncState', src, {
            channelId   = Config.DefaultChannel,
            channelName = Config.ChannelDisplayName,
            messages    = messages,
            wallet      = { balance = (type(acc) == 'table' and acc.balance) or 0.0 },
        })
    end)
end

exports('SendAgentMessage',  SendAgentMessageInternal)
exports('CreateDeadDrop',    CreateDeadDropInternal)
exports('AdjustWallet',      AdjustWallet)
exports('GetWalletBalance',  GetWalletBalance)
exports('GetPacketLeakRatio', function(src) return GetLeakRatio(src) end)
exports('IsAgentHoneypotted', function(agentId)
    return GetAgentComplianceState(agentId).is_compromised
end)

-- KATMAN 4: Katman 3 (polis/narkotik) tarafi icin AFIS kopru API'si.
-- Bu resource kendi polis arayuzunu SUNMAZ; sadece soguk vaka kuyrugunu
-- disa acar ki ileride baska bir kaynak geriye donuk eslestirme yapabilsin.
exports('GetPendingAfisCases', function(limit)
    limit = tonumber(limit) or 50
    if limit < 1 then limit = 1 end
    if limit > 200 then limit = 200 end

    local q = ('SELECT case_id, fingerprint_id, suspect_identifier, dead_drop_message_id, '
        .. 'latent_print_weight, pos_x, pos_y, pos_z, logged_at FROM %s '
        .. 'WHERE matched = 0 ORDER BY logged_at DESC LIMIT ?')
        :format(Config.DbAfisTableName)
    local rows = SafeExecuteSync(q, { limit })
    return rows or {}
end)

exports('MarkAfisCaseMatched', function(caseId)
    caseId = tonumber(caseId)
    if not caseId then return false end
    local q = ('UPDATE %s SET matched = 1 WHERE case_id = ?'):format(Config.DbAfisTableName)
    local ok = SafeExecute(q, { caseId })
    return ok and true or false
end)

-- ============================================================
-- CLIENT -> SERVER | CIFT KANCA
-- ============================================================
RegisterServerEvent('cybercomm:requestSync')
AddEventHandler('cybercomm:requestSync', function()
    HandlePlayerSync(source)
end)

RegisterServerEvent('layer2_cybercomm:server:RequestTelegramFeed')
AddEventHandler('layer2_cybercomm:server:RequestTelegramFeed', function()
    HandlePlayerSync(source)
end)

RegisterServerEvent('cybercomm:markRead')
AddEventHandler('cybercomm:markRead', function(messageId)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(messageId) ~= 'string' or #messageId == 0
       or #messageId > Config.MaxMessageIdLength then return end
    MarkMessageRead(Config.DefaultChannel, messageId)
end)

RegisterServerEvent('cybercomm:sendChallenge')
AddEventHandler('cybercomm:sendChallenge', function(agentId, phrase)
    local src = source
    if not IsRequestAllowed(src) then return end
    if type(agentId) ~= 'string' or type(phrase) ~= 'string' then return end
    if #phrase == 0 or #phrase > 200 then return end
    if #agentId == 0 or #agentId > 128 then return end

    local identifier = GetIdentifier(src)
    local localPhrase = phrase:lower()

    CreateThread(function()
        local ok, row = pcall(DbFetchRow, agentId)
        if not ok then row = nil end

        local isCompromised = false
        local stored        = nil
        if type(row) == 'table' then
            isCompromised = tonumber(row.is_compromised) == 1
            stored        = row.crypto_challenge_phrase
        else
            DbInsertRow(agentId)
        end

        VerifiedChallenges[identifier .. '|' .. agentId] = true

        local replyText
        if isCompromised then
            replyText = GENERIC_CHALLENGE_REPLIES[math.random(#GENERIC_CHALLENGE_REPLIES)]
        else
            local matched = false
            if type(stored) == 'string' and #stored > 0 then
                local storedLower = stored:lower()
                if localPhrase == storedLower
                   or localPhrase:find(storedLower, 1, true) then
                    matched = true
                end
            end

            if matched then
                replyText = stored
            else
                replyText = GENERIC_CHALLENGE_REPLIES[math.random(#GENERIC_CHALLENGE_REPLIES)]
            end
        end

        EmitTextMessage(agentId, Config.DefaultChannel, replyText)
    end)
end)

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

    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local pcoords = GetEntityCoords(ped)
    local dist    = #(pcoords - drop.coords)

    if dist > Config.DeadDropClaimRadius then
        print(('[layer2] ANTI-EXPLOIT: %s | %s | mesafe=%.2fm')
            :format(GetIdentifier(src), messageId, dist))
        TriggerClientEvent('cybercomm:notify', src,
            { message = 'Zula cok uzakta. Yaklas ve tekrar dene.' })
        return
    end

    local identifier = GetIdentifier(src)
    -- KATMAN 4: fiziksel temas anindaki latent print + AFIS zinciri.
    -- drop.coords, drop.claimedBy mutasyona ugramadan ONCE aliniyor.
    local forensics  = BuildForensicDecay(drop.agentId, identifier, messageId, drop.coords)

    drop.claimedBy = identifier
    local entry = MessageIndex[messageId]
    if entry and entry.msg then
        entry.msg.claimed   = true
        entry.msg.claimedBy = identifier
        entry.msg.forensics = forensics
    end

    local verified = VerifiedChallenges[identifier .. '|' .. tostring(drop.agentId)]
    if not verified then
        if entry and entry.msg then entry.msg.ambushed = true end

        print(('[layer2] PAROLASIZ TESLIM ALMA: %s | ajan=%s | mesaj=%s')
            :format(identifier, tostring(drop.agentId), messageId))

        TriggerClientEvent('cybercomm:notify', src, {
            message = 'UYARI: Konum guvenli degildi. Bir sey ters gitti...',
        })

        TriggerEvent('sigint:shotSpotterAlert', src, drop.coords)
        TriggerClientEvent('cybercomm:triggerAmbush', src, { coords = drop.coords })
        TriggerEvent('sigint:civilianAmbushTriggered', src, drop.coords, drop.agentId)
        return
    end

    local reward = math.random(50, 150) / 100.0
    AdjustWallet(identifier, reward, 'deaddrop_claim')

    local acc = AccountCache[identifier]
    local newBal = (acc and acc.balance) or GetWalletBalance(identifier)

    TriggerClientEvent('cybercomm:walletUpdate', src, { balance = newBal })
    TriggerClientEvent('cybercomm:notify', src, {
        message = string.format('Zula teslim alindi. +%.4f XMR', reward),
    })
end)

-- ============================================================
-- PLAYER DROPPED
-- ============================================================
AddEventHandler('playerDropped', function()
    local src = source

    local identifier = GetIdentifier(src)
    if identifier then FlushAccount(identifier) end

    RateLimits[src]          = nil
    UiHeartbeat[src]         = nil
    PacketLeak[src]          = nil
    ActiveHunters[src]       = nil
    LockdownState[src]       = nil
    ShotSpotterCooldown[src] = nil

    local owned = SpawnedEntities[src]
    if owned then
        for _, record in pairs(owned) do
            local netIds = record and record.netIds
            if type(netIds) == 'table' and #netIds > 0 then
                local remaining = TryServerDeleteNetEntities(netIds)
                if #remaining > 0 then
                    TriggerClientEvent('cybercomm:forceDeleteNetworkEntities', -1, remaining)
                end
            end
        end
        SpawnedEntities[src] = nil
    end
end)

-- ============================================================
-- DEBOUNCE WRITE-BACK
-- ============================================================
CreateThread(function()
    while true do
        Wait(Config.DbWriteBackIntervalMs)
        for identifier in pairs(AccountCache) do
            FlushAccount(identifier)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for identifier, acc in pairs(AccountCache) do
        if acc.dirty then
            acc.dirty = false
            local q = ('UPDATE %s SET crypto_balance = ? WHERE citizen_identifier = ?')
                      :format(Config.DbTableName)
            SafeExecuteSync(q, { acc.balance, identifier })
        end
    end
end)

-- ============================================================
-- v1.6.0 STARTUP BOOTSTRAP + DB HEALTH CHECK
-- ============================================================
CreateThread(function()
    -- 1) Kanal tohumlamasi (ilk oyuncu gelmeden hazir olsun)
    Wait(2000)
    SeedDefaultChannelIfEmpty()

    -- 2) DB health check (3 deneme)
    for attempt = 1, 3 do
        local q = ('SELECT crypto_balance, is_compromised, crypto_challenge_phrase '
                   .. 'FROM %s LIMIT 1'):format(Config.DbTableName)
        local rows, err = SafeExecuteSync(q, {})

        if rows then
            print(('[layer2] DB health OK | schema tam | tablo=%s')
                :format(Config.DbTableName))
            DbHealth.full_schema_ok = true
            break
        end

        local q2 = ('SELECT crypto_balance FROM %s LIMIT 1')
                   :format(Config.DbTableName)
        local rows2 = SafeExecuteSync(q2, {})
        if rows2 then
            print(('[layer2] DB health UYARI: sema eksik | '
                .. '`is_compromised` veya `crypto_challenge_phrase` sutunu yok.'))
            DbHealth.full_schema_ok = false
            break
        end

        if err then
            print(('[layer2] DB health FATAL (deneme %d/3): %s')
                :format(attempt, err))
        end
        Wait(5000)
    end

    -- 3) KATMAN 4: latent_print_weight sutunu saglik kontrolu
    for attempt = 1, 3 do
        local qcol = ('SELECT latent_print_weight FROM %s LIMIT 1')
                     :format(Config.DbTableName)
        local rowscol, errcol = SafeExecuteSync(qcol, {})

        if rowscol then
            ColumnHealth.latent_print_ok = true
            print('[layer2][KATMAN4] latent_print_weight sutunu OK.')
            break
        end

        ColumnHealth.latent_print_ok = false
        if errcol then
            print(('[layer2][KATMAN4] UYARI: latent_print_weight sutunu bulunamadi '
                .. '(deneme %d/3). sql/katman4_migration.sql dosyasini calistirin.')
                :format(attempt))
        end
        Wait(3000)
    end

    -- 4) KATMAN 4: sigint_afis_cold_cases tablosu saglik kontrolu
    for attempt = 1, 3 do
        local qafis = ('SELECT case_id FROM %s LIMIT 1'):format(Config.DbAfisTableName)
        local rowsafis, errafis = SafeExecuteSync(qafis, {})

        if rowsafis then
            AfisHealth.table_ok = true
            print('[layer2][KATMAN4] sigint_afis_cold_cases tablosu OK.')
            break
        end

        AfisHealth.table_ok = false
        if errafis then
            print(('[layer2][KATMAN4] UYARI: sigint_afis_cold_cases tablosu bulunamadi '
                .. '(deneme %d/3). sql/katman4_migration.sql dosyasini calistirin.')
                :format(attempt))
        end
        Wait(3000)
    end
end)

-- ============================================================
-- STALE ENTITY CLEANUP
-- ============================================================
CreateThread(function()
    while true do
        Wait(60 * 1000)

        local now = os.time()
        for src, categories in pairs(SpawnedEntities) do
            local stillConnected = GetPlayerName(src) ~= nil
            for cat, record in pairs(categories) do
                if not stillConnected
                   or (now - (record.lastUpdate or 0)) > Config.StaleEntityCleanupSeconds then
                    categories[cat] = nil
                end
            end
            if next(categories) == nil then
                SpawnedEntities[src] = nil
            end
        end

        for src in pairs(RateLimits) do
            if GetPlayerName(src) == nil then RateLimits[src] = nil end
        end
        for src in pairs(ShotSpotterCooldown) do
            if GetPlayerName(src) == nil then ShotSpotterCooldown[src] = nil end
        end
    end
end)

-- ============================================================
-- DEMO MODU (opsiyonel — BootstrapState cakismasi yok)
-- ============================================================
CreateThread(function()
    if not Config.DemoMode then return end
    Wait(4000)

    EnsureAccount('agent_ux91', function()
        SendAgentMessageInternal('agent_ux91',
            'Konum guvenli, mal hazir. Onay bekliyorum.', Config.DefaultChannel)
    end)

    Wait(3000)
    EnsureAccount('agent_kl04', function()
        CreateDeadDropInternal('agent_kl04',
            vector3(215.4, -810.2, 30.7), Config.DefaultChannel,
            'Zula konumu ekte. Cabuk davranin, bolgede hareketlilik var.')
    end)
end)
