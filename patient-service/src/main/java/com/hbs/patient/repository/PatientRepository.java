package com.hbs.patient.repository;

import com.hbs.patient.domain.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PatientRepository extends JpaRepository<Patient, String> {

    Optional<Patient> findByNationalId(String nationalId);

    Optional<Patient> findByFileNumber(String fileNumber);

    List<Patient> findByNameContainingIgnoreCaseOrSurnameContainingIgnoreCase(String name, String surname);

    @Query("SELECT p FROM Patient p WHERE p.phone = :phone")
    List<Patient> findByPhone(String phone);

    @Query("SELECT p FROM Patient p WHERE p.active = true")
    List<Patient> findAllActive();

    boolean existsByNationalId(String nationalId);
}

