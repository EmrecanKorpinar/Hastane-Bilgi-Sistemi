package com.hbs.patient.config;

import com.hbs.common.util.TraceContextUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class TraceContextFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;

        // Get or generate trace ID
        String traceId = httpRequest.getHeader(TraceContextUtil.TRACE_ID_HEADER);
        if (traceId == null || traceId.isEmpty()) {
            traceId = TraceContextUtil.generateTraceId();
        }

        // Set to MDC
        TraceContextUtil.setTraceId(traceId);

        try {
            chain.doFilter(request, response);
        } finally {
            TraceContextUtil.clearTraceId();
        }
    }
}

