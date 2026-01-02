# 🚀 HBS - GitHub'a Push Komutları

## ⚡ HIZLI BAŞLATMA

### 1. GitHub'da Repository Oluşturun (Tarayıcıda)

**Link**: https://github.com/new

**Ayarlar**:
- Repository name: **Hastane-Bilgi-Sistemi**
- Description: **Profesyonel Hastane Bilgi Sistemi - Microservices + Event-Driven + DDD + React + shadcn/ui**
- Visibility: **Public** (veya Private)
- ❌ **README, .gitignore, license eklemeden** oluşturun

### 2. Push Komutları (PowerShell)

Repository oluşturduktan sonra bu komutları çalıştırın:

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# Remote ekle (GitHub'dan aldığınız URL ile)
git remote add origin https://github.com/<KULLANICI_ADINIZ>/Hastane-Bilgi-Sistemi.git

# Branch adını main yap
git branch -M main

# Push et
git push -u origin main
```

### 3. GitHub Kimlik Doğrulama

Push sırasında şunlar istenecek:
- **Username**: GitHub kullanıcı adınız
- **Password**: ❌ Şifre değil! → Personal Access Token

---

## 🔑 Personal Access Token Oluşturma

### Adımlar:

1. **GitHub → Settings** (sağ üst profil resmi)
2. **Developer settings** (sol menüde en altta)
3. **Personal access tokens** → **Tokens (classic)**
4. **Generate new token** → **Generate new token (classic)**
5. **Ayarlar**:
   - Note: `HBS Project Push`
   - Expiration: `No expiration` (veya 90 days)
   - Scopes: ✅ **repo** (tümünü seç)
6. **Generate token** (yeşil buton)
7. **Token'ı KOPYALAYIN** ⚠️ Bir daha gösterilmeyecek!

### Token'ı Push'ta Kullanma:

```
Username: <GitHub_kullanıcı_adınız>
Password: <Kopyaladığınız_Personal_Access_Token>
```

---

## 📋 Örnek Komutlar (Kendi bilgilerinizle değiştirin)

### Örnek 1: HTTPS ile Push

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# Kendi kullanıcı adınızı yazın:
git remote add origin https://github.com/ahmetyilmaz/Hastane-Bilgi-Sistemi.git

git branch -M main

git push -u origin main

# Kullanıcı adı: ahmetyilmaz
# Şifre: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx (Token)
```

### Örnek 2: SSH ile Push (Daha güvenli)

```powershell
# SSH key oluştur
ssh-keygen -t ed25519 -C "email@example.com"

# Public key'i kopyala
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | clip

# GitHub → Settings → SSH Keys → New SSH Key → Yapıştır

# Remote ekle
git remote add origin git@github.com:ahmetyilmaz/Hastane-Bilgi-Sistemi.git

git push -u origin main
```

---

## 🔧 Sorun Giderme

### Hata: "remote origin already exists"

```powershell
# Mevcut remote'u sil
git remote remove origin

# Yeniden ekle
git remote add origin https://github.com/<KULLANICI_ADINIZ>/Hastane-Bilgi-Sistemi.git
```

### Hata: "Support for password authentication was removed"

✅ **Çözüm**: Şifre yerine **Personal Access Token** kullanın (yukarıda anlatıldı)

### Hata: "failed to push some refs"

```powershell
# Uzak repo'da dosya varsa birleştir:
git pull origin main --allow-unrelated-histories

# Sonra tekrar push:
git push -u origin main
```

### Commit hala devam ediyorsa

```powershell
# Commit durumunu kontrol et
git status

# Commit logunu gör
git log --oneline -5

# Eğer commit edilmemişse:
git add .
git commit -m "feat: Hastane Bilgi Sistemi - Complete"
```

---

## ✅ Push Başarılı Olunca

### GitHub'da görecekleriniz:

- ✅ README.md otomatik gösterilir
- ✅ Tüm dosyalar listelenecek
- ✅ Commit mesajınız görünecek

### Repository URL'niz:
```
https://github.com/<KULLANICI_ADINIZ>/Hastane-Bilgi-Sistemi
```

---

## 📊 Repository İçeriği

Push sonrası GitHub'da göreceğiniz dosyalar:

```
Hastane-Bilgi-Sistemi/
├── 📁 common/               # Shared modules
├── 📁 patient-service/      # Patient microservice
├── 📁 gateway/              # API Gateway
├── 📁 hbs-frontend/         # React + shadcn/ui
├── 📁 infra/                # Docker Compose
├── 📁 docs/                 # Documentation
├── 📄 README.md             ⭐ Ana döküman
├── 📄 pom.xml               # Maven parent
├── 📄 .gitignore
└── 📄 *.ps1                 # Scripts
```

---

## 🎯 Son Kontrol Listesi

Push etmeden önce:

- [ ] GitHub'da repo oluşturdunuz mu?
- [ ] Personal Access Token aldınız mı?
- [ ] `git remote add origin ...` çalıştırdınız mı?
- [ ] `git push -u origin main` hazır mı?

---

## 💡 İpuçları

### Node Modules'i .gitignore'a Ekleyin

node_modules çok büyük. Push'tan sonra:

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# .gitignore'a ekle
Add-Content .gitignore "`n# Node.js`nhbs-frontend/node_modules/"

# Git'ten kaldır
git rm -r --cached hbs-frontend/node_modules

# Commit ve push
git add .gitignore
git commit -m "chore: Remove node_modules from git tracking"
git push
```

### Repository'yi Clone Etmek İsterseniz:

```powershell
git clone https://github.com/<KULLANICI_ADINIZ>/Hastane-Bilgi-Sistemi.git
cd Hastane-Bilgi-Sistemi
```

---

## 🌟 Proje Özellikleri (GitHub README'de gösterilecek)

✅ **Microservices Architecture**
- Spring Boot 3.x
- PostgreSQL, Redis, Kafka
- API Gateway

✅ **Modern Frontend**
- React 18 + TypeScript
- Tailwind CSS 3.3
- shadcn/ui components

✅ **Event-Driven Design**
- Kafka event streaming
- Domain events
- CQRS ready

✅ **Infrastructure**
- Docker Compose
- Prometheus + Grafana
- Jaeger tracing

✅ **Complete Documentation**
- Setup guides
- Testing guides
- Architecture docs

---

**Hazırlayan**: GitHub Copilot  
**Tarih**: 2026-01-02  
**Proje**: HBS - Hastane Bilgi Sistemi

---

## 📞 Sonraki Adımlar

Push sonrası:
1. ✅ README.md GitHub'da gösterilecek
2. ✅ Issues/Projects kullanabilirsiniz
3. ✅ GitHub Actions CI/CD ekleyebilirsiniz
4. ✅ Collaborators ekleyebilirsiniz

**İyi çalışmalar!** 🚀

