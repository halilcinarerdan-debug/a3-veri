-- ============================================================================
-- VBS-COIN Engine — Relational Schema (MySQL 8.0+ / MariaDB 10.3+)
-- Server-side PBO addon backing store, consumed exclusively via extDB3
-- (SQL_CUSTOM_V2 prepared statements). No client-side writes; HC/server only.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS vbs_coin
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE vbs_coin;

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. vbs_world_state
-- Per-map, per-object persistent world state (buildings, craters, safehouses).
-- No FK dependencies — created first.
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_world_state (
    state_id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    world_name      VARCHAR(64)     NOT NULL,
    object_id       BIGINT UNSIGNED NOT NULL,
    building_health FLOAT           NOT NULL DEFAULT 1.0,
    crater_pos_x    FLOAT           NULL,
    crater_pos_y    FLOAT           NULL,
    crater_pos_z    FLOAT           NULL,
    is_destroyed    TINYINT(1)      NOT NULL DEFAULT 0,
    is_safehouse    INT             NOT NULL DEFAULT 0,
    last_update     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                     ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (state_id),
    UNIQUE KEY uq_world_object (world_name, object_id),
    KEY idx_world_safehouse (world_name, is_safehouse),
    CONSTRAINT chk_building_health CHECK (building_health BETWEEN 0 AND 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 2. vbs_social_network
-- Clan/tribe aggregate. Created before vbs_civilians because civilians FK
-- into it.
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_social_network (
    clan_id           INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    clan_name         VARCHAR(64)     NOT NULL,
    total_population  INT UNSIGNED    NOT NULL DEFAULT 0,
    global_west_trust DECIMAL(5,2)    NOT NULL DEFAULT 50.00,
    created_at        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (clan_id),
    UNIQUE KEY uq_clan_name (clan_name),
    CONSTRAINT chk_global_trust CHECK (global_west_trust BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 3. vbs_civilians
-- Physical civilian identity/position. clan_id nullable: an unaffiliated
-- civilian keeps existing if its clan row is ever removed (ON DELETE SET NULL).
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_civilians (
    civilian_id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    national_id     VARCHAR(32)     NOT NULL,
    full_name       VARCHAR(64)     NOT NULL,
    clan_id         INT UNSIGNED    NULL,
    home_pos_x      FLOAT           NULL,
    home_pos_y      FLOAT           NULL,
    home_pos_z      FLOAT           NULL,
    work_pos_x      FLOAT           NULL,
    work_pos_y      FLOAT           NULL,
    work_pos_z      FLOAT           NULL,
    current_pos_x   FLOAT           NULL,
    current_pos_y   FLOAT           NULL,
    current_pos_z   FLOAT           NULL,
    vehicle_id      BIGINT UNSIGNED NULL,
    is_journalist   INT             NOT NULL DEFAULT 0,
    status          ENUM('ALIVE','DEAD','DETAINED','MISSING') NOT NULL DEFAULT 'ALIVE',
    last_update     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                     ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (civilian_id),
    UNIQUE KEY uq_national_id (national_id),
    KEY idx_clan (clan_id),
    KEY idx_status (status),
    CONSTRAINT fk_civ_clan FOREIGN KEY (clan_id)
        REFERENCES vbs_social_network (clan_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 4. vbs_civilian_cognition
-- 1:1 with vbs_civilians — civilian_id is both PK and FK. Deletes cascade
-- because a cognition row is meaningless without its civilian.
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_civilian_cognition (
    civilian_id     BIGINT UNSIGNED NOT NULL,
    personality     ENUM('PASSIVE','NEUTRAL','INFORMANT','SYMPATHIZER','EXTREMIST')
                                     NOT NULL DEFAULT 'NEUTRAL',
    west_trust      SMALLINT        NOT NULL DEFAULT 50,
    opfor_support   SMALLINT        NOT NULL DEFAULT 10,
    current_emotion ENUM('CALM','FEAR','ANGER','PANIC','GRIEF') NOT NULL DEFAULT 'CALM',
    riot_tendency   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    last_update     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                     ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (civilian_id),
    KEY idx_riot_scan (riot_tendency, west_trust),
    CONSTRAINT fk_cog_civilian FOREIGN KEY (civilian_id)
        REFERENCES vbs_civilians (civilian_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_west_trust CHECK (west_trust BETWEEN 0 AND 100),
    CONSTRAINT chk_opfor_support CHECK (opfor_support BETWEEN 0 AND 100),
    CONSTRAINT chk_riot_tendency CHECK (riot_tendency BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 5. vbs_civilian_memory
-- Append-only interaction log. soldier_uid holds getPlayerUID() for real
-- players or the vbs_commander_cache.editor_id/virtual id for AI so both
-- WEST players and cached OPFOR/WEST AI can be recognized identically.
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_civilian_memory (
    memory_id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    civilian_id           BIGINT UNSIGNED NOT NULL,
    soldier_uid            VARCHAR(32)     NOT NULL,
    last_interaction_type  VARCHAR(32)     NOT NULL,
    anger_impact           SMALLINT        NOT NULL DEFAULT 0,
    interaction_timestamp  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (memory_id),
    KEY idx_recognition (civilian_id, soldier_uid, interaction_timestamp),
    CONSTRAINT fk_mem_civilian FOREIGN KEY (civilian_id)
        REFERENCES vbs_civilians (civilian_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 6. vbs_commander_cache
-- Virtual (unspawned) OPFOR/WEST group state. editor_id is the Eden-placed
-- group's variable name, so a manually authored group maps 1:1 to its cache
-- row and can be looked up without scanning positions.
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_commander_cache (
    group_id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    editor_id       VARCHAR(64)     NOT NULL,
    side            ENUM('OPFOR','WEST','INDEPENDENT','CIVILIAN') NOT NULL DEFAULT 'OPFOR',
    strength        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    current_task    VARCHAR(32)     NOT NULL DEFAULT 'HOLD',
    virtual_pos_x   FLOAT           NULL,
    virtual_pos_y   FLOAT           NULL,
    virtual_pos_z   FLOAT           NULL,
    is_spawned      TINYINT(1)      NOT NULL DEFAULT 0,
    last_update     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                     ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id),
    UNIQUE KEY uq_editor_id (editor_id),
    KEY idx_side_task (side, current_task, is_spawned)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- 7. vbs_analytics
-- AAR event log. related_* columns are nullable FKs so an event can be
-- filtered by clan/civilian/group without denormalizing text fields, but an
-- event with no known actor (e.g. a generic riot tick) still inserts cleanly.
-- ----------------------------------------------------------------------------
CREATE TABLE vbs_analytics (
    event_id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    event_type                  VARCHAR(32)     NOT NULL,
    event_timestamp             TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    grid_pos                    VARCHAR(16)     NULL,
    short_summary                VARCHAR(255)    NULL,
    impact_metrics_text          JSON            NULL,
    civilian_casualties_by_riot  SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    media_exposure               INT             NOT NULL DEFAULT 0,
    related_civilian_id          BIGINT UNSIGNED NULL,
    related_clan_id              INT UNSIGNED    NULL,
    related_group_id             BIGINT UNSIGNED NULL,
    PRIMARY KEY (event_id),
    KEY idx_type_time (event_type, event_timestamp),
    CONSTRAINT fk_evt_civilian FOREIGN KEY (related_civilian_id)
        REFERENCES vbs_civilians (civilian_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_evt_clan FOREIGN KEY (related_clan_id)
        REFERENCES vbs_social_network (clan_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_evt_group FOREIGN KEY (related_group_id)
        REFERENCES vbs_commander_cache (group_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
