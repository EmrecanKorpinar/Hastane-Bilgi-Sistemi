package com.hbs.patient.controller;

import com.hbs.common.dto.ErrorResponse;
import com.hbs.common.util.TraceContextUtil;
import com.hbs.patient.dto.CreatePatientRequest;
import com.hbs.patient.dto.PatientResponse;
import com.hbs.patient.service.PatientService;
import io.micrometer.core.annotation.Timed;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/patient")
@RequiredArgsConstructor
@Slf4j
public class PatientController {

    private final PatientService patientService;

    @PostMapping
    @Timed(value = "patient.create", description = "Time taken to create a patient")
    public ResponseEntity<PatientResponse> createPatient(
            @Valid @RequestBody CreatePatientRequest request,
            Authentication authentication) {

        String username = authentication != null ? authentication.getName() : "system";
        String traceId = TraceContextUtil.getCurrentTraceId();

        log.info("Creating patient - traceId: {}, user: {}", traceId, username);
        PatientResponse response = patientService.createPatient(request, username);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{patientId}")
    @Timed(value = "patient.get", description = "Time taken to get a patient")
    public ResponseEntity<PatientResponse> getPatient(@PathVariable String patientId) {
        log.info("Fetching patient: {}", patientId);
        PatientResponse response = patientService.getPatientById(patientId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/national-id/{nationalId}")
    public ResponseEntity<PatientResponse> getPatientByNationalId(@PathVariable String nationalId) {
        log.info("Fetching patient by national ID: {}", nationalId);
        PatientResponse response = patientService.getPatientByNationalId(nationalId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/file-number/{fileNumber}")
    public ResponseEntity<PatientResponse> getPatientByFileNumber(@PathVariable String fileNumber) {
        log.info("Fetching patient by file number: {}", fileNumber);
        PatientResponse response = patientService.getPatientByFileNumber(fileNumber);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/search")
    public ResponseEntity<List<PatientResponse>> searchPatients(@RequestParam String query) {
        log.info("Searching patients with query: {}", query);
        List<PatientResponse> responses = patientService.searchPatients(query);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/active")
    public ResponseEntity<List<PatientResponse>> getActivePatients() {
        log.info("Fetching all active patients");
        List<PatientResponse> responses = patientService.getAllActivePatients();
        return ResponseEntity.ok(responses);
    }
}

