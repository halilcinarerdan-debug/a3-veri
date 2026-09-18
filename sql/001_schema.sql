-- =============================================================================
-- VBS COIN SIMULATION ENGINE - VERI ZEMINI (RELATIONAL SCHEMA)
-- Hedef motor: MySQL 8.x / MariaDB 10.4+  |  Erisim katmani: Arma 3 extDB3
-- Tasarim ilkesi: Surrogate INT/BIGINT PK'lar + dar indeksler -> extDB3
-- asenkron cagrilarinda (SQL_CUSTOM prepared statement) sorgu suresi
-- mikrosaniye seviyesinde kalir, headless client tick'lerini bloklamaz.
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- 1) vbs_world_state
-- Eden'de elle etiketlenmis binalar + savas artiklari (krater/enkaz) tek
-- tabloda "feature_type" ile ayristirilir; boylece "kritik bina bombalandi"
-- ve "burada krater var" sorgulari ayni index'i (map_name, ...) paylasir.
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_world_state (
    world_state_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    map_name             VARCHAR(64)     NOT NULL,
    feature_type         ENUM('BUILDING','CRATER','INFRASTRUCTURE_NODE') NOT NULL DEFAULT 'BUILDING',
    object_id            BIGINT          NULL,              -- Eden/engine object ID (getObjectID), krater icin NULL olabilir
    building_tag         ENUM('IBADETHANE','IS_YERI','ALTYAPI_ENERJI','ALTYAPI_SU','SIVIL_KONUT','TICARI','ASKERI','DIGER') NULL,
    pos_x                FLOAT           NOT NULL,
    pos_y                FLOAT           NOT NULL,
    pos_z                FLOAT           NOT NULL DEFAULT 0,
    max_health           SMALLINT UNSIGNED NOT NULL DEFAULT 100,
    current_health        SMALLINT        NOT NULL DEFAULT 100,   -- 0-100, clamp uygulama katmaninda
    is_destroyed          TINYINT(1)      NOT NULL DEFAULT 0,
    destruction_cause      ENUM('WEST_KINETIC','OPFOR_IED','ARTILLERY','UNKNOWN') NULL,
    blast_radius_m        FLOAT           NULL,               -- krater/patlama yaricapi
    last_event_ts         DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

    UNIQUE KEY uq_world_map_object (map_name, object_id),
    KEY idx_world_map_tag (map_name, building_tag),
    KEY idx_world_map_destroyed (map_name, is_destroyed)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 2) vbs_social_network
