# 🏥 HBS - Hastane Bilgi Sistemi
## Microservices | Event-Driven | API Gateway | DDD | Saga | Zero Trust

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.1-green.svg)](https://spring.io/projects/spring-boot)
[![Kafka](https://img.shields.io/badge/Kafka-3.6.1-black.svg)](https://kafka.apache.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()

---

## 📋 Proje Durumu

### ✅ Tamamlanan Bileşenler

#### 🏗️ Core Infrastructure
- ✅ Monorepo yapısı oluşturuldu
- ✅ Parent POM (dependency management)
- ✅ Common module (shared libraries)
- ✅ Docker Compose (dev environment)
- ✅ Observability stack (Prometheus, Grafana, Jaeger)

#### 🔧 Mikroservisler
- ✅ **Patient Service** (Hasta Yönetimi)
  - CRUD operasyonları
  - Event publishing (patient.registered)
  - PostgreSQL + Redis cache
  - Flyway migration
  - REST API endpoints
  
- ✅ **API Gateway**
  - Spring Cloud Gateway
  - Route definitions
  - CORS configuration
  - Metrics endpoint

#### 📦 Infrastructure Services
- ✅ PostgreSQL (Patient DB)
- ✅ Redis (Cache)
- ✅ Kafka (Event Bus)
- ✅ Keycloak (IAM)
- ✅ Prometheus (Metrics)
- ✅ Grafana (Dashboards)
- ✅ Jaeger (Tracing)
- ✅ MinIO (Object Storage)
- ✅ Kafka UI

#### 📚 Documentation
- ✅ Architecture Decision Records (ADR)
- ✅ Context Map (DDD)
- ✅ Quick Start Guide
- ✅ API Documentation

---

## 🚀 Hızlı Başlangıç

### 1️⃣ Altyapıyı Başlatın

```powershell
cd C:\Users\90551\IdeaProjects\HBS\infra
docker-compose -f docker-compose.dev.yml up -d
```

**Başlatılan Servisler:**
| Servis | URL | Kullanıcı |
|--------|-----|-----------|
| PostgreSQL | localhost:5432 | hbs_user/hbs_password |
| Redis | localhost:6379 | - |
| Kafka | localhost:9092 | - |
| Kafka UI | http://localhost:8090 | - |
| Keycloak | http://localhost:8080 | admin/admin |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:3000 | admin/admin |
| Jaeger | http://localhost:16686 | - |
| MinIO | http://localhost:9001 | minioadmin/minioadmin |

### 2️⃣ Common Module Build

```powershell
cd C:\Users\90551\IdeaProjects\HBS\common
mvn clean install
```

### 3️⃣ Patient Service Başlatın

```powershell
cd C:\Users\90551\IdeaProjects\HBS\patient-service
mvn spring-boot:run
```

Patient Service: **http://localhost:8081**

### 4️⃣ Gateway Başlatın (Opsiyonel)

```powershell
cd C:\Users\90551\IdeaProjects\HBS\gateway
mvn spring-boot:run
```

Gateway: **http://localhost:8000**

---

## 📡 API Endpoints

### Patient Service

#### Hasta Oluştur
```bash
POST http://localhost:8081/api/patient
Content-Type: application/json

{
  "nationalId": "12345678901",
  "name": "Ahmet",
  "surname": "Yılmaz",
  "birthDate": "1990-05-15",
  "gender": "MALE",
  "phone": "+905551234567",
  "email": "ahmet.yilmaz@example.com",
  "city": "İstanbul"
}
```

#### Hasta Sorgula
```bash
GET http://localhost:8081/api/patient/{patientId}
GET http://localhost:8081/api/patient/national-id/12345678901
GET http://localhost:8081/api/patient/file-number/HBS-2026-000001
GET http://localhost:8081/api/patient/search?query=Ahmet
GET http://localhost:8081/api/patient/active
```

---

## 🏗️ Mimari

### Bounded Contexts (DDD)

```
┌─────────────────┐
│  API Gateway    │
└────────┬────────┘
         │
    ┌────┴────────────────────┐
    │                         │
┌───▼──────┐          ┌───────▼────┐
│ Patient  │─────────►│ Appointment│
│ Context  │          │ Context    │
└───┬──────┘          └───────┬────┘
    │                         │
    │ Events (Kafka)          │
    │                         │
┌───▼──────┐          ┌───────▼────┐
│ Clinical │          │   Billing  │
│ Context  │          │   Context  │
└──────────┘          └────────────┘
```

### Event Flow

```
Patient Registered Event
  │
  ├──► Appointment Service (create appointment slots)
  ├──► Notification Service (welcome SMS/email)
  └──► Audit Service (log patient creation)
```

---

## 🎯 Sonraki Adımlar

### Phase 1 (Temel Domain) - 🔄 Devam Ediyor
- [x] Patient Service
- [ ] Appointment Service
- [ ] IAM Service (Keycloak entegrasyonu)
- [ ] Basic UI (React/Angular)

### Phase 2 (Klinik)
- [ ] Clinical Service (muayene, ICD-10)
- [ ] Pharmacy Service (reçete, ilaç etkileşimi)
- [ ] Stock decrement Saga

### Phase 3 (Lab & Imaging)
- [ ] Lab Service (tetkik, sonuç)
- [ ] Imaging Service (RIS/PACS, DICOM)
- [ ] Device integration

### Phase 4 (Faturalama)
- [ ] Billing Service
- [ ] SUT kuralları
- [ ] Medula entegrasyonu
- [ ] Invoice Saga

### Phase 5 (Notification & Audit)
- [ ] Notification Service (SMS, Email, Push)
- [ ] Audit log hardening
- [ ] Compliance reports

### Phase 6 (Security & Production)
- [ ] OAuth2/JWT entegrasyonu
- [ ] mTLS (service-to-service)
- [ ] Zero Trust policies
- [ ] Kubernetes manifests
- [ ] CI/CD pipeline
- [ ] E2E tests

---

## 📁 Proje Yapısı

```
HBS/
├── common/                    # Shared libraries
│   └── src/main/java/com/hbs/common/
│       ├── event/            # BaseEvent, PatientRegisteredEvent
│       ├── dto/              # ErrorResponse
│       ├── exception/        # BusinessException
│       └── util/             # TraceContextUtil
│
├── patient-service/          # Hasta yönetimi
│   ├── src/main/java/com/hbs/patient/
│   │   ├── domain/          # Patient (aggregate root)
│   │   ├── repository/      # PatientRepository
│   │   ├── service/         # PatientService
│   │   ├── controller/      # PatientController
│   │   ├── dto/             # CreatePatientRequest, PatientResponse
│   │   ├── event/           # PatientEventPublisher
│   │   └── config/          # SecurityConfig, ExceptionHandler
│   └── src/main/resources/
│       ├── application.properties
│       └── db/migration/    # Flyway migrations
│
├── gateway/                  # API Gateway
│   ├── src/main/java/com/hbs/gateway/
│   └── src/main/resources/
│       └── application.properties
│
├── infra/                    # Infrastructure
│   ├── docker-compose.dev.yml
│   └── k8s/                 # Kubernetes manifests (future)
│
├── observability/
│   ├── prometheus/
│   │   └── prometheus.yml
│   └── grafana/
│
├── docs/
│   ├── ADR.md               # Architecture Decision Records
│   ├── CONTEXT_MAP.md       # DDD Context Map
│   └── QUICK_START.md       # Quick Start Guide
│
├── pom.xml                   # Parent POM
├── README.md
├── .gitignore
└── build-and-start.ps1      # Build script
```

---

## 🔧 Teknoloji Stack

| Katman | Teknoloji |
|--------|-----------|
| **Backend** | Java 17, Spring Boot 3.2.1 |
| **API** | REST, gRPC (planned) |
| **Gateway** | Spring Cloud Gateway |
| **Messaging** | Apache Kafka 3.6.1 |
| **Database** | PostgreSQL 16 |
| **Cache** | Redis 7 |
| **Security** | Keycloak, OAuth2, JWT |
| **Monitoring** | Prometheus, Grafana |
| **Tracing** | Jaeger, OpenTelemetry |
| **Logging** | SLF4J, Logback (ELK planned) |
| **Storage** | MinIO (S3-compatible) |
| **Container** | Docker, Docker Compose |
| **Orchestration** | Kubernetes (planned) |

---

## 📊 Özellikler

### ✨ Implemented
- ✅ Event-driven architecture (Kafka)
- ✅ Database per service pattern
- ✅ Distributed tracing (correlation ID)
- ✅ Metrics & monitoring (Prometheus)
- ✅ Caching (Redis)
- ✅ Health checks & actuators
- ✅ Database migration (Flyway)
- ✅ Global exception handling
- ✅ Request/Response validation
- ✅ Structured logging with trace ID

### 🔜 Planned
- ⏳ Saga pattern (choreography & orchestration)
- ⏳ Circuit breaker (Resilience4j)
- ⏳ Rate limiting (Redis)
- ⏳ OAuth2 Resource Server
- ⏳ mTLS (service-to-service)
- ⏳ API versioning
- ⏳ GraphQL (BFF layer)
- ⏳ CQRS & Event Sourcing

---

## 🧪 Test Stratejisi

```
Unit Tests         (JUnit 5, Mockito)
    ↓
Integration Tests  (Testcontainers)
    ↓
Contract Tests     (Pact)
    ↓
E2E Tests         (Cucumber, REST Assured)
    ↓
Chaos Tests       (Fault injection)
```

---

## 📈 Performans Hedefleri

| Metrik | Hedef |
|--------|-------|
| API Response Time (p95) | < 200ms |
| Event Publish Latency | < 50ms |
| Database Query Time | < 100ms |
| Cache Hit Ratio | > 80% |
| Availability | 99.9% |
| RTO (Recovery Time) | < 15min |
| RPO (Data Loss) | < 5min |

---

## 🤝 Katkıda Bulunma

1. Feature branch oluşturun: `git checkout -b feature/amazing-feature`
2. Commit atın: `git commit -m 'feat: Add amazing feature'`
3. Push edin: `git push origin feature/amazing-feature`
4. Pull Request açın

**Commit Convention:** [Conventional Commits](https://www.conventionalcommits.org/)
- `feat:` Yeni özellik
- `fix:` Bug fix
- `docs:` Dokümantasyon
- `refactor:` Kod iyileştirme
- `test:` Test ekleme/düzeltme

---

## 📞 Destek

- **GitHub Issues**: Bug reports & feature requests
- **Email**: hbs-dev@example.com
- **Docs**: [docs/](./docs/)

---

## 📄 Lisans

Proprietary - Tüm hakları saklıdır © 2026

---

## 🙏 Teşekkürler

Bu proje modern mikroservis mimarisi best practice'lerini takip eder:
- Domain-Driven Design (Eric Evans)
- Microservices Patterns (Chris Richardson)
- Building Event-Driven Microservices (Adam Bellemare)
- Zero Trust Networks (Evan Gilman)

---

**Hazırlayan**: HBS Development Team  
**Tarih**: 2 Ocak 2026  
**Versiyon**: 1.0.0-SNAPSHOT

🚀 **Mutlu Kodlamalar!**

