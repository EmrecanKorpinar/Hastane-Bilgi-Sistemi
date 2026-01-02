# 🔧 Java ve Maven Kurulum Kılavuzu

## ⚠️ SORUN TESPİTİ

**Problem**: Java ve Maven terminalde bulunamıyor
**Neden**: Ortam değişkenleri (Environment Variables) ayarlanmamış

## ✅ ÇÖZÜM: Otomatik Kurulum

### Adım 1: Kurulum Script'ini Çalıştırın

```powershell
cd C:\Users\90551\IdeaProjects\HBS
.\setup-java-maven.ps1
```

Bu script:
- ✅ Java 17 (Eclipse Temurin) indirir ve kurar
- ✅ Maven 3.9.6 indirir ve kurar
- ✅ JAVA_HOME ortam değişkenini ayarlar
- ✅ MAVEN_HOME ortam değişkenini ayarlar
- ✅ PATH'e ekler
- ✅ Versiyonları test eder

**Kurulum Konumu**: `C:\Users\90551\hbs-tools\`

### Adım 2: YENİ Terminal Açın

**ÖNEMLİ**: Ortam değişkenleri için mevcut terminal'i KAPATIN ve YENİ bir PowerShell açın!

### Adım 3: Test Edin

```powershell
java -version
```
**Beklenen Çıktı**:
```
openjdk version "17.0.9" 2023-10-17
OpenJDK Runtime Environment Temurin-17.0.9+9 (build 17.0.9+9)
OpenJDK 64-Bit Server VM Temurin-17.0.9+9 (build 17.0.9+9, mixed mode, sharing)
```

```powershell
mvn -version
```
**Beklenen Çıktı**:
```
Apache Maven 3.9.6
Maven home: C:\Users\90551\hbs-tools\apache-maven-3.9.6
Java version: 17.0.9, vendor: Eclipse Adoptium
```

---

## 🔄 Manuel Kurulum (Eğer Script Çalışmazsa)

### 1. Java 17 Manuel Kurulum

#### Adım 1: İndir
```
https://adoptium.net/temurin/releases/?version=17
```
- **Version**: 17 (LTS)
- **Operating System**: Windows
- **Architecture**: x64
- **Package Type**: JDK
- **Format**: .zip (installer değil!)

#### Adım 2: Çıkart
```
C:\Users\90551\hbs-tools\jdk-17\
```

#### Adım 3: Ortam Değişkenleri Ayarla

**JAVA_HOME oluştur**:
```powershell
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Users\90551\hbs-tools\jdk-17", "User")
```

**PATH'e ekle**:
```powershell
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$userPath = "$userPath;C:\Users\90551\hbs-tools\jdk-17\bin"
[Environment]::SetEnvironmentVariable("Path", $userPath, "User")
```

### 2. Maven 3.9.6 Manuel Kurulum

#### Adım 1: İndir
```
https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip
```

#### Adım 2: Çıkart
```
C:\Users\90551\hbs-tools\apache-maven-3.9.6\
```

#### Adım 3: Ortam Değişkenleri Ayarla

**MAVEN_HOME oluştur**:
```powershell
[Environment]::SetEnvironmentVariable("MAVEN_HOME", "C:\Users\90551\hbs-tools\apache-maven-3.9.6", "User")
```

**PATH'e ekle**:
```powershell
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$userPath = "$userPath;C:\Users\90551\hbs-tools\apache-maven-3.9.6\bin"
[Environment]::SetEnvironmentVariable("Path", $userPath, "User")
```

---

## 🧪 Doğrulama

### Test Komutları

```powershell
# Yeni PowerShell açın!

# Java kontrolü
java -version
javac -version

# Maven kontrolü
mvn -version

# JAVA_HOME kontrolü
echo $env:JAVA_HOME

# MAVEN_HOME kontrolü
echo $env:MAVEN_HOME

# PATH kontrolü
echo $env:Path | Select-String "java"
echo $env:Path | Select-String "maven"
```

---

## 🚀 Backend Başlatma (Java ve Maven Hazır Olunca)

### Seçenek 1: IntelliJ IDEA (Önerilen)

```
1. IntelliJ IDEA'yı açın
2. Project'i açın: C:\Users\90551\IdeaProjects\HBS
3. Maven paneli → common → Lifecycle → install
4. patient-service → PatientServiceApplication.java → Run
5. Console'da "Started PatientServiceApplication" görün
```

### Seçenek 2: Terminal (Maven ile)

```powershell
# 1. Common module build
cd C:\Users\90551\IdeaProjects\HBS\common
mvn clean install -DskipTests

