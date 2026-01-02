# 🎯 HBS Hızlı Test Komutları

## ✅ Sistem Durumu Kontrolü

### Infrastructure Kontrolü
```powershell
# Docker container'ları kontrol et
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# PostgreSQL bağlantısını test et
docker exec -it hbs-postgres-patient psql -U hbs_user -d hbs_patient -c "\dt"

# Kafka topic'lerini listele
docker exec -it hbs-kafka kafka-topics --bootstrap-server localhost:9092 --list
```

### Frontend Kontrolü
```powershell
# Frontend durumu
Get-Process | Where-Object {$_.ProcessName -like "*node*"}

# Frontend log'larını göster
# (Terminal ID: e00489e9-0257-4a8c-8ce3-1b8a7c35e942)
```

## 🚀 Backend Başlatma (IntelliJ IDEA)

### 1. Common Module Build
IntelliJ IDEA'da:
1. Maven panelini aç (View → Tool Windows → Maven)
2. `HBS → common → Lifecycle` altında:
   - ✅ `clean` - çift tıkla
   - ✅ `install` - çift tıkla

### 2. Patient Service Başlat
İki yöntem:

**Yöntem A - Run Configuration (Önerilen):**
1. IntelliJ IDEA üst menüde Run/Debug dropdown
2. **"Patient Service"** seçeneğini seç
3. ▶️ Run butonuna tıkla

**Yöntem B - Ana Sınıftan:**
1. `patient-service/src/main/java/com/hbs/patient/PatientServiceApplication.java` aç
2. Sınıfın içinde sağ tıkla
3. **"Run 'PatientServiceApplication.main()'"** seç

### 3. Gateway Başlat (Opsiyonel)
1. Run/Debug dropdown → **"Gateway"** seç
2. ▶️ Run butonuna tıkla

## 🧪 API Test Komutları

### Health Check
```powershell
# Patient Service sağlık kontrolü
Invoke-RestMethod -Uri http://localhost:8081/actuator/health

# Detaylı bilgi
Invoke-RestMethod -Uri http://localhost:8081/actuator/info
```

### Yeni Hasta Oluştur
```powershell
$patient = @{
    nationalId = "12345678901"
    name = "Ahmet"
    surname = "Yılmaz"
    birthDate = "1990-05-15"
    gender = "MALE"
    phone = "+905551234567"
    email = "ahmet@example.com"
    address = "Kadıköy, İstanbul"
    city = "İstanbul"
    country = "Türkiye"
    bloodType = "A+"
    emergencyContact = "Ayşe Yılmaz"
    emergencyPhone = "+905559876543"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri http://localhost:8081/api/patients `
    -Method POST `
    -ContentType "application/json" `
    -Body $patient

Write-Host "✅ Hasta oluşturuldu!" -ForegroundColor Green
Write-Host "Dosya No: $($response.fileNumber)" -ForegroundColor Cyan
Write-Host "Hasta ID: $($response.patientId)" -ForegroundColor Cyan
```

### Aktif Hastaları Listele
```powershell
$patients = Invoke-RestMethod -Uri http://localhost:8081/api/patients/active

Write-Host "`n📋 Aktif Hastalar:" -ForegroundColor Yellow
$patients | Format-Table fileNumber, fullName, nationalId, birthDate -AutoSize
```

### Hasta Ara
```powershell
$searchQuery = "Ahmet"
$results = Invoke-RestMethod -Uri "http://localhost:8081/api/patients/search?query=$searchQuery"

Write-Host "`n🔍 Arama Sonuçları ($searchQuery):" -ForegroundColor Yellow
$results | Format-Table fileNumber, fullName, phone, city -AutoSize
```

### Hasta ID ile Sorgula
```powershell
# Önce bir hasta ID'si al
$patients = Invoke-RestMethod -Uri http://localhost:8081/api/patients/active
$patientId = $patients[0].patientId

# Hasta detayını getir
$patient = Invoke-RestMethod -Uri "http://localhost:8081/api/patients/$patientId"

Write-Host "`n👤 Hasta Detayı:" -ForegroundColor Yellow
$patient | Format-List
```

## 🎨 Frontend Test Senaryoları

### 1. Ana Sayfa
```
URL: http://localhost:3001
Kontrol:
- ✅ Header navigasyon görünüyor mu?
- ✅ 3 özellik kartı (Microservices, Event-Driven, Zero Trust) gösteriliyor mu?
- ✅ Footer bilgisi doğru mu?
```

### 2. Yeni Hasta Formu
```
URL: http://localhost:3001/create-patient
Test:
1. Tüm alanları doldur
2. "Hasta Kaydı Oluştur" butonuna tıkla
3. Başarı mesajında dosya numarasını not et
4. Form temizlendi mi kontrol et
```

### 3. Hasta Listesi
```
URL: http://localhost:3001/patients
Test:
1. Hasta listesi yüklendi mi?
2. Arama kutusuna "Ahmet" yaz ve ara
3. Sonuçlar filtrelendi mi?
4. Herhangi bir hasta satırında "Detay" butonuna tıkla
```

## 📊 Kafka Event'lerini İzle

### Kafka UI ile
```
URL: http://localhost:8090
Adımlar:
1. Topics → patient.events seç
2. Messages sekmesine git
3. Yeni hasta oluştur (Frontend veya API ile)
4. Event'in geldiğini gör
```

### Kafka Console Consumer ile
```powershell
docker exec -it hbs-kafka kafka-console-consumer `
    --bootstrap-server localhost:9092 `
    --topic patient.events `
    --from-beginning `
    --property print.timestamp=true
