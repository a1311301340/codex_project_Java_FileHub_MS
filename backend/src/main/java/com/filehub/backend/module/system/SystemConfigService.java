package com.filehub.backend.module.system;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class SystemConfigService {

    private final SystemConfigRepository repository;

    public SystemConfigService(SystemConfigRepository repository) {
        this.repository = repository;
    }

    @Transactional(readOnly = true)
    public SystemConfig getCurrentConfig() {
        return repository.findById(1L).orElseGet(this::buildDefaultConfig);
    }

    @Transactional
    public SystemConfig update(UpdateSystemConfigRequest request) {
        SystemConfig config = repository.findById(1L).orElseGet(() -> {
            SystemConfig created = new SystemConfig();
            created.setId(1L);
            return created;
        });
        config.setStorageRoot(request.storageRoot());
        config.setRedisEnabled(request.redisEnabled());
        config.setUpdatedAt(LocalDateTime.now());
        return repository.save(config);
    }

    private SystemConfig buildDefaultConfig() {
        SystemConfig config = new SystemConfig();
        config.setId(1L);
        config.setStorageRoot("./runtime/data");
        config.setRedisEnabled(false);
        config.setUpdatedAt(LocalDateTime.now());
        return config;
    }
}
