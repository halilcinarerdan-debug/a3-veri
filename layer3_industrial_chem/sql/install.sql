CREATE TABLE IF NOT EXISTS `layer3_equipment` (
    `reactor_id` VARCHAR(64) NOT NULL,
    `wear_ratio` DECIMAL(4,3) NOT NULL DEFAULT 0.000,
    `last_updated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`reactor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `layer3_synthesis_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `reactor_id` VARCHAR(64) NOT NULL,
    `citizenid` VARCHAR(64) DEFAULT NULL,
    `purity_index` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `yield_mg` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `outcome` ENUM('success','contaminated','explosion') NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_reactor` (`reactor_id`),
    KEY `idx_citizen` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `layer3_contamination_zones` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `interior_id` VARCHAR(64) NOT NULL,
    `pos_x` FLOAT NOT NULL,
    `pos_y` FLOAT NOT NULL,
    `pos_z` FLOAT NOT NULL,
    `radius` FLOAT NOT NULL DEFAULT 18.0,
    `ppm_peak` DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    `forensic_reported_at` DATETIME DEFAULT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_interior` (`interior_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
