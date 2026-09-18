-- =====================================================================
-- KATMAN 1: SIGINT, ENDÜSTRİYEL KİMYASAL BİYOMETRİ & KRİMİNALİSTİK
-- Standalone (framework-bağımsız) FiveM veri şeması
-- Engine: MySQL 8+ / MariaDB 10.5+
--
-- Not: citizen_identifier her tabloda ortak anahtardır ancak bilinçli
-- olarak hiçbir framework'ün (ESX/QBCore/vRP) users/players tablosuna
-- FOREIGN KEY ile bağlanmaz; sunucu FiveM lisans kimliğini (veya
-- entegre edilen karakter sistemi ne kullanıyorsa onu) buraya yazar.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) SIGINT / Hücresel Sinyal Matrisi
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `sigint_cellular_matrix` (
    `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_identifier`  VARCHAR(64)  NOT NULL COMMENT 'Ajan/NPC benzersiz kimliği',
    `imei`                CHAR(15)     NOT NULL COMMENT 'Luhn algoritmasına uygun 15 haneli IMEI',
    `imsi`                CHAR(15)     NOT NULL COMMENT '15 haneli IMSI',
    `cell_tower_id`       SMALLINT UNSIGNED NOT NULL COMMENT 'En güçlü sinyali alan baz istasyonu',
    `rssi_dbm`            SMALLINT     NOT NULL COMMENT 'Sinyal gücü (dBm), tipik -120..-30',
    `snr_db`              DECIMAL(6,2) NOT NULL COMMENT 'Sinyal-gürültü oranı (dB)',
    `last_ping_coords`    JSON         NOT NULL COMMENT '{"x":..,"y":..,"z":..} sunucu tarafı ölçüm',
    `encrypted_channel`   TINYINT(1)   NOT NULL DEFAULT 0 COMMENT 'Tor/Signal benzeri şifreli hat kullanımı',
    `triangulation_risk`  DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT 'Üçgenleme güveni yüzdesi (0-100)',
    `search_radius_m`     DECIMAL(8,2) NOT NULL DEFAULT 2200.00 COMMENT 'Daralan arama çemberi yarıçapı (metre)',
    `updated_at`          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_agent_device` (`citizen_identifier`, `imei`),
    KEY `idx_imsi` (`imsi`),
    KEY `idx_tower` (`cell_tower_id`),
    KEY `idx_risk` (`triangulation_risk`),
    CONSTRAINT `chk_rssi_range` CHECK (`rssi_dbm` BETWEEN -130 AND -20),
    CONSTRAINT `chk_snr_range` CHECK (`snr_db` BETWEEN -40 AND 50),
    CONSTRAINT `chk_tri_risk_range` CHECK (`triangulation_risk` BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hücresel cihaz sinyal izleme ve üçgenleme kaydı';

-- ---------------------------------------------------------------------
-- 2) Kriminalistik Kontaminasyon Endeksi
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `forensic_contamination_index` (
    `id`                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `citizen_identifier`    VARCHAR(64)  NOT NULL,
    `fingerprint_id`        VARCHAR(64)  NOT NULL COMMENT 'Gizli parmak izi kaydı benzersiz kodu',
    `dna_profile`           VARCHAR(64)  NOT NULL COMMENT 'Epitel doku / DNA profili kodu',
    `item_id`               VARCHAR(64)  DEFAULT NULL COMMENT 'Temas edilen eşya/paket referansı',
    `relative_humidity_pct` DECIMAL(5,2) NOT NULL COMMENT 'Temas anı bağıl nem (%RH)',
    `temperature_c`         DECIMAL(5,2) NOT NULL COMMENT 'Temas anı sıcaklık (°C)',
    `fingerprint_integrity` DECIMAL(5,2) NOT NULL DEFAULT 100.00 COMMENT 'Parmak izi bütünlüğü (0-100)',
    `dna_integrity`         DECIMAL(5,2) NOT NULL DEFAULT 100.00 COMMENT 'DNA örneği bütünlüğü (0-100)',
    `contact_at`            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_agent` (`citizen_identifier`),
    KEY `idx_fingerprint` (`fingerprint_id`),
    KEY `idx_dna` (`dna_profile`),
    CONSTRAINT `chk_humidity_range` CHECK (`relative_humidity_pct` BETWEEN 0 AND 100),
    CONSTRAINT `chk_temp_range` CHECK (`temperature_c` BETWEEN -30 AND 60),
    CONSTRAINT `chk_print_integrity` CHECK (`fingerprint_integrity` BETWEEN 0 AND 100),
    CONSTRAINT `chk_dna_integrity` CHECK (`dna_integrity` BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Ortam koşullarına bağlı iz/DNA bütünlük bozunumu';

-- ---------------------------------------------------------------------
-- 3) Nörokimyasal Durum
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `neurochemical_state` (
    `citizen_identifier`      VARCHAR(64)  NOT NULL,
    `cortisol_baseline`       DECIMAL(5,2) NOT NULL DEFAULT 15.00 COMMENT 'Kişisel bazal kortizol (ug/dL), normal 5-25',
    `cortisol_level`          DECIMAL(5,2) NOT NULL DEFAULT 15.00 COMMENT 'Anlık kortizol (ug/dL); 50+ kriz eşiği',
    `dopamine_suppression`    DECIMAL(4,3) NOT NULL DEFAULT 0.000 COMMENT 'Reseptör baskılanma katsayısı (0-1)',
    `sleep_debt_index`        DECIMAL(5,2) NOT NULL DEFAULT 0.00 COMMENT 'Uyku yoksunluğu / psikoz katsayısı (0-100)',
    `active_substance_id`     VARCHAR(32)  DEFAULT NULL COMMENT 'Son maruz kalınan sentetik bileşik kodu',
    `substance_saturation`    DECIMAL(4,3) NOT NULL DEFAULT 0.000 COMMENT 'Kimyasal doygunluk oranı (0-1)',
    `substance_half_life_min` SMALLINT UNSIGNED DEFAULT NULL COMMENT 'Bileşiğin biyolojik yarılanma ömrü (dk)',
    `updated_at`              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizen_identifier`),
    KEY `idx_cortisol` (`cortisol_level`),
    CONSTRAINT `chk_cortisol_baseline` CHECK (`cortisol_baseline` BETWEEN 0 AND 90),
    CONSTRAINT `chk_cortisol_level` CHECK (`cortisol_level` BETWEEN 0 AND 90),
    CONSTRAINT `chk_dopamine_range` CHECK (`dopamine_suppression` BETWEEN 0 AND 1),
    CONSTRAINT `chk_sleep_debt_range` CHECK (`sleep_debt_index` BETWEEN 0 AND 100),
    CONSTRAINT `chk_saturation_range` CHECK (`substance_saturation` BETWEEN 0 AND 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Kortizol, dopamin baskılanması ve yoksunluk simülasyonu';

-- ---------------------------------------------------------------------
-- 4) Ajan Ekonomik Profili
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `agent_economic_profile` (
    `citizen_identifier` VARCHAR(64)   NOT NULL,
    `debt_index`         DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Net finansal borç yükü ($)',
    `risk_appetite`      DECIMAL(4,3)  NOT NULL DEFAULT 0.000 COMMENT 'Rasyonel risk iştahı katsayısı (0-1)',
    `updated_at`         DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizen_identifier`),
    KEY `idx_debt` (`debt_index`),
    CONSTRAINT `chk_debt_nonneg` CHECK (`debt_index` >= 0),
    CONSTRAINT `chk_risk_range` CHECK (`risk_appetite` BETWEEN 0 AND 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Borç yükü tabanlı risk iştahı profili';

-- ---------------------------------------------------------------------
-- 5) Sorgu Bilişsel Yükü
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `interrogation_cognitive_load` (
    `citizen_identifier`     VARCHAR(64)  NOT NULL,
    `method`                 ENUM('PEACE','REID') DEFAULT NULL COMMENT 'Uygulanan sorgu protokolü',
    `cognitive_load`         DECIMAL(5,2) NOT NULL DEFAULT 10.00 COMMENT 'Bilişsel yük (0-100)',
    `counsel_present`        TINYINT(1)   NOT NULL DEFAULT 0 COMMENT 'Avukat eşliği var mı',
    `confession_probability` DECIMAL(4,3) NOT NULL DEFAULT 0.000 COMMENT 'İtirafçılık olasılığı (0-1)',
    `session_started_at`     DATETIME     DEFAULT NULL,
    `updated_at`             DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`citizen_identifier`),
    CONSTRAINT `chk_cog_load_range` CHECK (`cognitive_load` BETWEEN 0 AND 100),
    CONSTRAINT `chk_confession_range` CHECK (`confession_probability` BETWEEN 0 AND 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='PEACE/Reid protokolüne karşı bilişsel direnç durumu';
