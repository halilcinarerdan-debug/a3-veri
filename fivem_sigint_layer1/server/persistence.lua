-- =====================================================================
-- TOPLU SQL YAZIM KATMANI
--
-- RAM önbelleğindeki "dirty" ajanlar, 10 dakikada bir tek seferde çok
-- satırlı (bulk) INSERT ... ON DUPLICATE KEY UPDATE sorgularıyla
-- veritabanına yazılır. Kritik adli olaylarda (yakalanma/ölüm/ihanet)
-- tek bir ajan için anında (immediate) flush tetiklenir.
-- Sürücü: oxmysql (yalnızca DB erişimi için, gameplay framework değildir).
-- =====================================================================

Persistence = {}

local function buildBulkUpsert(tableName, columns, updateColumns, rows)
    if #rows == 0 then return nil, nil end

    local placeholderRow = '(' .. string.rep('?,', #columns):sub(1, -2) .. ')'
    local placeholders = {}
    local params = {}

    for _, row in ipairs(rows) do
        placeholders[#placeholders + 1] = placeholderRow
        for _, v in ipairs(row) do
            params[#params + 1] = v
        end
    end

    local updateList = {}
    for _, c in ipairs(updateColumns) do
        updateList[#updateList + 1] = ('%s = VALUES(%s)'):format(c, c)
    end

    local sql = ('INSERT INTO %s (%s) VALUES %s ON DUPLICATE KEY UPDATE %s'):format(
        tableName,
        table.concat(columns, ', '),
        table.concat(placeholders, ', '),
        table.concat(updateList, ', ')
    )

    return sql, params
end

local function execBulk(tableName, columns, updateColumns, rows)
    local sql, params = buildBulkUpsert(tableName, columns, updateColumns, rows)
    if not sql then return end
    exports.oxmysql:execute(sql, params)
end

-- Verilen ajan listesi (identifier -> agent) için 5 tabloya toplu yazım yapar.
local function flushAgents(agents)
    local sigintRows, forensicRows, neuroRows, econRows, interroRows = {}, {}, {}, {}, {}

    for identifier, a in pairs(agents) do
        local s = a.sigint
        if s.imei and s.last_coords then
            local topTower = s.active_towers[1]
            sigintRows[#sigintRows + 1] = {
                identifier, s.imei, s.imsi,
                topTower and topTower.tower.id or 0,
                topTower and math.floor(topTower.rssi + 0.5) or -130,
                topTower and topTower.snr or 0.0,
                json.encode({ x = s.last_coords.x, y = s.last_coords.y, z = s.last_coords.z }),
                s.is_transmitting and 1 or 0,
                s.triangulation_confidence * 100.0,
                s.search_radius_m,
            }
        end

        local f = a.forensic
        if f.fingerprint_id then
            forensicRows[#forensicRows + 1] = {
                identifier, f.fingerprint_id, f.dna_profile, f.item_id,
                f.humidity_pct, f.temp_c, f.fingerprint_integrity, f.dna_integrity,
            }
        end

        local n = a.neuro
        local activeCompound, activeSub = nil, nil
        for compoundId, sub in pairs(n.substances) do
            if not activeSub or sub.last_update_ms > activeSub.last_update_ms then
                activeCompound, activeSub = compoundId, sub
            end
        end
        neuroRows[#neuroRows + 1] = {
            identifier, n.cortisol_baseline, n.cortisol_level, n.dopamine_suppression, n.sleep_debt,
            activeCompound, activeSub and activeSub.saturation or 0.0,
            activeCompound and CONFIG.SUBSTANCE_PROFILES[activeCompound].half_life_min or nil,
        }

        local e = a.economic
        econRows[#econRows + 1] = { identifier, e.debt_index, e.risk_appetite }

        local i = a.interrogation
        interroRows[#interroRows + 1] = {
            identifier, i.method, i.cognitive_load, i.counsel_present and 1 or 0, i.confession_probability,
        }
    end

    execBulk('sigint_cellular_matrix',
        { 'citizen_identifier', 'imei', 'imsi', 'cell_tower_id', 'rssi_dbm', 'snr_db',
          'last_ping_coords', 'encrypted_channel', 'triangulation_risk', 'search_radius_m' },
        { 'cell_tower_id', 'rssi_dbm', 'snr_db', 'last_ping_coords', 'encrypted_channel',
          'triangulation_risk', 'search_radius_m' },
        sigintRows)

    execBulk('forensic_contamination_index',
        { 'citizen_identifier', 'fingerprint_id', 'dna_profile', 'item_id',
          'relative_humidity_pct', 'temperature_c', 'fingerprint_integrity', 'dna_integrity' },
        { 'fingerprint_integrity', 'dna_integrity' },
        forensicRows)

    execBulk('neurochemical_state',
        { 'citizen_identifier', 'cortisol_baseline', 'cortisol_level', 'dopamine_suppression',
          'sleep_debt_index', 'active_substance_id', 'substance_saturation', 'substance_half_life_min' },
        { 'cortisol_baseline', 'cortisol_level', 'dopamine_suppression', 'sleep_debt_index',
          'active_substance_id', 'substance_saturation', 'substance_half_life_min' },
        neuroRows)

    execBulk('agent_economic_profile',
        { 'citizen_identifier', 'debt_index', 'risk_appetite' },
        { 'debt_index', 'risk_appetite' },
        econRows)

    execBulk('interrogation_cognitive_load',
        { 'citizen_identifier', 'method', 'cognitive_load', 'counsel_present', 'confession_probability' },
        { 'method', 'cognitive_load', 'counsel_present', 'confession_probability' },
        interroRows)
end

-- 10 dakikalık periyodik toplu flush
function Persistence.FlushAll()
    local dirty = {}
    local any = false
    for identifier, a in pairs(Cache.Agents) do
        if a.dirty then
            dirty[identifier] = a
            any = true
        end
    end
    if not any then return end

    flushAgents(dirty)

    for identifier in pairs(dirty) do
        Cache.Agents[identifier].dirty = false
    end
end

-- Kritik adli olay (yakalanma / ölüm / ihanet): tek ajan anında yazılır
function Persistence.FlushOne(identifier, reason)
    local a = Cache.Get(identifier)
    if not a then return end

    flushAgents({ [identifier] = a })
    a.dirty = false

    TriggerEvent('sigint_layer1:criticalFlush', identifier, reason)
end
