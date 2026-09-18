-- =============================================================================
-- VBS COIN SIMULATION ENGINE - VERI TABANI SEMASI (v1)
-- Hedef motor : MariaDB 10.5+ / MySQL 8.0+  (InnoDB, CHECK constraint, generated
--               column ve SPATIAL INDEX destegi gereklidir)
-- Erisim yolu : Arma 3 sunucusu -> extDB3 (SQL_CUSTOM_V2, parametreli/prepared
--               statement sablonlari) -> bu semaya asenkron cagri
-- Karakter seti: utf8mb4 (klan/kisi isimlerinde Turkce/Arapca karakterler icin)
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `vbs_coin`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE `vbs_coin`;

-- -----------------------------------------------------------------------------
-- 5. vbs_social_network  (once olusturulmali: vbs_civilians ve vbs_commander_cache
--    bu tabloya FK ile bagli)
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_social_network` (
    `clan_id`           SMALLINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    `clan_name`         VARCHAR(64)        NOT NULL,
    `region_tag`        VARCHAR(32)        NULL COMMENT 'Eden marker/bolge etiketi (ör. "Zargabad_Kuzey")',
    `total_population`  SMALLINT UNSIGNED  NOT NULL DEFAULT 0 COMMENT 'vbs_civilians uzerinden trigger ile senkron tutulur',
    `global_west_trust` DECIMAL(5,2)       NOT NULL DEFAULT 50.00,
    `radicalization_index` DECIMAL(5,2)    NOT NULL DEFAULT 0.00 COMMENT 'klan genelindeki OPFOR sempati ortalamasi',
    `updated_at`        DATETIME(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`clan_id`),
    UNIQUE KEY `uq_clan_name` (`clan_name`),
    CONSTRAINT `chk_social_trust_range`
        CHECK (`global_west_trust` BETWEEN 0.00 AND 100.00),
    CONSTRAINT `chk_social_radical_range`
        CHECK (`radicalization_index` BETWEEN 0.00 AND 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Klan/kabile duzeyinde toplu sosyal metrikler';

-- -----------------------------------------------------------------------------
-- 6. vbs_commander_cache  (vbs_social_network'e bagli, ama once tanimlanir ki
--    vbs_civilians.joined_opfor_group_id ona referans verebilsin)
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_commander_cache` (
    `group_id`          MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `side`              ENUM('OPFOR','INDEPENDENT') NOT NULL DEFAULT 'OPFOR',
    `strength`          TINYINT UNSIGNED   NOT NULL DEFAULT 4 COMMENT 'sanal AI sayisi (fiziksel spawn edilene kadar)',
    `equipment_tier`    ENUM('IMPROVISED','LIGHT','RHS_MILITIA','HEAVY') NOT NULL DEFAULT 'LIGHT',
    `current_task`      ENUM('IDLE','PATROL','AMBUSH','RALLY','RETREAT','ATTACK') NOT NULL DEFAULT 'IDLE',
    `virtual_pos_x`     FLOAT              NOT NULL,
    `virtual_pos_y`     FLOAT              NOT NULL,
    `virtual_pos_z`     FLOAT              NOT NULL DEFAULT 0,
    -- Sadece dahili radius sorgulari icin: SQF tarafina asla dogrudan SELECT edilmez
    `virtual_pos_geom`  POINT GENERATED ALWAYS AS
                             (ST_SRID(POINT(`virtual_pos_x`, `virtual_pos_y`), 0)) STORED NOT NULL,
    `target_pos_x`      FLOAT              NULL,
    `target_pos_y`      FLOAT              NULL,
    `target_pos_z`      FLOAT              NULL,
    `is_spawned_physically` TINYINT(1)     NOT NULL DEFAULT 0,
    `linked_clan_id`    SMALLINT UNSIGNED  NULL COMMENT 'hangi yerel klandan turedigi (radikallesme kaynagi)',
    `last_tick_at`      DATETIME(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`group_id`),
    SPATIAL INDEX `sidx_commander_pos` (`virtual_pos_geom`),
    INDEX `idx_commander_side_task` (`side`, `current_task`),
    CONSTRAINT `fk_commander_clan`
        FOREIGN KEY (`linked_clan_id`) REFERENCES `vbs_social_network` (`clan_id`)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `chk_commander_strength`
        CHECK (`strength` BETWEEN 1 AND 20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='ALIVE/NR6 yerine: haritada asenkron yurutulen sanal OPFOR savas gruplari (cache)';

-- -----------------------------------------------------------------------------
-- 2. vbs_civilians
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_civilians` (
    `civilian_id`       INT UNSIGNED       NOT NULL AUTO_INCREMENT,
    `national_id`       VARCHAR(20)        NOT NULL COMMENT 'kimlik numarasi, basta sifir olabilir -> VARCHAR',
    `full_name`         VARCHAR(96)        NOT NULL,
    `clan_id`           SMALLINT UNSIGNED  NULL,
    `home_pos_x`        FLOAT              NOT NULL,
    `home_pos_y`        FLOAT              NOT NULL,
    `home_pos_z`        FLOAT              NOT NULL DEFAULT 0,
    `work_pos_x`        FLOAT              NULL,
    `work_pos_y`        FLOAT              NULL,
    `work_pos_z`        FLOAT              NULL,
    `current_pos_x`     FLOAT              NOT NULL,
    `current_pos_y`     FLOAT              NOT NULL,
    `current_pos_z`     FLOAT              NOT NULL DEFAULT 0,
    -- Kalabalik/riot kumelenmesi icin dahili radius sorgusu (bkz. asagidaki notlar)
    `current_pos_geom`  POINT GENERATED ALWAYS AS
                             (ST_SRID(POINT(`current_pos_x`, `current_pos_y`), 0)) STORED NOT NULL,
    `assigned_vehicle_netid` VARCHAR(16)   NULL COMMENT 'Arma netId string (ör. "123:45")',
    `life_status`       ENUM('ALIVE','DEAD','DETAINED','RADICALIZED') NOT NULL DEFAULT 'ALIVE',
    `joined_opfor_group_id` MEDIUMINT UNSIGNED NULL COMMENT 'RADICALIZED oldugunda katildigi hucre',
    `last_seen_at`      DATETIME(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`civilian_id`),
    UNIQUE KEY `uq_civilian_national_id` (`national_id`),
    SPATIAL INDEX `sidx_civilian_pos` (`current_pos_geom`),
    INDEX `idx_civilian_clan` (`clan_id`),
    INDEX `idx_civilian_status` (`life_status`),
    CONSTRAINT `fk_civilian_clan`
        FOREIGN KEY (`clan_id`) REFERENCES `vbs_social_network` (`clan_id`)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `fk_civilian_opfor_group`
        FOREIGN KEY (`joined_opfor_group_id`) REFERENCES `vbs_commander_cache` (`group_id`)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dinamik sivil nufusun fiziksel/idari nitelikleri';

-- -----------------------------------------------------------------------------
-- 3. vbs_civilian_cognition  (1:1 -> vbs_civilians)
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_civilian_cognition` (
    `civilian_id`       INT UNSIGNED       NOT NULL,
    `personality`       ENUM('PASSIVE','NEUTRAL','OPPORTUNIST','AGGRESSIVE','LOYALIST') NOT NULL DEFAULT 'NEUTRAL',
    `west_trust`        TINYINT UNSIGNED   NOT NULL DEFAULT 50,
    `opfor_support`     TINYINT UNSIGNED   NOT NULL DEFAULT 0,
    `current_emotion`   ENUM('CALM','FEAR','ANGER','PANIC','HOPE') NOT NULL DEFAULT 'CALM',
    `riot_tendency`     DECIMAL(5,2)       NOT NULL DEFAULT 0.00,
    `updated_at`        DATETIME(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`civilian_id`),
    INDEX `idx_cognition_riot` (`riot_tendency`),
    CONSTRAINT `fk_cognition_civilian`
        FOREIGN KEY (`civilian_id`) REFERENCES `vbs_civilians` (`civilian_id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `chk_cognition_trust`
        CHECK (`west_trust` BETWEEN 0 AND 100),
    CONSTRAINT `chk_cognition_support`
        CHECK (`opfor_support` BETWEEN 0 AND 100),
    CONSTRAINT `chk_cognition_riot`
        CHECK (`riot_tendency` BETWEEN 0.00 AND 100.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Sivilin bilissel/duygusal durumu - WEST_Trust ve OPFOR_Support burada';

-- -----------------------------------------------------------------------------
-- 4. vbs_civilian_memory  (N:1 -> vbs_civilians) : taktiksel hafiza
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_civilian_memory` (
    `memory_id`         BIGINT UNSIGNED    NOT NULL AUTO_INCREMENT,
    `civilian_id`       INT UNSIGNED       NOT NULL,
    `actor_uid`         VARCHAR(32)        NULL COMMENT 'getPlayerUID (oyuncu ise)',
    `actor_bot_id`      MEDIUMINT UNSIGNED NULL COMMENT 'vbs_commander_cache.group_id (bot/hucre ise)',
    `interaction_type`  ENUM('SEARCHED','QUESTIONED','ARRESTED','HELPED',
                              'MEDICAL_AID','WITNESSED_KILLING','WITNESSED_AIRSTRIKE') NOT NULL,
    `anger_impact`      SMALLINT           NOT NULL DEFAULT 0 COMMENT '-100..100, west_trust/opfor_support delta kaynagi',
    `interaction_pos_x` FLOAT              NULL,
    `interaction_pos_y` FLOAT              NULL,
    `interaction_pos_z` FLOAT              NULL,
    `occurred_at`       DATETIME(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`memory_id`),
    INDEX `idx_memory_civilian_actor` (`civilian_id`, `actor_uid`),
    INDEX `idx_memory_civilian_time` (`civilian_id`, `occurred_at`),
    CONSTRAINT `fk_memory_civilian`
        FOREIGN KEY (`civilian_id`) REFERENCES `vbs_civilians` (`civilian_id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `chk_memory_anger_range`
        CHECK (`anger_impact` BETWEEN -100 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Sivilin hangi asker/botu, ne sekilde hatirladigi';

-- -----------------------------------------------------------------------------
-- 1. vbs_world_state
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_world_state` (
    `state_id`          INT UNSIGNED       NOT NULL AUTO_INCREMENT,
    `map_name`          VARCHAR(48)        NOT NULL,
    `object_tag`        VARCHAR(64)        NOT NULL COMMENT 'Eden Attributes -> Variable Name (benzersiz)',
    `building_type`     ENUM('RELIGIOUS','ECONOMIC','INFRASTRUCTURE','RESIDENTIAL','MILITARY') NOT NULL,
    `health_percentage` TINYINT UNSIGNED   NOT NULL DEFAULT 100,
    `is_destroyed`      TINYINT(1)         NOT NULL DEFAULT 0,
    `destroyed_at`      DATETIME(3)        NULL,
    `crater_pos_x`      FLOAT              NULL,
    `crater_pos_y`      FLOAT              NULL,
    `crater_pos_z`      FLOAT              NULL,
    `last_hit_by_uid`   VARCHAR(32)        NULL,
    PRIMARY KEY (`state_id`),
    UNIQUE KEY `uq_world_map_object` (`map_name`, `object_tag`),
    INDEX `idx_world_destroyed` (`map_name`, `is_destroyed`),
    CONSTRAINT `chk_world_health`
        CHECK (`health_percentage` BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Eden ile elle etiketlenmis kritik binalarin server persistency durumu';

-- -----------------------------------------------------------------------------
-- 7. vbs_analytics  (AAR)
-- -----------------------------------------------------------------------------
CREATE TABLE `vbs_analytics` (
    `event_id`          BIGINT UNSIGNED    NOT NULL AUTO_INCREMENT,
    `event_type`        ENUM('AIRSTRIKE','RIOT_FORMED','RIOT_DISPERSED','RIOT_TO_AMBUSH',
                              'IED_DETONATION','CIVILIAN_CASUALTY','BUILDING_DESTROYED',
                              'RADICALIZATION','INTEL_LEAK') NOT NULL,
    `occurred_at`       DATETIME(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `grid_pos_x`        FLOAT              NULL,
    `grid_pos_y`        FLOAT              NULL,
    `grid_pos_z`        FLOAT              NULL,
    `related_clan_id`   SMALLINT UNSIGNED  NULL,
    `short_summary`     VARCHAR(255)       NOT NULL,
    `impact_metrics`    JSON               NULL COMMENT 'ör. {"trust_delta": -12, "economy_delta": -5}',
    `civilian_casualties_by_riot` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`event_id`),
    INDEX `idx_analytics_type_time` (`event_type`, `occurred_at`),
    INDEX `idx_analytics_clan` (`related_clan_id`),
    CONSTRAINT `fk_analytics_clan`
        FOREIGN KEY (`related_clan_id`) REFERENCES `vbs_social_network` (`clan_id`)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='AAR / stratejik etki gunlugu';

SET FOREIGN_KEY_CHECKS = 1;
