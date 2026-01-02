package com.hbs.common.event;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.UUID;

/**
 * Base class for all domain events in the system.
 * Provides common fields: eventId, eventType, occurredAt, traceId
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public abstract class BaseEvent {

    /**
     * Unique identifier for this event instance
     */
    private String eventId;

    /**
     * Type of event (e.g., "patient.registered", "appointment.created")
     */
    private String eventType;

    /**
     * Timestamp when the event occurred
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timezone = "UTC")
    private Instant occurredAt;

    /**
     * Correlation/trace ID for distributed tracing
     */
    private String traceId;

    /**
     * User/system that triggered this event
     */
    private String triggeredBy;

    /**
     * Initialize default values
     */
    public void initializeDefaults() {
        if (this.eventId == null) {
            this.eventId = UUID.randomUUID().toString();
        }
        if (this.occurredAt == null) {
            this.occurredAt = Instant.now();
        }
        if (this.traceId == null) {
            this.traceId = UUID.randomUUID().toString();
        }
    }
}

