package com.hbs.patient.config;
}
    }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);

        );
                traceId
                request.getRequestURI(),
                "An unexpected error occurred",
                "INTERNAL_SERVER_ERROR",
        ErrorResponse error = ErrorResponse.of(

        log.error("Unhandled exception - traceId: {}", traceId, ex);
        String traceId = TraceContextUtil.getCurrentTraceId();

            Exception ex, HttpServletRequest request) {
    public ResponseEntity<ErrorResponse> handleGenericException(
    @ExceptionHandler(Exception.class)

    }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);

        error.setDetails(Map.of("validationErrors", errors));
        );
                traceId
                request.getRequestURI(),
                "Validation failed",
                "VALIDATION_ERROR",
        ErrorResponse error = ErrorResponse.of(

        log.warn("Validation error - traceId: {}, errors: {}", traceId, errors);

        });
            errors.put(fieldName, errorMessage);
            String errorMessage = error.getDefaultMessage();
            String fieldName = ((FieldError) error).getField();
        ex.getBindingResult().getAllErrors().forEach(error -> {

        Map<String, String> errors = new HashMap<>();
        String traceId = TraceContextUtil.getCurrentTraceId();

            MethodArgumentNotValidException ex, HttpServletRequest request) {
    public ResponseEntity<ErrorResponse> handleValidationException(
    @ExceptionHandler(MethodArgumentNotValidException.class)

    }
        return ResponseEntity.status(ex.getHttpStatus()).body(error);

        error.setDetails(ex.getDetails() != null ? Map.of("details", ex.getDetails()) : null);
        );
                traceId
                request.getRequestURI(),
                ex.getMessage(),
                ex.getErrorCode(),
        ErrorResponse error = ErrorResponse.of(

                traceId, ex.getErrorCode(), ex.getMessage());
        log.error("Business exception - traceId: {}, code: {}, message: {}",
        String traceId = TraceContextUtil.getCurrentTraceId();

            BusinessException ex, HttpServletRequest request) {
    public ResponseEntity<ErrorResponse> handleBusinessException(
    @ExceptionHandler(BusinessException.class)

public class GlobalExceptionHandler {
@Slf4j
@RestControllerAdvice

import java.util.Map;
import java.util.HashMap;

import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.validation.FieldError;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import lombok.extern.slf4j.Slf4j;
import jakarta.servlet.http.HttpServletRequest;
import com.hbs.common.util.TraceContextUtil;
import com.hbs.common.exception.BusinessException;
import com.hbs.common.dto.ErrorResponse;


