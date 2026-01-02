package com.hbs.patient.event;

import com.hbs.common.event.PatientRegisteredEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class PatientEventPublisher {

    private static final String PATIENT_REGISTERED_TOPIC = "patient.registered";

    private final KafkaTemplate<String, String> kafkaTemplate;
    private final ObjectMapper objectMapper;

    public void publish(PatientRegisteredEvent event) {
        try {
            String eventJson = objectMapper.writeValueAsString(event);
            kafkaTemplate.send(PATIENT_REGISTERED_TOPIC, event.getPayload().getPatientId(), eventJson);
            log.info("Published patient.registered event for patient: {}, traceId: {}",
                    event.getPayload().getPatientId(), event.getTraceId());
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize patient.registered event", e);
            throw new RuntimeException("Failed to publish event", e);
        }
    }
}

