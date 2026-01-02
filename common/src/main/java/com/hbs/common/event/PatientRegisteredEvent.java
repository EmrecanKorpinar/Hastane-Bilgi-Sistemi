package com.hbs.common.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * Event published when a new patient is registered in the system
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(callSuper = true)
public class PatientRegisteredEvent extends BaseEvent {

    private PatientPayload payload;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class PatientPayload {
        private String patientId;
        private String nationalId;
        private String fileNumber;
        private String name;
        private String surname;
        private String birthDate;
        private String gender;
        private String phone;
        private String email;
        private String createdBy;
    }

    public static PatientRegisteredEvent create(PatientPayload payload, String traceId, String triggeredBy) {
        PatientRegisteredEvent event = new PatientRegisteredEvent();
        event.setEventType("patient.registered");
        event.setPayload(payload);
        event.setTraceId(traceId);
        event.setTriggeredBy(triggeredBy);
        event.initializeDefaults();
        return event;
    }
}

