# HBS Test ve Çalıştırma Scripti
# PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HBS - Test ve Çalıştırma" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Docker servisleri kontrol
Write-Host "[1/5] Docker servisleri kontrol ediliyor..." -ForegroundColor Yellow
$dockerRunning = docker ps 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Docker Desktop çalışmıyor!" -ForegroundColor Red
    Write-Host "Lütfen Docker Desktop'ı başlatın ve tekrar deneyin." -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Docker çalışıyor" -ForegroundColor Green
Write-Host ""

# Test 2: Infrastructure başlat
Write-Host "[2/5] Infrastructure başlatılıyor..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\90551\IdeaProjects\HBS\infra"
docker-compose -f docker-compose.dev.yml up -d 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Infrastructure başlatıldı" -ForegroundColor Green
} else {
    Write-Host "⚠️  Infrastructure başlatılamadı (devam ediliyor...)" -ForegroundColor Yellow
}

Write-Host "Servisler hazırlanıyor (30 saniye)..." -ForegroundColor Gray
Start-Sleep -Seconds 5
Write-Host ""

# Test 3: Patient Service başlat
Write-Host "[3/5] Patient Service başlatılıyor..." -ForegroundColor Yellow
Write-Host "Terminal'de şu komutu çalıştırın:" -ForegroundColor Cyan
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\patient-service" -ForegroundColor White
Write-Host "mvn spring-boot:run" -ForegroundColor White
Write-Host ""

# Test 4: Frontend başlat
Write-Host "[4/5] Frontend başlatılıyor..." -ForegroundColor Yellow
Write-Host "Yeni terminal'de şu komutu çalıştırın:" -ForegroundColor Cyan
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\hbs-frontend" -ForegroundColor White
Write-Host "npm start" -ForegroundColor White
Write-Host ""

# Test 5: Test Senaryosu
Write-Host "[5/5] Test Senaryosu" -ForegroundColor Yellow
Write-Host ""
Write-Host "Backend servisleri başladıktan sonra:" -ForegroundColor Cyan
Write-Host "1. http://localhost:3001 adresini açın (Frontend)" -ForegroundColor White
Write-Host "2. 'Yeni Hasta' menüsüne tıklayın" -ForegroundColor White
Write-Host "3. Formu doldurun ve kaydedin" -ForegroundColor White
Write-Host "4. 'Hasta Listesi' menüsünde hastayı görün" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Monitoring URL'leri" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Frontend:      http://localhost:3001" -ForegroundColor Green
Write-Host "Patient API:   http://localhost:8081" -ForegroundColor Green
Write-Host "Gateway:       http://localhost:8000" -ForegroundColor Green
Write-Host "Kafka UI:      http://localhost:8090" -ForegroundColor Green
Write-Host "Grafana:       http://localhost:3000 (admin/admin)" -ForegroundColor Green
Write-Host "Jaeger:        http://localhost:16686" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Manuel Test (PowerShell)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "`$body = @{" -ForegroundColor Gray
Write-Host "    nationalId = '12345678901'" -ForegroundColor Gray
Write-Host "    name = 'Ahmet'" -ForegroundColor Gray
Write-Host "    surname = 'Yılmaz'" -ForegroundColor Gray
Write-Host "    birthDate = '1990-05-15'" -ForegroundColor Gray
Write-Host "    gender = 'MALE'" -ForegroundColor Gray
Write-Host "    phone = '+905551234567'" -ForegroundColor Gray
Write-Host "    city = 'İstanbul'" -ForegroundColor Gray
Write-Host "} | ConvertTo-Json" -ForegroundColor Gray
Write-Host ""
Write-Host "Invoke-RestMethod -Method Post ``" -ForegroundColor Gray
Write-Host "  -Uri 'http://localhost:8081/api/patient' ``" -ForegroundColor Gray
Write-Host "  -ContentType 'application/json' ``" -ForegroundColor Gray
Write-Host "  -Body `$body" -ForegroundColor Gray
Write-Host ""

Write-Host "🚀 Başarılar!" -ForegroundColor Green

