package com.filehub.backend.module.filemeta;

import java.time.LocalDateTime;

public record FileQueryResponse(
        Long id,
        String fileName,
        String filePath,
        Long fileSize,
        String fileType,
        Long categoryId,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
    static FileQueryResponse fromEntity(ManagedFile entity) {
        return new FileQueryResponse(
                entity.getId(),
                entity.getFileName(),
                entity.getFilePath(),
                entity.getFileSize(),
                entity.getFileType(),
                entity.getCategoryId(),
                entity.getCreatedAt(),
                entity.getUpdatedAt()
        );
    }
}
