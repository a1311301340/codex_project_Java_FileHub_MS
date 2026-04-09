package com.filehub.backend.module.system;

import com.filehub.backend.common.ApiResponse;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/system-config")
public class SystemConfigController {

    private final SystemConfigService systemConfigService;

    public SystemConfigController(SystemConfigService systemConfigService) {
        this.systemConfigService = systemConfigService;
    }

    @GetMapping
    public ApiResponse<SystemConfig> getConfig() {
        return ApiResponse.ok(systemConfigService.getCurrentConfig());
    }

    @PutMapping
    public ApiResponse<SystemConfig> updateConfig(@Valid @RequestBody UpdateSystemConfigRequest request) {
        return ApiResponse.ok(systemConfigService.update(request));
    }
}