-- Klan/kabile agirlik merkezi. vbs_civilians ve vbs_commander_cache buraya
-- FK ile baglanir; boylece "X kabilesi dusman oldu" tek UPDATE ile tum
-- alt birimlere yansir (cache invalidation'a gerek yok).
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_social_network (
    clan_id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    map_name                VARCHAR(64)     NOT NULL,
    clan_name               VARCHAR(96)     NOT NULL,
    total_population          INT UNSIGNED    NOT NULL DEFAULT 0,
    global_west_trust         SMALLINT        NOT NULL DEFAULT 50,   -- 0-100
    global_opfor_support       SMALLINT        NOT NULL DEFAULT 20,   -- 0-100
    last_updated_ts          DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

    UNIQUE KEY uq_social_map_clan (map_name, clan_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 3) vbs_civilians
-- Fiziksel nitelikler. work_state_id FK'si sayesinde "bu sivil kendi is
-- yerine IED koyamaz" kurali uygulama tarafinda basit bir esitlik kontrolune
-- (candidate_object_id = civilian.work_state_id) indirgenir.
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_civilians (
    civilian_id             BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    map_name                 VARCHAR(64)     NOT NULL,
    national_id              VARCHAR(32)     NOT NULL,
    full_name                VARCHAR(96)     NOT NULL,
    clan_id                  INT UNSIGNED    NULL,
    home_pos_x               FLOAT           NOT NULL DEFAULT 0,
    home_pos_y               FLOAT           NOT NULL DEFAULT 0,
    home_pos_z               FLOAT           NOT NULL DEFAULT 0,
    work_pos_x               FLOAT           NULL,
    work_pos_y               FLOAT           NULL,
    work_pos_z               FLOAT           NULL,
    work_state_id             BIGINT UNSIGNED NULL,               -- FK -> vbs_world_state (is yeri binasi)
    current_pos_x             FLOAT           NOT NULL DEFAULT 0,
    current_pos_y             FLOAT           NOT NULL DEFAULT 0,
    current_pos_z             FLOAT           NOT NULL DEFAULT 0,
    current_vehicle_id         BIGINT          NULL,               -- Arma object ID, aractaysa
    status                    ENUM('CIVILIAN','RADICALIZED_OPFOR','DEAD','FLED','DETAINED') NOT NULL DEFAULT 'CIVILIAN',
    last_position_ts          DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

    UNIQUE KEY uq_civ_map_national (map_name, national_id),
    KEY idx_civ_status (map_name, status),
    KEY idx_civ_clan (clan_id),
    CONSTRAINT fk_civ_clan FOREIGN KEY (clan_id) REFERENCES vbs_social_network (clan_id) ON DELETE SET NULL,
    CONSTRAINT fk_civ_work_state FOREIGN KEY (work_state_id) REFERENCES vbs_world_state (world_state_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 4) vbs_civilian_cognition
-- PK = FK (civilian_id) -> 1:1 iliski, ek index gerekmez, extDB3 tek
-- "SELECT ... WHERE civilian_id = ?" ile O(1) satir eristirir.
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_civilian_cognition (
    civilian_id               BIGINT UNSIGNED PRIMARY KEY,
    personality               ENUM('PASSIVE','AGGRESSIVE_SYMPATHIZER','NEUTRAL_OPPORTUNIST','FEARFUL','INFORMANT') NOT NULL DEFAULT 'NEUTRAL_OPPORTUNIST',
    west_trust                 SMALLINT        NOT NULL DEFAULT 50,
    opfor_support               SMALLINT        NOT NULL DEFAULT 20,
    current_emotion             ENUM('CALM','FEARFUL','ANGRY','GRIEVING','HOPEFUL') NOT NULL DEFAULT 'CALM',
    radicalization_threshold     SMALLINT        NOT NULL DEFAULT 80,   -- opfor_support bu esigi gecince OPFOR'a donusum tetiklenir
    last_cognition_ts           DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

    CONSTRAINT fk_cog_civilian FOREIGN KEY (civilian_id) REFERENCES vbs_civilians (civilian_id) ON DELETE CASCADE,
    CONSTRAINT chk_cog_trust CHECK (west_trust BETWEEN 0 AND 100),
    CONSTRAINT chk_cog_support CHECK (opfor_support BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 5) vbs_civilian_memory
-- Append-only taktiksel hafiza log'u (AAR icin tam gecmis korunur).
-- "Bu sivil bu askeri taniyor mu" sorgusu icin en kritik erisim yolu
-- composite index ile karsilanir: ORDER BY interaction_ts DESC LIMIT 1.
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_civilian_memory (
    memory_id                 BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    civilian_id               BIGINT UNSIGNED NOT NULL,
    entity_type                ENUM('PLAYER','AI_BOT') NOT NULL,
    entity_identifier           VARCHAR(64)     NOT NULL,             -- getPlayerUID ya da vbs_bot_id
    last_interaction_type        ENUM('ACE_INTERACTION_FRIENDLY','ACE_INTERACTION_AGGRESSIVE','SEARCH','DETAIN','SHOOT_NEAR','KILL_FAMILY','PROPERTY_DAMAGE') NOT NULL,
    anger_impact                SMALLINT        NOT NULL DEFAULT 0,    -- west_trust/opfor_support'a uygulanacak delta (isaretli)
    interaction_pos_x            FLOAT           NOT NULL,
    interaction_pos_y            FLOAT           NOT NULL,
    interaction_pos_z            FLOAT           NOT NULL,
    interaction_ts              DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    has_reported_to_opfor         TINYINT(1)      NOT NULL DEFAULT 0,

    KEY idx_mem_civ_entity_time (civilian_id, entity_identifier, interaction_ts DESC),
    KEY idx_mem_unreported (has_reported_to_opfor),
    CONSTRAINT fk_mem_civilian FOREIGN KEY (civilian_id) REFERENCES vbs_civilians (civilian_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 6) vbs_commander_cache
-- "Sanal ordu": editorde yerlestirilen dusman gruplari fiziksel AI olarak
-- degil, satir olarak yasar. Komutan FSM'i bu tabloyu tick'te tarar,
-- oyuncu yaklastiginda is_spawned_physical = 1 yapip haritada dogurur.
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_commander_cache (
    group_id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    map_name                   VARCHAR(64)     NOT NULL,
    side                       ENUM('OPFOR') NOT NULL DEFAULT 'OPFOR',
    strength                   TINYINT UNSIGNED NOT NULL DEFAULT 0,     -- sanal birim sayisi
    composition_json             JSON            NULL,                    -- ornek: {"riflemen":4,"mg":1,"rpg":1}
    current_task                ENUM('AMBUSH_PREP','PATROL','IED_EMPLACEMENT','RETREATING','RESUPPLY','HOLDING') NOT NULL DEFAULT 'HOLDING',
    virtual_pos_x               FLOAT           NOT NULL,
    virtual_pos_y               FLOAT           NOT NULL,
    virtual_pos_z               FLOAT           NOT NULL,
    target_pos_x                FLOAT           NULL,                    -- pusu/waypoint hedefi (asenkron yuruyus icin)
    target_pos_y                FLOAT           NULL,
    target_pos_z                FLOAT           NULL,
    is_spawned_physical          TINYINT(1)      NOT NULL DEFAULT 0,
    linked_clan_id               INT UNSIGNED    NULL,                    -- hangi kabile/hucreye bagli
    last_tick_ts                DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),

    KEY idx_cmd_map_side_spawned (map_name, side, is_spawned_physical),
    KEY idx_cmd_map_task (map_name, current_task),
    CONSTRAINT fk_cmd_clan FOREIGN KEY (linked_clan_id) REFERENCES vbs_social_network (clan_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------------------------
-- 7) vbs_analytics
-- AAR/etki raporu icin merkezi olay defteri. Diger tum tablolara nullable
-- FK ile bagli olmasi, tek bir sorgu ile "kim/nerede/hangi kabile" zincirini
-- cikarmaya izin verir.
-- -----------------------------------------------------------------------------
CREATE TABLE vbs_analytics (
    event_id                   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    map_name                   VARCHAR(64)     NOT NULL,
    event_type                  ENUM('CIVILIAN_KILLED','BUILDING_DESTROYED','IED_DETONATION','RADICALIZATION','WEST_CASUALTY','OPFOR_CASUALTY','AMBUSH_TRIGGERED','TRUST_SHIFT') NOT NULL,
    event_ts                    DATETIME(3)     NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    grid_reference               VARCHAR(12)     NOT NULL,               -- Arma grid string (mapGridPosition), okunabilirlik icin
    pos_x                       FLOAT           NOT NULL,
    pos_y                       FLOAT           NOT NULL,
    related_civilian_id           BIGINT UNSIGNED NULL,
    related_clan_id              INT UNSIGNED    NULL,
    related_world_state_id         BIGINT UNSIGNED NULL,
    short_summary                VARCHAR(255)    NOT NULL,
    impact_metrics_text           JSON            NOT NULL,               -- yapisal ama "text" gibi tasinabilir: {"economy_delta":-12,"support_delta":8}

    KEY idx_ana_map_type_time (map_name, event_type, event_ts),
    CONSTRAINT fk_ana_civilian FOREIGN KEY (related_civilian_id) REFERENCES vbs_civilians (civilian_id) ON DELETE SET NULL,
    CONSTRAINT fk_ana_clan FOREIGN KEY (related_clan_id) REFERENCES vbs_social_network (clan_id) ON DELETE SET NULL,
    CONSTRAINT fk_ana_world_state FOREIGN KEY (related_world_state_id) REFERENCES vbs_world_state (world_state_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
