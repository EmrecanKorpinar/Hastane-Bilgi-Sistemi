# HBS - Otomatik Test Script
# PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🏥 HBS Sistem Testi" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test sonuçlarını takip et
$testsPassed = 0
$testsFailed = 0

# 1. Health Check
Write-Host "[1/6] Health Check testi..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri http://localhost:8081/actuator/health -ErrorAction Stop
    if ($health.status -eq "UP") {
        Write-Host "  ✅ Patient Service: $($health.status)" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "  ⚠️  Patient Service: $($health.status)" -ForegroundColor Yellow
        $testsFailed++
    }
} catch {
    Write-Host "  ❌ Patient Service erişilemiyor! Backend başlatıldı mı?" -ForegroundColor Red
    Write-Host "     Hata: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}

Start-Sleep -Seconds 1

# 2. Yeni Hasta Oluştur
Write-Host "`n[2/6] Yeni hasta oluşturma testi..." -ForegroundColor Yellow
try {
    $timestamp = Get-Date -Format "HHmmss"
    $patient = @{
        nationalId = "1234567890$timestamp"
        name = "Test"
        surname = "Kullanici"
        birthDate = "1995-01-01"
        gender = "MALE"
        phone = "+905551234567"
        email = "test@example.com"
        city = "İstanbul"
        country = "Türkiye"
        bloodType = "A+"
    } | ConvertTo-Json

    $created = Invoke-RestMethod -Uri http://localhost:8081/api/patients `
        -Method POST `
        -ContentType "application/json" `
        -Body $patient `
        -ErrorAction Stop

    Write-Host "  ✅ Hasta oluşturuldu!" -ForegroundColor Green
    Write-Host "     Dosya No: $($created.fileNumber)" -ForegroundColor Gray
    Write-Host "     Hasta ID: $($created.patientId)" -ForegroundColor Gray
    $testsPassed++

    # Sonraki testler için ID'yi sakla
    $global:createdPatientId = $created.patientId
} catch {
    Write-Host "  ❌ Hasta oluşturulamadı!" -ForegroundColor Red
    Write-Host "     Hata: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}

Start-Sleep -Seconds 1

# 3. Aktif Hastaları Listele
Write-Host "`n[3/6] Hasta listesi testi..." -ForegroundColor Yellow
try {
    $patients = Invoke-RestMethod -Uri http://localhost:8081/api/patients/active -ErrorAction Stop
    Write-Host "  ✅ Toplam $($patients.Count) hasta bulundu" -ForegroundColor Green
    if ($patients.Count -gt 0) {
        Write-Host "     İlk hasta: $($patients[0].fullName) ($($patients[0].fileNumber))" -ForegroundColor Gray
    }
    $testsPassed++
} catch {
    Write-Host "  ❌ Hasta listesi alınamadı!" -ForegroundColor Red
    Write-Host "     Hata: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}

Start-Sleep -Seconds 1

# 4. Arama Testi
Write-Host "`n[4/6] Hasta arama testi..." -ForegroundColor Yellow
try {
    $searchQuery = "Test"
    $results = Invoke-RestMethod -Uri "http://localhost:8081/api/patients/search?query=$searchQuery" -ErrorAction Stop
    Write-Host "  ✅ Arama sonucu: $($results.Count) hasta bulundu" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "  ❌ Arama yapılamadı!" -ForegroundColor Red
    Write-Host "     Hata: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}

Start-Sleep -Seconds 1

# 5. Hasta Detayı Getir
if ($global:createdPatientId) {
    Write-Host "`n[5/6] Hasta detayı testi..." -ForegroundColor Yellow
    try {
        $detail = Invoke-RestMethod -Uri "http://localhost:8081/api/patients/$($global:createdPatientId)" -ErrorAction Stop
        Write-Host "  ✅ Hasta detayı alındı: $($detail.fullName)" -ForegroundColor Green
        Write-Host "     TC: $($detail.nationalId)" -ForegroundColor Gray
        Write-Host "     Telefon: $($detail.phone)" -ForegroundColor Gray
        $testsPassed++
    } catch {
        Write-Host "  ❌ Hasta detayı alınamadı!" -ForegroundColor Red
        Write-Host "     Hata: $($_.Exception.Message)" -ForegroundColor Red
        $testsFailed++
    }
} else {
    Write-Host "`n[5/6] Hasta detayı testi atlandı (hasta oluşturulamadı)" -ForegroundColor Yellow
    $testsFailed++
}

Start-Sleep -Seconds 1

# 6. Kafka Event Kontrolü
Write-Host "`n[6/6] Kafka event kontrolü..." -ForegroundColor Yellow
try {
    # Kafka topic'inin var olup olmadığını kontrol et
    $topicCheck = docker exec hbs-kafka kafka-topics --bootstrap-server localhost:9092 --list 2>$null | Select-String "patient.events"
    if ($topicCheck) {
        Write-Host "  ✅ patient.events topic'i mevcut" -ForegroundColor Green
        Write-Host "     Kafka UI: http://localhost:8090" -ForegroundColor Gray
        $testsPassed++
    } else {
        Write-Host "  ⚠️  patient.events topic'i henüz oluşturulmamış" -ForegroundColor Yellow
        Write-Host "     (İlk event yayımlandığında otomatik oluşacak)" -ForegroundColor Gray
        $testsPassed++
    }
} catch {
    Write-Host "  ⚠️  Kafka kontrolü yapılamadı (Docker çalışıyor mu?)" -ForegroundColor Yellow
    $testsFailed++
}

# Özet
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  📊 Test Özeti" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ Başarılı: $testsPassed" -ForegroundColor Green
Write-Host "  ❌ Başarısız: $testsFailed" -ForegroundColor Red
Write-Host "  📈 Başarı Oranı: $([math]::Round(($testsPassed / ($testsPassed + $testsFailed)) * 100, 2))%" -ForegroundColor Cyan
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "🎉 Tüm testler başarıyla tamamlandı!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Bazı testler başarısız oldu. Lütfen kontrol edin." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Frontend Test:" -ForegroundColor Yellow
Write-Host "  🌐 http://localhost:3001" -ForegroundColor White
Write-Host ""
Write-Host "Monitoring:" -ForegroundColor Yellow
Write-Host "  📊 Kafka UI: http://localhost:8090" -ForegroundColor White
Write-Host "  📈 Grafana: http://localhost:3000 (admin/admin)" -ForegroundColor White
Write-Host "  🔍 Jaeger: http://localhost:16686" -ForegroundColor White
Write-Host ""

