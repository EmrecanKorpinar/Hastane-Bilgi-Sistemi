package com.hbs.common.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.Map;

/**
 * Standard error response structure for all APIs
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ErrorResponse {

    private String errorCode;
    private String message;
    private String path;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timezone = "UTC")
    private Instant timestamp;

    private String traceId;
    private Map<String, Object> details;

    public static ErrorResponse of(String errorCode, String message, String path, String traceId) {
        return ErrorResponse.builder()
                .errorCode(errorCode)
                .message(message)
                .path(path)
                .traceId(traceId)
                .timestamp(Instant.now())
                .build();
    }
}

