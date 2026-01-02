# HBS - Quick Start Guide

## 🚀 Hızlı Başlangıç

### Ön Gereksinimler
- Java 17 veya üzeri
- Maven 3.8+
- Docker ve Docker Compose
- Git

### 1️⃣ Altyapıyı Başlatın

```bash
# Proje dizinine gidin
cd C:\Users\90551\IdeaProjects\HBS

# Docker Compose ile infrastructure'ı başlatın
cd infra
docker-compose -f docker-compose.dev.yml up -d

# Servislerin ayağa kalkmasını bekleyin (1-2 dakika)
docker-compose -f docker-compose.dev.yml ps
```

**Başlatılan Servisler:**
- PostgreSQL (Patient DB): `localhost:5432`
- Redis: `localhost:6379`
- Kafka: `localhost:9092`
- Kafka UI: `http://localhost:8090`
- Keycloak: `http://localhost:8080` (admin/admin)
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3000` (admin/admin)
- Jaeger: `http://localhost:16686`
- MinIO: `http://localhost:9001` (minioadmin/minioadmin)

### 2️⃣ Common Module'ü Build Edin

```bash
cd C:\Users\90551\IdeaProjects\HBS\common
mvn clean install
```

### 3️⃣ Patient Service'i Başlatın

```bash
cd C:\Users\90551\IdeaProjects\HBS\patient-service
mvn spring-boot:run
```

Patient Service `http://localhost:8081` adresinde çalışacak.

### 4️⃣ Gateway'i Başlatın (Opsiyonel)

```bash
# Yeni terminal
cd C:\Users\90551\IdeaProjects\HBS\gateway
mvn spring-boot:run
```

Gateway `http://localhost:8000` adresinde çalışacak.

---

## 🧪 API Testleri

### Patient Service Endpoints

#### 1. Hasta Oluştur
```bash
curl -X POST http://localhost:8081/api/patient \
  -H "Content-Type: application/json" \
  -d '{
    "nationalId": "12345678901",
    "name": "Ahmet",
    "surname": "Yılmaz",
    "birthDate": "1990-05-15",
    "gender": "MALE",
    "phone": "+905551234567",
    "email": "ahmet.yilmaz@example.com",
    "address": "Atatürk Cad. No:123",
    "city": "İstanbul",
    "country": "Türkiye",
    "bloodType": "A+"
  }'
```

**Beklenen Response:**
```json
{
  "patientId": "uuid",
  "nationalId": "12345678901",
  "fileNumber": "HBS-2026-000001",
  "name": "Ahmet",
  "surname": "Yılmaz",
  "fullName": "Ahmet Yılmaz",
  "birthDate": "1990-05-15",
  "gender": "MALE",
  "phone": "+905551234567",
  "email": "ahmet.yilmaz@example.com",
  "active": true,
  "createdAt": "2026-01-02T12:34:56.789Z"
}
```

#### 2. Hasta Sorgula (ID ile)
```bash
curl http://localhost:8081/api/patient/{patientId}
```

#### 3. Hasta Sorgula (TC Kimlik No ile)
```bash
curl http://localhost:8081/api/patient/national-id/12345678901
```

#### 4. Hasta Sorgula (Dosya Numarası ile)
```bash
curl http://localhost:8081/api/patient/file-number/HBS-2026-000001
```

#### 5. Hasta Ara (İsim/Soyisim)
```bash
curl http://localhost:8081/api/patient/search?query=Ahmet
```

#### 6. Aktif Hastaları Listele
```bash
curl http://localhost:8081/api/patient/active
```

---

## 📊 Monitoring

### Prometheus Metrics
http://localhost:9090
- Patient service metrics: `patient_create_seconds`, `patient_get_seconds`

### Grafana Dashboard
http://localhost:3000
- Username: admin
- Password: admin

### Jaeger Tracing
http://localhost:16686
- Distributed tracing için trace ID'leri görüntüleyin

### Kafka UI
http://localhost:8090
- Topic'leri görüntüleyin: `patient.registered`
- Event'leri consume edin

---

## 🔍 Kafka Event Kontrolü

### Patient Registered Event'ini İzle

Kafka UI'dan veya CLI ile:

