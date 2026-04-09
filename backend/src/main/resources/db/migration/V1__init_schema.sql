CREATE TABLE IF NOT EXISTS user_account (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS system_config (
    id BIGINT PRIMARY KEY,
    storage_root VARCHAR(1024) NOT NULL,
    redis_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO system_config (id, storage_root, redis_enabled, updated_at)
VALUES (1, './runtime/data', FALSE, NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

CREATE TABLE IF NOT EXISTS category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(128) NOT NULL,
    parent_id BIGINT NULL
);

CREATE TABLE IF NOT EXISTS managed_file (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    file_name VARCHAR(512) NOT NULL,
    file_path VARCHAR(2048) NOT NULL,
    file_size BIGINT NOT NULL,
    file_type VARCHAR(128) NULL,
    category_id BIGINT NULL,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_managed_file_name (file_name),
    INDEX idx_managed_file_category (category_id)
);

CREATE TABLE IF NOT EXISTS tag (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64) NOT NULL,
    color VARCHAR(32) NULL,
    UNIQUE KEY uk_tag_name (name)
);

CREATE TABLE IF NOT EXISTS file_tag_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    file_id BIGINT NOT NULL,
    tag_id BIGINT NOT NULL,
    UNIQUE KEY uk_file_tag (file_id, tag_id),
    INDEX idx_file_tag_file (file_id),
    INDEX idx_file_tag_tag (tag_id)
);

CREATE TABLE IF NOT EXISTS operation_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    operator_name VARCHAR(128) NOT NULL,
    operation_type VARCHAR(64) NOT NULL,
    operation_target VARCHAR(512) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_operation_log_created_at (created_at)
);
