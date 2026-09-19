-- ================================================================
-- KATMAN 4 :: Kriminalistik ve Gizli Parmak Izleri -- DB Migration
-- fivem_cybercomm_layer2 uzerine calisir. MariaDB / oxmysql.
--
-- Bu dosyayi HeidiSQL (veya sunucunuzun DB yonetim araci) ile bir kez
-- calistirin, ardindan kaynagi (resource) yeniden baslatin. server.lua
-- startup'ta her iki yapiyi da probe eder; migration calistirilmadan
-- once resource CRASH OLMAZ, latent print / AFIS yazimlari sadece
-- sessizce atlanir ve konsola uyari basilir.
-- ================================================================

ALTER TABLE `sigint_cellular_matrix`
    ADD COLUMN IF NOT EXISTS `latent_print_weight` DECIMAL(5,2) NULL DEFAULT NULL
        COMMENT 'KATMAN4: son olculen adli parmak izi kalite katsayisi (0-100)';

CREATE TABLE IF NOT EXISTS `sigint_afis_cold_cases` (
    `case_id`              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `fingerprint_id`       VARCHAR(32)  NOT NULL,
    `suspect_identifier`   VARCHAR(96)  NOT NULL,
    `dead_drop_message_id` VARCHAR(128) NOT NULL,
    `latent_print_weight`  DECIMAL(5,2) NOT NULL,
    `temperature_c`        DECIMAL(5,2) NOT NULL,
    `humidity_pct`         TINYINT UNSIGNED NOT NULL,
    `pos_x`                DECIMAL(10,4) NOT NULL,
    `pos_y`                DECIMAL(10,4) NOT NULL,
    `pos_z`                DECIMAL(10,4) NOT NULL,
    `matched`              TINYINT(1)   NOT NULL DEFAULT 0
        COMMENT '0 = faili mechul (cozulmemis), 1 = AFIS eslesmesi yapildi',
    `logged_at`            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`case_id`),
    KEY `idx_fingerprint` (`fingerprint_id`),
    KEY `idx_suspect` (`suspect_identifier`),
    KEY `idx_matched` (`matched`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='KATMAN4: cozulmemis AFIS parmak izi vaka kuyrugu (siber/narkotik polis)';
