-- ============================================================================
-- VBS-Virtual World Engine (A3) — KATMAN 1: Fiziksel Varlık
-- Tablo: vbs_civilians
-- Motor: MySQL / MariaDB (InnoDB, utf8mb4 — Türkçe karakter desteği için)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `vbs_civilians` (
    `id`                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `national_id`         VARCHAR(20)  NOT NULL,
    `name`                VARCHAR(64)  NOT NULL,
    `clan_id`             INT UNSIGNED NOT NULL DEFAULT 0,
    `home_pos`            VARCHAR(64)  NOT NULL,
    `work_pos`            VARCHAR(64)  NOT NULL,
    `current_pos`         VARCHAR(64)  NOT NULL,
    `vehicle_id`          INT UNSIGNED NOT NULL DEFAULT 0,
    `ace_medical_status`  TEXT         NOT NULL,
    `inventory`           TEXT         NOT NULL,
    `status`              TINYINT      NOT NULL DEFAULT 1,
    `created_at`          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_vbs_civilians_national_id` (`national_id`),
    KEY `idx_vbs_civilians_clan_id` (`clan_id`),
    KEY `idx_vbs_civilians_status` (`status`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = 'KATMAN 1 - Sanal sivil nufus (fiziksel varlik yok, sadece veri)';
