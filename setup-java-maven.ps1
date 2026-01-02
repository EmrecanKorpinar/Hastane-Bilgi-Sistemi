# HBS - Java ve Maven Kurulum Script
# PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Java ve Maven Kurulum" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kullanıcı dizini
$installRoot = "$env:USERPROFILE\hbs-tools"
if (!(Test-Path $installRoot)) {
    New-Item -ItemType Directory -Path $installRoot -Force | Out-Null
}

# ============================================
# 1. JAVA KURULUMU (Eclipse Temurin JDK 17)
# ============================================
Write-Host "[1/2] Java 17 kurulumu..." -ForegroundColor Yellow
$javaHome = "$installRoot\jdk-17"

if (!(Test-Path "$javaHome\bin\java.exe")) {
    Write-Host "  Java indiriliyor..." -ForegroundColor Gray

    # Eclipse Temurin JDK 17 (Windows x64)
    $javaUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.9_9.zip"
    $javaZip = "$env:TEMP\openjdk17.zip"

    try {
        Invoke-WebRequest -Uri $javaUrl -OutFile $javaZip -UseBasicParsing
        Write-Host "  Java cikartiliyor..." -ForegroundColor Gray
        Expand-Archive -Path $javaZip -DestinationPath $installRoot -Force

        # Klasör adını düzelt
        $extractedDir = Get-ChildItem -Path $installRoot -Directory | Where-Object { $_.Name -like "jdk-17*" } | Select-Object -First 1
        if ($extractedDir) {
            if (Test-Path $javaHome) { Remove-Item -Path $javaHome -Recurse -Force }
            Rename-Item -Path $extractedDir.FullName -NewName "jdk-17"
        }

        Remove-Item $javaZip -Force
        Write-Host "  ✓ Java kuruldu: $javaHome" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Java kurulumu HATASI: $_" -ForegroundColor Red
        Write-Host "  Manuel kurulum için: https://adoptium.net/" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✓ Java zaten kurulu: $javaHome" -ForegroundColor Green
}

# ============================================
# 2. MAVEN KURULUMU
# ============================================
Write-Host ""
Write-Host "[2/2] Maven 3.9.6 kurulumu..." -ForegroundColor Yellow
$mavenHome = "$installRoot\apache-maven-3.9.6"
$mavenBin = "$mavenHome\bin\mvn.cmd"

if (!(Test-Path $mavenBin)) {
    Write-Host "  Maven indiriliyor..." -ForegroundColor Gray

    $mavenUrl = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
    $mavenZip = "$env:TEMP\maven.zip"

    try {
        Invoke-WebRequest -Uri $mavenUrl -OutFile $mavenZip -UseBasicParsing
        Write-Host "  Maven cikartiliyor..." -ForegroundColor Gray
        Expand-Archive -Path $mavenZip -DestinationPath $installRoot -Force
        Remove-Item $mavenZip -Force
        Write-Host "  ✓ Maven kuruldu: $mavenHome" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Maven kurulumu HATASI: $_" -ForegroundColor Red
    }
} else {
    Write-Host "  ✓ Maven zaten kurulu: $mavenHome" -ForegroundColor Green
}

# ============================================
# 3. ORTAM DEĞİŞKENLERİ (KULLANICI)
# ============================================
Write-Host ""
Write-Host "[3/4] Ortam değişkenleri ayarlanıyor..." -ForegroundColor Yellow

# JAVA_HOME
if (Test-Path "$javaHome\bin\java.exe") {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "User")
    $env:JAVA_HOME = $javaHome
    Write-Host "  ✓ JAVA_HOME = $javaHome" -ForegroundColor Green
}

# MAVEN_HOME
if (Test-Path $mavenBin) {
    [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenHome, "User")
    $env:MAVEN_HOME = $mavenHome
    Write-Host "  ✓ MAVEN_HOME = $mavenHome" -ForegroundColor Green
}

# PATH güncelle
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathsToAdd = @(
    "$javaHome\bin",
    "$mavenHome\bin"
)

foreach ($pathToAdd in $pathsToAdd) {
    if (Test-Path $pathToAdd) {
        if ($userPath -notlike "*$pathToAdd*") {
            $userPath = "$userPath;$pathToAdd"
        }
    }
}

[Environment]::SetEnvironmentVariable("Path", $userPath, "User")
Write-Host "  ✓ PATH güncellendi" -ForegroundColor Green

# Mevcut session için PATH'i güncelle
$env:Path = "$env:Path;$javaHome\bin;$mavenHome\bin"

# ============================================
# 4. VERİFICATION
# ============================================
Write-Host ""
Write-Host "[4/4] Kontrol ediliyor..." -ForegroundColor Yellow
Write-Host ""

# Java version
if (Test-Path "$javaHome\bin\java.exe") {
    Write-Host "Java Version:" -ForegroundColor Cyan
    & "$javaHome\bin\java.exe" -version
    Write-Host ""
}

# Maven version
if (Test-Path $mavenBin) {
    Write-Host "Maven Version:" -ForegroundColor Cyan
    & $mavenBin --version
    Write-Host ""
}

# ============================================
# ÖZET
# ============================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  KURULUM TAMAMLANDI!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Kurulum Konumları:" -ForegroundColor Yellow
Write-Host "  JAVA_HOME  : $javaHome" -ForegroundColor White
Write-Host "  MAVEN_HOME : $mavenHome" -ForegroundColor White
Write-Host ""

Write-Host "ÖNEMLİ:" -ForegroundColor Red
Write-Host "  1. Bu PowerShell penceresini KAPATIN" -ForegroundColor Yellow
Write-Host "  2. YENİ bir PowerShell penceresi açın" -ForegroundColor Yellow
Write-Host "  3. Şu komutları çalıştırın:" -ForegroundColor Yellow
Write-Host ""
Write-Host "     java -version" -ForegroundColor White
Write-Host "     mvn -version" -ForegroundColor White
Write-Host ""

Write-Host "Sonra backend'i başlatmak için:" -ForegroundColor Yellow
Write-Host "     cd C:\Users\90551\IdeaProjects\HBS" -ForegroundColor White
Write-Host "     .\start-all.ps1" -ForegroundColor White
Write-Host ""

# Kurulum bilgisini kaydet
$setupInfo = @"
# HBS Kurulum Bilgileri
Tarih: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

JAVA_HOME: $javaHome
MAVEN_HOME: $mavenHome
Install Root: $installRoot

Java: $(if (Test-Path "$javaHome\bin\java.exe") { "KURULDU" } else { "KURULAMADI" })
Maven: $(if (Test-Path $mavenBin) { "KURULDU" } else { "KURULAMADI" })

Test için yeni terminal açıp:
  java -version
  mvn -version
"@

$setupInfo | Out-File -FilePath "$installRoot\kurulum-bilgi.txt" -Encoding UTF8
Write-Host "Kurulum bilgileri kaydedildi: $installRoot\kurulum-bilgi.txt" -ForegroundColor Gray
Write-Host ""

