package com.hbs.common.util;

import org.slf4j.MDC;

import java.util.UUID;

/**
 * Utility class for managing trace/correlation IDs across distributed services
 */
public class TraceContextUtil {

    public static final String TRACE_ID_HEADER = "X-Trace-Id";
    public static final String TRACE_ID_MDC_KEY = "traceId";

    private TraceContextUtil() {
        // Utility class
    }

    /**
     * Generate a new trace ID
     */
    public static String generateTraceId() {
        return UUID.randomUUID().toString();
    }

    /**
     * Get current trace ID from MDC
     */
    public static String getCurrentTraceId() {
        String traceId = MDC.get(TRACE_ID_MDC_KEY);
        if (traceId == null) {
            traceId = generateTraceId();
            setTraceId(traceId);
        }
        return traceId;
    }

    /**
     * Set trace ID to MDC
     */
    public static void setTraceId(String traceId) {
        MDC.put(TRACE_ID_MDC_KEY, traceId);
    }

    /**
     * Clear trace ID from MDC
     */
    public static void clearTraceId() {
        MDC.remove(TRACE_ID_MDC_KEY);
    }
}

