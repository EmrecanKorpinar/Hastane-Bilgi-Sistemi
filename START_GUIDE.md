# 🚀 HBS - Başlatma Kılavuzu

## ✅ Durum Özeti

### Infrastructure (Docker) - ✅ Çalışıyor
Docker Compose ile başlatıldı:
- PostgreSQL (port 5432)
- Redis (port 6379)
- Kafka (port 9092)
- Keycloak (port 8080)
- Prometheus (port 9090)
- Grafana (port 3000)
- Jaeger (port 16686)
- Kafka UI (port 8090)

### Frontend (React) - ✅ Çalışıyor
- **Port**: 3001
- **URL**: http://localhost:3001
- **Teknoloji**: React + TypeScript + Tailwind CSS
- **Özellikler**: 
  - Yeni hasta kaydı
  - Hasta listesi görüntüleme
  - Hasta arama
  - Responsive tasarım

### Backend Servisler - ⏳ IntelliJ IDEA ile başlatılacak

## 📋 Backend Servislerini Başlatma (IntelliJ IDEA)

Maven komut satırında mevcut olmadığı için IntelliJ IDEA kullanarak servisleri başlatmanız gerekiyor.

### Adım 1: Common Module'ü Build Edin

1. IntelliJ IDEA'da projeyi açın
2. Maven panelini açın (sağ tarafta)
3. **HBS → common → Lifecycle** altında:
   - `clean` üzerine çift tıklayın
   - `install` üzerine çift tıklayın

### Adım 2: Patient Service'i Başlatın

1. `patient-service/src/main/java/com/hbs/patient/PatientServiceApplication.java` dosyasını açın
2. `main` metodunun yanındaki yeşil ▶️ işaretine tıklayın
3. **"Run 'PatientServiceApplication'"** seçin
4. Servis başlayınca konsol çıktısında şunu göreceksiniz:
   ```
   Started PatientServiceApplication in X seconds (JVM running for Y)
   ```

### Adım 3: Gateway'i Başlatın (Opsiyonel)

1. `gateway/src/main/java/com/hbs/gateway/GatewayApplication.java` dosyasını açın
2. `main` metodunun yanındaki yeşil ▶️ işaretine tıklayın
3. **"Run 'GatewayApplication'"** seçin

## 🌐 Erişim Noktaları

### Frontend
- **React App**: http://localhost:3001
  - Ana Sayfa: /
  - Yeni Hasta: /create-patient
  - Hasta Listesi: /patients

### Backend API
- **Patient Service (Direkt)**: http://localhost:8081
  - Health Check: http://localhost:8081/actuator/health
  - API Base: http://localhost:8081/api/patients

- **Gateway (Eğer başlatıldıysa)**: http://localhost:8000
  - Patient API: http://localhost:8000/api/patients

### Infrastructure & Monitoring
- **Kafka UI**: http://localhost:8090
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686
- **Keycloak**: http://localhost:8080 (admin/admin)

## 🧪 Sistemi Test Etme

### 1. Health Check
```powershell
# Patient Service health check
Invoke-WebRequest -Uri http://localhost:8081/actuator/health | Select-Object -ExpandProperty Content
```

### 2. Yeni Hasta Oluşturma (Frontend)
1. http://localhost:3001/create-patient adresine gidin
2. Formu doldurun:
   - TC Kimlik No: 12345678901
   - Ad: Ahmet
   - Soyad: Yılmaz
   - Doğum Tarihi: 01/01/1990
   - Cinsiyet: Erkek
   - vb.
3. "Hasta Kaydı Oluştur" butonuna tıklayın

### 3. Hasta Listesini Görüntüleme
1. http://localhost:3001/patients adresine gidin
2. Kayıtlı hastaları görün
3. Arama yapın

