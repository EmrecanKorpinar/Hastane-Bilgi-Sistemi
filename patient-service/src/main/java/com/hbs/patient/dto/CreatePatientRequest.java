package com.hbs.patient.dto;

import com.hbs.patient.domain.Patient;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreatePatientRequest {

    @NotBlank(message = "National ID is required")
    @Size(min = 11, max = 11, message = "National ID must be 11 characters")
    @Pattern(regexp = "\\d{11}", message = "National ID must contain only digits")
    private String nationalId;

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    private String name;

    @NotBlank(message = "Surname is required")
    @Size(min = 2, max = 100, message = "Surname must be between 2 and 100 characters")
    private String surname;

    @NotNull(message = "Birth date is required")
    @Past(message = "Birth date must be in the past")
    private LocalDate birthDate;

    @NotNull(message = "Gender is required")
    private Patient.Gender gender;

    @Pattern(regexp = "^[+]?[(]?[0-9]{3}[)]?[-\\s.]?[0-9]{3}[-\\s.]?[0-9]{4,6}$", message = "Invalid phone format")
    private String phone;

    @Email(message = "Invalid email format")
    private String email;

    private String address;
    private String city;
    private String country;
    private String bloodType;
    private String emergencyContact;
    private String emergencyPhone;
}

