package com.hbs.patient.dto;

import com.hbs.patient.domain.Patient;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PatientResponse {

    private String patientId;
    private String nationalId;
    private String fileNumber;
    private String name;
    private String surname;
    private String fullName;
    private LocalDate birthDate;
    private Patient.Gender gender;
    private String phone;
    private String email;
    private String address;
    private String city;
    private String country;
    private String bloodType;
    private String emergencyContact;
    private String emergencyPhone;
    private Boolean active;
    private Instant createdAt;
    private Instant updatedAt;
}

