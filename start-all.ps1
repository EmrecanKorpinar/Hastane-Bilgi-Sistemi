# HBS - Complete Startup Script
# Maven + Docker + Backend + Frontend

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HBS - Tam Başlatma Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Maven Kontrolü ve Kurulumu
Write-Host "[1/5] Maven kontrolü..." -ForegroundColor Yellow
$mavenHome = "$env:USERPROFILE\maven\apache-maven-3.9.6"
$mavenBin = "$mavenHome\bin\mvn.cmd"

if (!(Test-Path $mavenBin)) {
    Write-Host "  Maven bulunamadı, kuruluyor..." -ForegroundColor Yellow
    $mavenVersion = "3.9.6"
    $installPath = "$env:USERPROFILE\maven"
    $downloadUrl = "https://archive.apache.org/dist/maven/maven-3/$mavenVersion/binaries/apache-maven-$mavenVersion-bin.zip"
    $zipFile = "$env:TEMP\maven.zip"

    if (!(Test-Path $installPath)) {
        New-Item -ItemType Directory -Path $installPath -Force | Out-Null
    }

    Write-Host "  Maven indiriliyor..." -ForegroundColor Gray
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing

    Write-Host "  Maven çıkartılıyor..." -ForegroundColor Gray
    Expand-Archive -Path $zipFile -DestinationPath $installPath -Force
    Remove-Item $zipFile -Force

    Write-Host "  ✓ Maven kuruldu: $mavenHome" -ForegroundColor Green
} else {
    Write-Host "  ✓ Maven zaten kurulu: $mavenHome" -ForegroundColor Green
}

# Maven PATH'e ekle
$env:MAVEN_HOME = $mavenHome
$env:Path = "$env:Path;$mavenHome\bin"

# Maven versiyonu
Write-Host ""
& $mavenBin --version
Write-Host ""

# 2. Docker Kontrolü
Write-Host "[2/5] Docker kontrolü..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Docker hazır: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Docker çalışmıyor, başlatılıyor..." -ForegroundColor Yellow
        Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
        Write-Host "  Docker Desktop başlatıldı, 30 saniye bekleniyor..." -ForegroundColor Gray
        Start-Sleep -Seconds 30
    }
} catch {
    Write-Host "  ✗ Docker bulunamadı!" -ForegroundColor Red
    Write-Host "  Docker Desktop'ı manuel başlatın" -ForegroundColor Yellow
}

# 3. Docker Infrastructure
Write-Host ""
Write-Host "[3/5] Docker Infrastructure başlatılıyor..." -ForegroundColor Yellow
Set-Location "C:\Users\90551\IdeaProjects\HBS\infra"

docker-compose -f docker-compose.dev.yml up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Infrastructure başlatıldı" -ForegroundColor Green
    Write-Host "    - PostgreSQL: localhost:5432" -ForegroundColor Gray
    Write-Host "    - Kafka: localhost:9092" -ForegroundColor Gray
    Write-Host "    - Redis: localhost:6379" -ForegroundColor Gray
    Write-Host "    - Keycloak: http://localhost:8080" -ForegroundColor Gray
} else {
    Write-Host "  ⚠ Docker Infrastructure başlatılamadı" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Infrastructure hazırlanıyor (30 saniye)..." -ForegroundColor Gray
Start-Sleep -Seconds 30

# 4. Common Module Build
Write-Host ""
Write-Host "[4/5] Common module build ediliyor..." -ForegroundColor Yellow
Set-Location "C:\Users\90551\IdeaProjects\HBS\common"

& $mavenBin clean install -DskipTests

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Common module build edildi" -ForegroundColor Green
} else {
    Write-Host "  ✗ Common module build HATASI!" -ForegroundColor Red
}

# 5. Frontend Kontrolü
Write-Host ""
Write-Host "[5/5] Frontend kontrolü..." -ForegroundColor Yellow
$frontendPort = netstat -ano | findstr :3001
if ($frontendPort) {
    Write-Host "  ✓ Frontend zaten çalışıyor (port 3001)" -ForegroundColor Green
} else {
    Write-Host "  Frontend başlatılıyor..." -ForegroundColor Yellow
    Set-Location "C:\Users\90551\IdeaProjects\HBS\hbs-frontend"
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm start"
    Write-Host "  ✓ Frontend başlatıldı (yeni pencere)" -ForegroundColor Green
}

# Özet
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HAZIR!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Frontend:" -ForegroundColor Yellow
Write-Host "  🌐 http://localhost:3001" -ForegroundColor White
Write-Host ""

Write-Host "Backend (IntelliJ IDEA ile başlatın):" -ForegroundColor Yellow
Write-Host "  1. Patient Service (port 8081)" -ForegroundColor White
Write-Host "  2. Gateway (port 8000 - opsiyonel)" -ForegroundColor White
Write-Host ""

Write-Host "IntelliJ IDEA'da:" -ForegroundColor Yellow
Write-Host "  Maven → patient-service → Lifecycle → spring-boot:run" -ForegroundColor White
Write-Host ""

Write-Host "Infrastructure:" -ForegroundColor Yellow
Write-Host "  📊 Kafka UI: http://localhost:8090" -ForegroundColor White
Write-Host "  📈 Grafana: http://localhost:3000 (admin/admin)" -ForegroundColor White
Write-Host "  🔍 Jaeger: http://localhost:16686" -ForegroundColor White
Write-Host ""

Write-Host "Maven kurulu: $mavenHome" -ForegroundColor Gray
Write-Host ""

