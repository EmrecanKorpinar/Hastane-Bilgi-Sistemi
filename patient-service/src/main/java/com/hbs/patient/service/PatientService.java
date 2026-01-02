package com.hbs.patient.service;

import com.hbs.common.event.PatientRegisteredEvent;
import com.hbs.common.exception.BusinessException;
import com.hbs.common.util.TraceContextUtil;
import com.hbs.patient.domain.Patient;
import com.hbs.patient.dto.CreatePatientRequest;
import com.hbs.patient.dto.PatientResponse;
import com.hbs.patient.event.PatientEventPublisher;
import com.hbs.patient.repository.PatientRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Year;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PatientService {

    private final PatientRepository patientRepository;
    private final PatientEventPublisher eventPublisher;
    private final AtomicInteger fileNumberCounter = new AtomicInteger(1);

    @Transactional
    @CacheEvict(value = "patients", allEntries = true)
    public PatientResponse createPatient(CreatePatientRequest request, String createdBy) {
        log.info("Creating patient with national ID: {}", request.getNationalId());

        // Check if patient already exists
        if (patientRepository.existsByNationalId(request.getNationalId())) {
            throw new BusinessException(
                "Patient with this national ID already exists",
                "PATIENT_ALREADY_EXISTS",
                HttpStatus.CONFLICT
            );
        }

        // Generate file number
        String fileNumber = generateFileNumber();

        // Create patient entity
        Patient patient = Patient.builder()
                .nationalId(request.getNationalId())
                .fileNumber(fileNumber)
                .name(request.getName())
                .surname(request.getSurname())
                .birthDate(request.getBirthDate())
                .gender(request.getGender())
                .phone(request.getPhone())
                .email(request.getEmail())
                .address(request.getAddress())
                .city(request.getCity())
                .country(request.getCountry())
                .bloodType(request.getBloodType())
                .emergencyContact(request.getEmergencyContact())
                .emergencyPhone(request.getEmergencyPhone())
                .createdBy(createdBy)
                .build();

        patient = patientRepository.save(patient);
        log.info("Patient created with ID: {}, File Number: {}", patient.getPatientId(), patient.getFileNumber());

        // Publish event
        publishPatientRegisteredEvent(patient, createdBy);

        return mapToResponse(patient);
    }

    @Transactional(readOnly = true)
    @Cacheable(value = "patients", key = "#patientId")
    public PatientResponse getPatientById(String patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new BusinessException(
                    "Patient not found",
                    "PATIENT_NOT_FOUND",
                    HttpStatus.NOT_FOUND
                ));
        return mapToResponse(patient);
    }

    @Transactional(readOnly = true)
    public PatientResponse getPatientByNationalId(String nationalId) {
        Patient patient = patientRepository.findByNationalId(nationalId)
                .orElseThrow(() -> new BusinessException(
                    "Patient not found with national ID: " + nationalId,
                    "PATIENT_NOT_FOUND",
                    HttpStatus.NOT_FOUND
                ));
        return mapToResponse(patient);
    }

    @Transactional(readOnly = true)
    public PatientResponse getPatientByFileNumber(String fileNumber) {
        Patient patient = patientRepository.findByFileNumber(fileNumber)
                .orElseThrow(() -> new BusinessException(
                    "Patient not found with file number: " + fileNumber,
                    "PATIENT_NOT_FOUND",
                    HttpStatus.NOT_FOUND
                ));
        return mapToResponse(patient);
    }

    @Transactional(readOnly = true)
    public List<PatientResponse> searchPatients(String query) {
        List<Patient> patients = patientRepository
                .findByNameContainingIgnoreCaseOrSurnameContainingIgnoreCase(query, query);
        return patients.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PatientResponse> getAllActivePatients() {
        List<Patient> patients = patientRepository.findAllActive();
        return patients.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Generate file number: HBS-YYYY-NNNNNN
     */
    private String generateFileNumber() {
        int year = Year.now().getValue();
        int sequence = fileNumberCounter.getAndIncrement();
        return String.format("HBS-%d-%06d", year, sequence);
    }

    private void publishPatientRegisteredEvent(Patient patient, String triggeredBy) {
        String traceId = TraceContextUtil.getCurrentTraceId();

        PatientRegisteredEvent.PatientPayload payload = PatientRegisteredEvent.PatientPayload.builder()
                .patientId(patient.getPatientId())
                .nationalId(patient.getNationalId())
                .fileNumber(patient.getFileNumber())
                .name(patient.getName())
                .surname(patient.getSurname())
                .birthDate(patient.getBirthDate().toString())
                .gender(patient.getGender().name())
                .phone(patient.getPhone())
                .email(patient.getEmail())
                .createdBy(patient.getCreatedBy())
                .build();

        PatientRegisteredEvent event = PatientRegisteredEvent.create(payload, traceId, triggeredBy);
        eventPublisher.publish(event);
    }

    private PatientResponse mapToResponse(Patient patient) {
        return PatientResponse.builder()
                .patientId(patient.getPatientId())
                .nationalId(patient.getNationalId())
                .fileNumber(patient.getFileNumber())
                .name(patient.getName())
                .surname(patient.getSurname())
                .fullName(patient.getFullName())
                .birthDate(patient.getBirthDate())
                .gender(patient.getGender())
                .phone(patient.getPhone())
                .email(patient.getEmail())
                .address(patient.getAddress())
                .city(patient.getCity())
                .country(patient.getCountry())
                .bloodType(patient.getBloodType())
                .emergencyContact(patient.getEmergencyContact())
                .emergencyPhone(patient.getEmergencyPhone())
                .active(patient.getActive())
                .createdAt(patient.getCreatedAt())
                .updatedAt(patient.getUpdatedAt())
                .build();
    }
}

