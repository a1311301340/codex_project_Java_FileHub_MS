package com.filehub.backend.module.filemeta;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ManagedFileRepository extends JpaRepository<ManagedFile, Long> {

    Page<ManagedFile> findByDeletedFalseAndFileNameContainingIgnoreCase(String keyword, Pageable pageable);
}
