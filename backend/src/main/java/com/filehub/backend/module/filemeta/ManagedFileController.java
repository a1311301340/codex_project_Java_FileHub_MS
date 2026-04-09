package com.filehub.backend.module.filemeta;

import com.filehub.backend.common.ApiResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/files")
public class ManagedFileController {

    private final ManagedFileRepository repository;

    public ManagedFileController(ManagedFileRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public ApiResponse<Page<FileQueryResponse>> queryFiles(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        int normalizedSize = Math.min(Math.max(size, 1), 100);
        Page<FileQueryResponse> result = repository
                .findByDeletedFalseAndFileNameContainingIgnoreCase(keyword, PageRequest.of(Math.max(page, 0), normalizedSize))
                .map(FileQueryResponse::fromEntity);
        return ApiResponse.ok(result);
    }
}
