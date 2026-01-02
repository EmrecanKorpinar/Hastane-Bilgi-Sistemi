# Architecture Decision Records (ADR)

## ADR-001: Microservices Architecture

**Date:** 2026-01-02  
**Status:** Accepted

### Context
HBS (Hastane Bilgi Sistemi) büyük ölçekli bir hastane bilgi sistemi olup, farklı domain'ler (hasta, randevu, klinik, eczane, lab, görüntüleme, faturalama) içerir. Sistem yüksek ölçeklenebilirlik, esneklik ve bağımsız deployment gerektirir.

### Decision
Microservices mimarisi seçildi. Her bounded context (DDD) ayrı bir mikroservis olarak implement edilecek.

### Consequences
**Pozitif:**
- Bağımsız deployment ve ölçekleme
- Teknoloji çeşitliliği (polyglot persistence)
- Team autonomy
- Fault isolation

**Negatif:**
- Distributed system karmaşıklığı
- Network latency
- Transaction yönetimi zorluğu (Saga pattern gerekli)
- Daha fazla operasyonel overhead

---

## ADR-002: Event-Driven Architecture with Kafka

**Date:** 2026-01-02  
**Status:** Accepted

### Context
Mikroservisler arası haberleşme için sync (REST/gRPC) veya async (messaging) yöntemler mevcut. Sistemde birçok servis birbirinden haberdar olmalı (örn: hasta kaydı → randevu → faturalama).

### Decision
Apache Kafka ile event-driven architecture kullanılacak. Kritik event'ler (patient.registered, prescription.created, invoice.created) Kafka topic'lerine publish edilecek.

### Consequences
**Pozitif:**
- Loose coupling
- Async processing (performans)
- Event sourcing potansiyeli
- Replay capability

**Negatif:**
- Eventual consistency
- Debugging zorluğu
- Idempotency gerekliliği

---

## ADR-003: Database per Service

**Date:** 2026-01-02  
**Status:** Accepted

### Context
Mikroservislerin veri izolasyonu ve bağımsızlığı için veritabanı stratejisi belirlenmeli.

### Decision
Her mikroservis kendi veritabanına sahip olacak (PostgreSQL). Servisler arası veri paylaşımı yalnızca API veya event'ler üzerinden.

### Consequences
**Pozitif:**
- Veri izolasyonu ve schema esnekliği
- Bağımsız scaling
- Polyglot persistence potansiyeli

**Negatif:**
- Join'ler imkansız (API composition gerekli)
- Distributed transaction yönetimi (Saga)
- Data duplication

---

## ADR-004: Saga Pattern for Distributed Transactions

**Date:** 2026-01-02  
**Status:** Accepted

### Context
Reçete → Faturalama → Stok düşme gibi multi-service transaction'lar var.

### Decision
Choreography-based Saga pattern kullanılacak. Her servis event'lere tepki verir ve compensation event'leri yayımlar.

### Consequences
**Pozitif:**
- No distributed lock
- Servis autonomy
- Resilient

**Negatif:**
- Eventual consistency
- Compensation logic karmaşıklığı

---

## ADR-005: Zero Trust Security Model

**Date:** 2026-01-02  
**Status:** Accepted

### Context
Hastane verileri hassas (PHI/PII). Network perimeter güvenliği yetersiz.

### Decision
Zero Trust model: mTLS (servis-servis), OAuth2/JWT (kullanıcı auth), her request doğrulanır.

### Consequences
**Pozitif:**
- Defense-in-depth
- Compliance (KVKK, HIPAA equivalent)
- Audit trail

**Negatif:**
- Complexity
- Certificate management overhead

---

## ADR-006: API Gateway Pattern

**Date:** 2026-01-02  
**Status:** Accepted

### Context
Client'lar (web, mobile) her mikroservis ile doğrudan iletişim kurmamalı.

### Decision
Spring Cloud Gateway kullanılacak. Routing, rate limiting, authentication, CORS burada.

### Consequences
**Pozitif:**
- Single entry point
- Centralized security
- Client basitleşir

**Negatif:**
- Single point of failure (HA gerekli)
- Potential bottleneck

---

## ADR-007: Observability Stack (ELK + Prometheus + Jaeger)

**Date:** 2026-01-02  
**Status:** Accepted

### Context
Distributed system monitoring, debugging ve troubleshooting zor.

### Decision
- **Logs**: ELK Stack (structured JSON, correlation ID)
- **Metrics**: Prometheus + Grafana
- **Tracing**: Jaeger + OpenTelemetry

### Consequences
**Pozitif:**
- Full visibility
- Root cause analysis
- SLO monitoring

**Negatif:**
- Infrastructure cost
- Learning curve