```bash
# Kafka container'a girin
docker exec -it hbs-kafka bash

# Topic'leri listeleyin
kafka-topics --bootstrap-server localhost:9092 --list

# patient.registered topic'ini dinleyin
kafka-console-consumer --bootstrap-server localhost:9092 \
  --topic patient.registered \
  --from-beginning
```

**Örnek Event:**
```json
{
  "eventId": "uuid",
  "eventType": "patient.registered",
  "occurredAt": "2026-01-02T12:34:56.789Z",
  "traceId": "correlation-id",
  "triggeredBy": "system",
  "payload": {
    "patientId": "uuid",
    "nationalId": "12345678901",
    "fileNumber": "HBS-2026-000001",
    "name": "Ahmet",
    "surname": "Yılmaz",
    "birthDate": "1990-05-15",
    "gender": "MALE",
    "phone": "+905551234567",
    "email": "ahmet.yilmaz@example.com",
    "createdBy": "system"
  }
}
```

---

## 🛠️ Development Workflow

### Yeni Mikroservis Eklemek

1. `pom.xml` (root) içine module ekleyin
2. Servis için pom.xml oluşturun (parent: hbs-parent)
3. Domain, Repository, Service, Controller paternini takip edin
4. Flyway migration ekleyin
5. Docker Compose'a PostgreSQL instance ekleyin (gerekirse)
6. Gateway'e route ekleyin

### Event Publish Etmek

```java
// Common'da event tanımlayın
public class YourEvent extends BaseEvent { ... }

// Publisher oluşturun
@Component
public class YourEventPublisher {
    private final KafkaTemplate<String, String> kafkaTemplate;
    
    public void publish(YourEvent event) {
        kafkaTemplate.send("your.topic", event.getId(), jsonString);
    }
}
```

### Event Consume Etmek

```java
@Component
public class YourEventConsumer {
    
    @KafkaListener(topics = "patient.registered", groupId = "your-service")
    public void consume(String message) {
        // Process event
    }
}
```

---

## 🐛 Troubleshooting

### PostgreSQL bağlantı hatası
```bash
# Database'in çalıştığını kontrol edin
docker exec -it hbs-postgres-patient psql -U hbs_user -d hbs_patient -c "\dt"
```

### Kafka bağlantı hatası
```bash
# Kafka'nın hazır olduğunu kontrol edin
docker exec -it hbs-kafka kafka-broker-api-versions --bootstrap-server localhost:9092
```

### Redis bağlantı hatası
```bash
# Redis'in çalıştığını kontrol edin
docker exec -it hbs-redis redis-cli ping
```

### Flyway migration hatası
```bash
# Migration'ları manuel çalıştırın
cd patient-service
mvn flyway:migrate
```

---

## 📦 Build ve Deployment

### Tüm projeyi build edin
```bash
cd C:\Users\90551\IdeaProjects\HBS
mvn clean install
```

### Docker image oluşturun (her servis için)
```bash
cd patient-service
docker build -t hbs/patient-service:1.0.0 .
```

### Kubernetes'e deploy edin (production)
```bash
cd infra/k8s
kubectl apply -f namespace.yaml
kubectl apply -f patient-service/
```

---

## 🎯 Sonraki Adımlar

✅ **Tamamlandı:**
- [x] Proje yapısı oluşturuldu
- [x] Common module (event, exception, utils)
- [x] Patient Service (CRUD, event publishing)
- [x] Docker Compose infrastructure
- [x] API Gateway routing
- [x] Observability stack (Prometheus, Grafana, Jaeger)

⏭️ **Sıradaki:**
- [ ] Appointment Service (randevu yönetimi)
- [ ] Clinical Service (muayene, tanı, ICD-10)
- [ ] Pharmacy Service (reçete, ilaç etkileşimi)
- [ ] Billing Service (faturalama, SUT, Medula)
- [ ] Keycloak entegrasyonu (OAuth2/JWT)
- [ ] Saga pattern implementation
- [ ] E2E testler
- [ ] CI/CD pipeline (GitHub Actions/Jenkins)

---

## 📞 Destek

Sorularınız için:
- GitHub Issues
- HBS Development Team

**Mutlu Kodlamalar! 🚀**

