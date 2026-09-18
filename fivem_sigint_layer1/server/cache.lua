-- =====================================================================
-- RAM ÖNBELLEK KATMANI
-- Tüm biyometrik/kimyasal/sinyal verisi burada işlenir; SQL'e yazım
-- yalnızca persistence.lua tarafından periyodik/kritik anlarda yapılır.
-- =====================================================================

Cache = {}
Cache.Agents = {}

function Cache.Ensure(identifier)
    local a = Cache.Agents[identifier]
    if a then return a end

    local baseline = math.random(
        CONFIG.NEUROCHEMICAL.CORTISOL_BASELINE_MIN * 10,
        CONFIG.NEUROCHEMICAL.CORTISOL_BASELINE_MAX * 10
    ) / 10.0

    a = {
        identifier = identifier,
        sigint = {
            imei = nil,
            imsi = nil,
            is_transmitting = false,
            last_packet_ms = 0,
            triangulation_confidence = 0.0,
            search_radius_m = CONFIG.TRIANGULATION.SEARCH_RADIUS_MAX_M,
            last_coords = nil,
            active_towers = {},
        },
        forensic = {
            fingerprint_id = nil,
            dna_profile = nil,
            item_id = nil,
            humidity_pct = nil,
            temp_c = nil,
            fingerprint_integrity = 100.0,
            dna_integrity = 100.0,
            print_decay_rate = 0.0,
            dna_decay_rate = 0.0,
            last_contact_ms = 0,
            has_active_trace = false,
        },
        neuro = {
            cortisol_baseline = baseline,
            cortisol_level = baseline,
            dopamine_suppression = 0.0,
            sleep_debt = 0.0,
            substances = {}, -- [compoundId] = { saturation = 0..1, last_update_ms = int }
        },
        economic = {
            debt_index = 0.0,
            risk_appetite = 0.0,
        },
        interrogation = {
            active = false,
            method = nil,
            counsel_present = false,
            cognitive_load = CONFIG.INTERROGATION.LOAD_BASE,
            confession_probability = 0.0,
            session_started_ms = 0,
        },
        dirty = true,
    }

    Cache.Agents[identifier] = a
    return a
end

function Cache.Get(identifier)
    return Cache.Agents[identifier]
end

function Cache.MarkDirty(identifier)
    local a = Cache.Agents[identifier]
    if a then a.dirty = true end
end

function Cache.Purge(identifier)
    Cache.Agents[identifier] = nil
end
