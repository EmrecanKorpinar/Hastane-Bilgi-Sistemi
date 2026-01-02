# HBS - Complete Test Guide
# Tüm servisleri başlatma ve test etme kılavuzu

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🏥 HBS - Test Kılavuzu" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 Gereksinimler:" -ForegroundColor Yellow
Write-Host "  ✓ Docker Desktop (çalışır durumda)" -ForegroundColor White
Write-Host "  ✓ Java 17+" -ForegroundColor White
Write-Host "  ✓ Maven 3.8+" -ForegroundColor White
Write-Host "  ✓ Node.js 18+" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  📦 ADIM 1: Infrastructure" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Şu komutu çalıştırın:" -ForegroundColor Yellow
Write-Host ""
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\infra" -ForegroundColor White
Write-Host "docker-compose -f docker-compose.dev.yml up -d" -ForegroundColor White
Write-Host ""
Write-Host "Servisler hazırlanırken 30-60 saniye bekleyin..." -ForegroundColor Gray
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🔧 ADIM 2: Backend Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "2.1. Common Module Build:" -ForegroundColor Yellow
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\common" -ForegroundColor White
Write-Host "mvn clean install -DskipTests" -ForegroundColor White
Write-Host ""

Write-Host "2.2. Patient Service Başlat (YENİ TERMINAL):" -ForegroundColor Yellow
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\patient-service" -ForegroundColor White
Write-Host "mvn spring-boot:run" -ForegroundColor White
Write-Host ""
Write-Host "✓ Patient Service: http://localhost:8081" -ForegroundColor Green
Write-Host ""

Write-Host "2.3. Gateway Başlat (YENİ TERMINAL - Opsiyonel):" -ForegroundColor Yellow
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\gateway" -ForegroundColor White
Write-Host "mvn spring-boot:run" -ForegroundColor White
Write-Host ""
Write-Host "✓ Gateway: http://localhost:8000" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🎨 ADIM 3: Frontend" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "3.1. Dependencies Kur (İlk kez):" -ForegroundColor Yellow
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\hbs-frontend" -ForegroundColor White
Write-Host "npm install" -ForegroundColor White
Write-Host ""

Write-Host "3.2. Frontend Başlat (YENİ TERMINAL):" -ForegroundColor Yellow
Write-Host "cd C:\Users\90551\IdeaProjects\HBS\hbs-frontend" -ForegroundColor White
Write-Host "npm start" -ForegroundColor White
Write-Host ""
Write-Host "✓ Frontend: http://localhost:3001" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🧪 ADIM 4: Test Senaryoları" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "TEST 1: Backend API Testi (PowerShell)" -ForegroundColor Yellow
Write-Host ""
Write-Host "`$body = @{" -ForegroundColor Gray
Write-Host "    nationalId = '12345678901'" -ForegroundColor Gray
Write-Host "    name = 'Ahmet'" -ForegroundColor Gray
Write-Host "    surname = 'Yılmaz'" -ForegroundColor Gray
Write-Host "    birthDate = '1990-05-15'" -ForegroundColor Gray
Write-Host "    gender = 'MALE'" -ForegroundColor Gray
Write-Host "    phone = '+905551234567'" -ForegroundColor Gray
Write-Host "    email = 'ahmet@example.com'" -ForegroundColor Gray
Write-Host "    city = 'İstanbul'" -ForegroundColor Gray
Write-Host "    bloodType = 'A+'" -ForegroundColor Gray
Write-Host "} | ConvertTo-Json" -ForegroundColor Gray
Write-Host ""
Write-Host "Invoke-RestMethod -Method Post ``" -ForegroundColor Gray
Write-Host "  -Uri 'http://localhost:8081/api/patient' ``" -ForegroundColor Gray
Write-Host "  -ContentType 'application/json' ``" -ForegroundColor Gray
Write-Host "  -Body `$body" -ForegroundColor Gray
Write-Host ""

Write-Host "TEST 2: Frontend UI Testi" -ForegroundColor Yellow
Write-Host "1. http://localhost:3001 açın" -ForegroundColor White
Write-Host "2. 'Yeni Hasta' menüsüne tıklayın" -ForegroundColor White
Write-Host "3. Formu doldurun ve kaydedin" -ForegroundColor White
Write-Host "4. 'Hasta Listesi'nde hastayı görün" -ForegroundColor White
Write-Host ""

Write-Host "TEST 3: Kafka Event Kontrolü" -ForegroundColor Yellow
Write-Host "http://localhost:8090 → Topics → patient.registered" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  📊 Monitoring URLs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Frontend:       http://localhost:3001" -ForegroundColor Green
Write-Host "Patient API:    http://localhost:8081" -ForegroundColor Green
Write-Host "Gateway:        http://localhost:8000" -ForegroundColor Green
Write-Host "Kafka UI:       http://localhost:8090" -ForegroundColor Green
Write-Host "Grafana:        http://localhost:3000 (admin/admin)" -ForegroundColor Green
Write-Host "Jaeger:         http://localhost:16686" -ForegroundColor Green
Write-Host "Keycloak:       http://localhost:8080 (admin/admin)" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  📁 Önemli Dosyalar" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend:  docs/QUICK_START.md" -ForegroundColor White
Write-Host "Frontend: docs/FRONTEND_GUIDE.md" -ForegroundColor White
Write-Host "Mimari:   docs/ADR.md" -ForegroundColor White
Write-Host "Context:  docs/CONTEXT_MAP.md" -ForegroundColor White
Write-Host ""

Write-Host "🎉 Başarılar! Sorularınız için dokümantasyona bakın." -ForegroundColor Green
Write-Host ""

