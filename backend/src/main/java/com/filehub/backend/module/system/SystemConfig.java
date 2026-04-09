package com.filehub.backend.module.system;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "system_config")
public class SystemConfig {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "storage_root", nullable = false, length = 1024)
    private String storageRoot;

    @Column(name = "redis_enabled", nullable = false)
    private Boolean redisEnabled;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
}
