package com.filehub.backend.module.system;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UpdateSystemConfigRequest(
        @NotBlank String storageRoot,
        @NotNull Boolean redisEnabled
) {
}
