# Hastane Bilgi Sistemi (HBS)

##  Proje Vizyonu
Profesyonel bir Hastane Bilgi Sistemi - Microservices, Event-Driven, API Gateway, DDD, Saga Pattern ve Zero Trust güvenlik yaklaşımıyla geliştirilmiş, üretim odaklı bir mimari.

##  Mimari Yaklaşım
- **Microservices Architecture**: Her servis tek bir iş sorumluluğu
- **Event-Driven**: Kafka ile asenkron, gevşek bağlı iletişim
- **API Gateway**: Merkezi yönlendirme, güvenlik, rate limiting
- **Domain-Driven Design (DDD)**: Bounded contexts ile net sınırlar
- **Saga Pattern**: Dağıtık transaction yönetimi
- **Zero Trust Security**: mTLS, OAuth2/OpenID, JWT, policy enforcement

##  Teknoloji Stack
- **Backend**: Java 17+ / Spring Boot 3.x
- **API**: REST, gRPC (servisler arası)
- **Messaging**: Kafka / RabbitMQ
- **Database**: PostgreSQL (transactional), Redis (cache), MongoDB (logs)
- **Storage**: MinIO / S3 (DICOM, imaging)
- **Security**: Keycloak (OAuth2/OpenID Connect)
- **Observability**: ELK Stack, Prometheus, Grafana, Jaeger
- **Containerization**: Docker (dev), Kubernetes (prod)
- **Frontend**: Angular/React (Web), Flutter (Mobile)

##  Monorepo Yapısı
```
HBS/
├── gateway/                    # API Gateway (Spring Cloud Gateway)
├── auth-service/              # Authentication & Authorization
├── patient-service/           # Hasta yönetimi
├── appointment-service/       # Randevu yönetimi (MHRS benzeri)
├── clinical-service/          # Muayene, tanı, tedavi planı
├── pharmacy-service/          # Reçete, ilaç etkileşimi
├── lab-service/               # Laboratuvar testleri
├── imaging-service/           # Radyoloji (RIS/PACS)
├── billing-service/           # Faturalama, SUT, Medula
├── inventory-service/         # Stok, depo, ÜTS
├── iam-service/               # Kullanıcı, rol, yetki yönetimi
├── notification-service/      # SMS, Email, Push bildirimleri
├── common/                    # Shared libraries, DTOs, events
├── infra/                     # Docker Compose, Kubernetes manifests
├── observability/             # Monitoring, logging configs
└── docs/                      # ADR, API contracts, DDD maps
```

##  Bounded Contexts (DDD)
| Context | Aggregate Root | Database | Events |
|---------|---------------|----------|--------|
| Patient | Patient | PostgreSQL | patient.registered, patient.updated |
| Appointment | Appointment | PostgreSQL | appointment.created, appointment.cancelled |
| Clinical | Encounter | PostgreSQL | encounter.completed, diagnosis.added |
| Pharmacy | Prescription | PostgreSQL | prescription.created, drug.dispensed |
| Lab | LabOrder | PostgreSQL + MongoDB | lab.ordered, result.ready |
| Imaging | ImagingStudy | PostgreSQL + S3 | study.created, dicom.uploaded |
| Billing | Invoice | PostgreSQL | invoice.created, payment.received |
| Inventory | Stock | PostgreSQL | stock.decremented, reorder.triggered |

##  Event-Driven Architecture
### Topic Tasarımı (Kafka)
- `patient.registered`
- `appointment.created`
- `clinical.encounter.completed`
- `prescription.created`
- `lab.result.ready`
- `invoice.created`
- `stock.decremented`
- `notification.sent`

### Event Schema (Avro/JSON)
```json
{
  "eventId": "uuid",
  "eventType": "patient.registered",
  "occurredAt": "2026-01-02T12:34:56Z",
  "traceId": "correlation-id",
  "payload": {
    "patientId": "uuid",
    "nationalId": "encrypted",
    "fileNumber": "HBS-2026-001234"
  }
}
```

##  Zero Trust Güvenlik
- **Identity**: Keycloak OAuth2/OpenID Connect
- **Network**: mTLS servisler arası, TLS everywhere
- **Data**: Encryption at rest & in transit
- **Access**: JWT tokens, scope-based authorization
- **Audit**: Immutable audit logs, PII masking
- **Policy**: OPA (Open Policy Agent) - RBAC/ABAC

##  Deployment Stratejisi
### Development (Docker Compose)
```bash
cd infra
docker-compose -f docker-compose.dev.yml up
```

### Production (Kubernetes)
```bash
cd infra/k8s
kubectl apply -f namespace.yaml
helm install hbs ./helm-charts
```

##  Observability
- **Logs**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Metrics**: Prometheus + Grafana
- **Tracing**: Jaeger + OpenTelemetry
- **Alerting**: Prometheus Alertmanager

##  Testing Stratejisi
- **Unit Tests**: JUnit 5, Mockito
- **Integration Tests**: Testcontainers
- **Contract Tests**: Pact (Consumer-Driven)
- **E2E Tests**: Cucumber, REST Assured
- **Chaos Testing**: Fault injection

##  Rollout Plan (Aşamalar)
- **Phase 0**: Infrastructure baseline (Keycloak, Kafka, Postgres, Redis)
- **Phase 1**: Core domain (Patient, Appointment, IAM, Gateway)
- **Phase 2**: Clinical + Pharmacy
- **Phase 3**: Lab + Imaging
- **Phase 4**: Billing (SUT/Medula)
- **Phase 5**: Notifications + Audit hardening
- **Phase 6**: Zero Trust policies, mTLS, SLO monitoring

## 🔧 Geliştirme
### Gereksinimler
- Java 17+
- Maven 3.8+
- Docker & Docker Compose
- kubectl (production deployment)
- Node.js 18+ (frontend)

### Başlangıç

#### Otomatik (PowerShell Script)
```powershell
cd C:\Users\IdeaProjects\HBS
.\build-and-start.ps1
```

#### Manuel
```bash
# 1. Infrastructure başlat
cd infra
docker-compose -f docker-compose.dev.yml up -d

# 2. Common module build et
cd ..\common
mvn clean install

# 3. Patient Service başlat
cd ..\patient-service
mvn spring-boot:run

# 4. Gateway başlat (yeni terminal)
cd ..\gateway
mvn spring-boot:run
```

### Servislere Erişim
- **Patient Service**: http://localhost:8081
- **Gateway**: http://localhost:8000
- **Kafka UI**: http://localhost:8090
- **Grafana**: http://localhost:3000 (admin/admin)
- **Jaeger**: http://localhost:16686
- **Keycloak**: http://localhost:8080 (admin/admin)

## 📝 Katkıda Bulunma
1. Feature branch oluştur (`git checkout -b feature/amazing-feature`)
2. Değişikliklerini commit et (`git commit -m 'feat: Add amazing feature'`)
3. Branch'i push et (`git push origin feature/amazing-feature`)
4. Pull Request oluştur