### 4. API ile Doğrudan Test (PowerShell)
```powershell
# Yeni hasta oluştur
$body = @{
    nationalId = "12345678901"
    name = "Mehmet"
    surname = "Demir"
    birthDate = "1985-05-15"
    gender = "MALE"
    phone = "+905551234567"
    email = "mehmet@example.com"
    city = "İstanbul"
    country = "Türkiye"
} | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:8081/api/patients `
    -Method POST `
    -ContentType "application/json" `
    -Body $body

# Aktif hastaları listele
Invoke-WebRequest -Uri http://localhost:8081/api/patients/active | 
    Select-Object -ExpandProperty Content | 
    ConvertFrom-Json | 
    Format-Table
```

## 🔍 Event'leri İzleme

### Kafka UI ile Event'leri Görüntüleme
1. http://localhost:8090 adresine gidin
2. **Topics** sekmesine tıklayın
3. `patient.events` topic'ini seçin
4. **Messages** sekmesinde event'leri görün

Yeni bir hasta oluşturduğunuzda `patient.registered` event'ini göreceksiniz:
```json
{
  "eventId": "uuid",
  "eventType": "patient.registered",
  "occurredAt": "2026-01-02T...",
  "traceId": "...",
  "payload": {
    "patientId": "uuid",
    "nationalId": "...",
    "fileNumber": "HBS-2026-001234",
    "fullName": "Ahmet Yılmaz"
  }
}
```

## 🛠️ Sorun Giderme

### Frontend çalışmıyor
```powershell
# Frontend'i yeniden başlat
cd C:\Users\90551\IdeaProjects\HBS\hbs-frontend
npm start
```

### Backend bağlantı hatası
- Patient Service'in çalıştığından emin olun (IntelliJ IDEA konsolu)
- Port 8081'in kullanımda olup olmadığını kontrol edin:
  ```powershell
  netstat -ano | findstr :8081
  ```

### Database bağlantı hatası
- PostgreSQL container'ın çalıştığından emin olun:
  ```powershell
  docker ps | findstr postgres
  ```
- Gerekirse infrastructure'ı yeniden başlatın:
  ```powershell
  cd C:\Users\90551\IdeaProjects\HBS\infra
  docker-compose -f docker-compose.dev.yml restart
  ```

### Kafka bağlantı hatası
```powershell
# Kafka'yı yeniden başlat
cd C:\Users\90551\IdeaProjects\HBS\infra
docker-compose -f docker-compose.dev.yml restart kafka
```

## 📊 Monitoring & Observability

### Grafana Dashboard
1. http://localhost:3000 (admin/admin)
2. **Dashboards** → **Browse**
3. Spring Boot dashboard'ları görün

### Distributed Tracing (Jaeger)
1. http://localhost:16686
2. **Service** dropdown'dan `patient-service` seçin
3. **Find Traces** butonuna tıklayın
4. Request flow'unu görüntüleyin

### Prometheus Metrics
1. http://localhost:9090
2. Query örnekleri:
   - `http_server_requests_seconds_count`
   - `jvm_memory_used_bytes`
   - `kafka_producer_request_total`

## 🎯 Sonraki Adımlar

### Phase 2: Clinical Service
- [ ] Clinical servisini ekle
- [ ] ICD-10 tanı kodları
- [ ] Muayene kayıtları
- [ ] Clinical-Patient event entegrasyonu

### Phase 3: Appointment Service
- [ ] Randevu yönetimi
- [ ] Takvim entegrasyonu
- [ ] MHRS benzeri özellikler

### Phase 4: Güvenlik Hardening
- [ ] Keycloak entegrasyonu
- [ ] JWT authentication
- [ ] Role-based access control
- [ ] API rate limiting

## 📚 Dökümanlar

- **README.md**: Genel bakış ve mimari
- **SETUP_COMPLETE.md**: Kurulum detayları
- **docs/QUICK_START.md**: API kullanımı
- **docs/ADR.md**: Architecture Decision Records
- **PROJECT_STATUS.md**: Proje durumu

---

**Hazırlayan**: GitHub Copilot  
**Tarih**: 2026-01-02  
**Proje**: HBS - Hastane Bilgi Sistemi