# 2. Patient Service build ve çalıştır
cd C:\Users\90551\IdeaProjects\HBS\patient-service
mvn spring-boot:run
```

**Başarı Mesajı**:
```
Started PatientServiceApplication in 15.234 seconds (JVM running for 16.5)
```

### Seçenek 3: start-all.ps1 Script

```powershell
cd C:\Users\90551\IdeaProjects\HBS
.\start-all.ps1
```

Bu script otomatik olarak:
- ✅ Maven'i kontrol eder
- ✅ Docker'ı başlatır
- ✅ Infrastructure'ı ayağa kaldırır
- ✅ Common module'ü build eder
- ✅ Frontend'i kontrol eder

---

## 📊 Kurulum Kontrolü

| Öğe | Konum | Test Komutu |
|-----|-------|-------------|
| **Java** | `C:\Users\90551\hbs-tools\jdk-17` | `java -version` |
| **Maven** | `C:\Users\90551\hbs-tools\apache-maven-3.9.6` | `mvn -version` |
| **JAVA_HOME** | User Environment Variable | `echo $env:JAVA_HOME` |
| **MAVEN_HOME** | User Environment Variable | `echo $env:MAVEN_HOME` |
| **PATH** | Includes java/bin and maven/bin | `echo $env:Path` |

---

## 🐛 Sorun Giderme

### "java komutu bulunamıyor"

**Neden**: PATH'te yok veya terminal eski

**Çözüm**:
```powershell
# 1. Terminal'i KAPATIN
# 2. YENİ PowerShell açın
# 3. Test edin
java -version
```

Hala çalışmazsa:
```powershell
# Manuel PATH ekle (geçici)
$env:Path = "$env:Path;C:\Users\90551\hbs-tools\jdk-17\bin"
java -version
```

### "mvn komutu bulunamıyor"

**Çözüm**:
```powershell
# Manuel PATH ekle (geçici)
$env:Path = "$env:Path;C:\Users\90551\hbs-tools\apache-maven-3.9.6\bin"
mvn -version
```

### "JAVA_HOME tanımlı değil"

**Çözüm**:
```powershell
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Users\90551\hbs-tools\jdk-17", "User")

# Yeni terminal açın ve test edin
echo $env:JAVA_HOME
```

### Script çalışmıyor

**Execution Policy Hatası**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Sonra tekrar:
```powershell
.\setup-java-maven.ps1
```

---

## 📝 Hızlı Kurulum Özeti

```powershell
# 1. Kurulum script'ini çalıştır
cd C:\Users\90551\IdeaProjects\HBS
.\setup-java-maven.ps1

# 2. YENİ PowerShell aç

# 3. Test et
java -version
mvn -version

# 4. Backend başlat (IntelliJ veya terminal)
cd C:\Users\90551\IdeaProjects\HBS\common
mvn clean install

cd C:\Users\90551\IdeaProjects\HBS\patient-service
mvn spring-boot:run

# 5. Frontend'i test et
# Tarayıcı: http://localhost:3001
```

---

## ✅ Başarı Kriterleri

Kurulum başarılıysa:

```powershell
PS> java -version
openjdk version "17.0.9" ...

PS> mvn -version
Apache Maven 3.9.6 ...

PS> echo $env:JAVA_HOME
C:\Users\90551\hbs-tools\jdk-17

PS> echo $env:MAVEN_HOME
C:\Users\90551\hbs-tools\apache-maven-3.9.6
```

---

## 🎯 Sonraki Adımlar

1. ✅ Java ve Maven kurulumu
2. ✅ Ortam değişkenleri ayarlandı
3. ⏳ Docker Infrastructure başlat
4. ⏳ Common module build et
5. ⏳ Patient Service çalıştır
6. ✅ Frontend test et (http://localhost:3001)

---

**Kurulum tamamlandıktan sonra**: `SISTEM_HAZIR.md` dökümanına geri dönün ve backend başlatma adımlarını takip edin!

*Oluşturulma: 2026-01-02*

