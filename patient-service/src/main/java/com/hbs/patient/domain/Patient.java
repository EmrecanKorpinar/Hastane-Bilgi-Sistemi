package com.hbs.patient.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;
import java.time.LocalDate;
import java.util.UUID;

/**
 * Patient aggregate root (DDD)
 * Represents a patient in the hospital system
 */
@Entity
@Table(name = "patients", indexes = {
    @Index(name = "idx_national_id", columnList = "national_id", unique = true),
    @Index(name = "idx_file_number", columnList = "file_number", unique = true),
    @Index(name = "idx_phone", columnList = "phone")
})
@EntityListeners(AuditingEntityListener.class)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Patient {

    @Id
    @Column(name = "patient_id", updatable = false, nullable = false)
    private String patientId;

    @Column(name = "national_id", unique = true, nullable = false, length = 11)
    private String nationalId;

    @Column(name = "file_number", unique = true, nullable = false, length = 20)
    private String fileNumber;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "surname", nullable = false, length = 100)
    private String surname;

    @Column(name = "birth_date", nullable = false)
    private LocalDate birthDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", nullable = false, length = 10)
    private Gender gender;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "email", length = 100)
    private String email;

    @Column(name = "address", length = 500)
    private String address;

    @Column(name = "city", length = 50)
    private String city;

    @Column(name = "country", length = 50)
    private String country;

    @Column(name = "blood_type", length = 5)
    private String bloodType;

    @Column(name = "emergency_contact", length = 100)
    private String emergencyContact;

    @Column(name = "emergency_phone", length = 20)
    private String emergencyPhone;

    @Column(name = "active", nullable = false)
    @Builder.Default
    private Boolean active = true;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "created_by", length = 100)
    private String createdBy;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @Version
    @Column(name = "version")
    private Long version;

    @PrePersist
    public void prePersist() {
        if (this.patientId == null) {
            this.patientId = UUID.randomUUID().toString();
        }
        if (this.active == null) {
            this.active = true;
        }
    }

    public enum Gender {
        MALE, FEMALE, OTHER
    }

    public String getFullName() {
        return name + " " + surname;
    }
}

