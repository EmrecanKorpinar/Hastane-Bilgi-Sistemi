# HBS - Build ve Start Script
# PowerShell script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HBS - Hastane Bilgi Sistemi" -ForegroundColor Cyan
Write-Host "  Build ve Start Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Infrastructure Start
Write-Host "[1/4] Infrastructure (Docker Compose) başlatılıyor..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\90551\IdeaProjects\HBS\infra"
docker-compose -f docker-compose.dev.yml up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "HATA: Docker Compose başlatılamadı!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Infrastructure başlatıldı" -ForegroundColor Green
Write-Host "  - PostgreSQL: localhost:5432" -ForegroundColor Gray
Write-Host "  - Redis: localhost:6379" -ForegroundColor Gray
Write-Host "  - Kafka: localhost:9092" -ForegroundColor Gray
Write-Host "  - Keycloak: http://localhost:8080" -ForegroundColor Gray
Write-Host "  - Prometheus: http://localhost:9090" -ForegroundColor Gray
Write-Host "  - Grafana: http://localhost:3000" -ForegroundColor Gray
Write-Host "  - Jaeger: http://localhost:16686" -ForegroundColor Gray
Write-Host ""

# Wait for services
Write-Host "Servislerin hazır olması bekleniyor (30 saniye)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 2. Build Common Module
Write-Host "[2/4] Common module build ediliyor..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\90551\IdeaProjects\HBS\common"
mvn clean install -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "HATA: Common module build edilemedi!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Common module build edildi" -ForegroundColor Green
Write-Host ""

# 3. Build Patient Service
Write-Host "[3/4] Patient Service build ediliyor..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\90551\IdeaProjects\HBS\patient-service"
mvn clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "HATA: Patient Service build edilemedi!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Patient Service build edildi" -ForegroundColor Green
Write-Host ""

# 4. Build Gateway
Write-Host "[4/4] Gateway build ediliyor..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\90551\IdeaProjects\HBS\gateway"
mvn clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "HATA: Gateway build edilemedi!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Gateway build edildi" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  BUILD TAMAMLANDI!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Servisleri başlatmak için:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  # Patient Service:" -ForegroundColor Gray
Write-Host "  cd C:\Users\90551\IdeaProjects\HBS\patient-service" -ForegroundColor White
Write-Host "  mvn spring-boot:run" -ForegroundColor White
Write-Host ""
Write-Host "  # Gateway (opsiyonel):" -ForegroundColor Gray
Write-Host "  cd C:\Users\90551\IdeaProjects\HBS\gateway" -ForegroundColor White
Write-Host "  mvn spring-boot:run" -ForegroundColor White
Write-Host ""

Write-Host "API Testleri için:" -ForegroundColor Yellow
Write-Host "  docs/QUICK_START.md dosyasına bakın" -ForegroundColor White
Write-Host ""

Write-Host "Monitoring:" -ForegroundColor Yellow
Write-Host "  - Kafka UI: http://localhost:8090" -ForegroundColor White
Write-Host "  - Grafana: http://localhost:3000 (admin/admin)" -ForegroundColor White
Write-Host "  - Jaeger: http://localhost:16686" -ForegroundColor White
Write-Host ""

