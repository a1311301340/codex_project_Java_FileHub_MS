package com.filehub.backend.module.log;

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
@Table(name = "operation_log")
public class OperationLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "operator_name", nullable = false, length = 128)
    private String operatorName;

    @Column(name = "operation_type", nullable = false, length = 64)
    private String operationType;

    @Column(name = "operation_target", nullable = false, length = 512)
    private String operationTarget;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}