```

## 🔍 Monitoring & Tracing

### Prometheus Metrics
```
URL: http://localhost:9090
Sorgular:
- http_server_requests_seconds_count{uri="/api/patients"}
- jvm_memory_used_bytes{area="heap"}
- hikaricp_connections_active
```

### Grafana Dashboard
```
URL: http://localhost:3000
Kullanıcı: admin
Şifre: admin

1. Home → Dashboards → Browse
2. Spring Boot Dashboard'u seç
3. Patient Service metriklerini gör
```

### Jaeger Distributed Tracing
```
URL: http://localhost:16686
Adımlar:
1. Service dropdown → patient-service
2. Operation → POST /api/patients
3. Find Traces
4. Bir trace'e tıkla ve span detaylarını incele
```

## 🐛 Sorun Giderme Komutları

### Port Kullanımı Kontrolü
```powershell
# Port 8081 (Patient Service)
netstat -ano | findstr :8081

# Port 3001 (Frontend)
netstat -ano | findstr :3001

# Port 5432 (PostgreSQL)
netstat -ano | findstr :5432
```

### Log'ları Görüntüle
```powershell
# PostgreSQL logs
docker logs hbs-postgres-patient --tail 50

# Kafka logs
docker logs hbs-kafka --tail 50

# Redis logs
docker logs hbs-redis --tail 50
```

### Database İçeriğini Kontrol Et
```powershell
# Patient tablosunu görüntüle
docker exec -it hbs-postgres-patient psql -U hbs_user -d hbs_patient -c "SELECT patient_id, file_number, full_name, national_id FROM patients LIMIT 10;"

# Toplam hasta sayısı
docker exec -it hbs-postgres-patient psql -U hbs_user -d hbs_patient -c "SELECT COUNT(*) as total_patients FROM patients;"
```

### Infrastructure Yeniden Başlat
```powershell
cd C:\Users\90551\IdeaProjects\HBS\infra

# Tüm servisleri durdur
docker-compose -f docker-compose.dev.yml down

# Verileri koruyarak yeniden başlat
docker-compose -f docker-compose.dev.yml up -d

# Volume'lerle beraber temizle (DİKKAT: Tüm veriler silinir!)
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
```

## 📝 Hızlı Test Scripti

### Otomatik Test (PowerShell)
```powershell
# test-hbs.ps1
Write-Host "🏥 HBS Sistem Testi Başlıyor..." -ForegroundColor Cyan

# 1. Health Check
Write-Host "`n[1/5] Health Check..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri http://localhost:8081/actuator/health
    Write-Host "✅ Patient Service: $($health.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Patient Service erişilemiyor!" -ForegroundColor Red
    exit 1
}

# 2. Yeni Hasta Oluştur
Write-Host "`n[2/5] Yeni hasta oluşturuluyor..." -ForegroundColor Yellow
$patient = @{
    nationalId = "98765432101"
    name = "Test"
    surname = "User"
    birthDate = "1995-01-01"
    gender = "MALE"
} | ConvertTo-Json

$created = Invoke-RestMethod -Uri http://localhost:8081/api/patients -Method POST -ContentType "application/json" -Body $patient
Write-Host "✅ Hasta oluşturuldu: $($created.fileNumber)" -ForegroundColor Green

# 3. Hastaları Listele
Write-Host "`n[3/5] Hastalar listeleniyor..." -ForegroundColor Yellow
$patients = Invoke-RestMethod -Uri http://localhost:8081/api/patients/active
Write-Host "✅ Toplam $($patients.Count) hasta bulundu" -ForegroundColor Green

# 4. Arama Testi
Write-Host "`n[4/5] Arama testi..." -ForegroundColor Yellow
$results = Invoke-RestMethod -Uri "http://localhost:8081/api/patients/search?query=Test"
Write-Host "✅ Arama sonucu: $($results.Count) hasta" -ForegroundColor Green

# 5. Hasta Detayı
Write-Host "`n[5/5] Hasta detayı getiriliyor..." -ForegroundColor Yellow
$detail = Invoke-RestMethod -Uri "http://localhost:8081/api/patients/$($created.patientId)"
Write-Host "✅ Hasta detayı alındı: $($detail.fullName)" -ForegroundColor Green

Write-Host "`n🎉 Tüm testler başarılı!" -ForegroundColor Green
```

Bu scripti çalıştır:
```powershell
cd C:\Users\90551\IdeaProjects\HBS
.\test-hbs.ps1
```

---

**Not**: Backend servisleri başlatmadan önce mutlaka:
1. ✅ Docker container'ların çalıştığından emin olun
2. ✅ Common module build edilmiş olmalı
3. ✅ IntelliJ IDEA'da Maven import tamamlanmış olmalı

