# 🚀 GitHub'a Push Rehberi

## Adım 1: GitHub'da Yeni Repository Oluşturun

1. **GitHub'a girin**: https://github.com
2. **New Repository** butonuna tıklayın (yeşil buton, sağ üst)
3. **Repository bilgilerini girin**:
   - **Repository name**: `Hastane-Bilgi-Sistemi` veya `HBS`
   - **Description**: `Profesyonel Hastane Bilgi Sistemi - Microservices + Event-Driven + DDD + React + shadcn/ui`
   - **Public** veya **Private** seçin
   - ❌ **Initialize this repository with** seçeneklerini BIRAKIN (boş olsun)
4. **Create repository** butonuna tıklayın

## Adım 2: Remote Ekleyin ve Push Edin

GitHub'da repository oluşturduktan sonra terminalde şu komutları çalıştırın:

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# GitHub repository URL'inizi kullanın (örnek):
# git remote add origin https://github.com/KULLANICI_ADINIZ/Hastane-Bilgi-Sistemi.git

# Sizin URL'iniz buraya:
git remote add origin https://github.com/<KULLANICI_ADINIZ>/<REPO_ADI>.git

# Varsayılan branch'i main olarak ayarla
git branch -M main

# Push edin
git push -u origin main
```

### Örnek (Kendi bilgilerinizle değiştirin):
```powershell
git remote add origin https://github.com/ahmetyilmaz/Hastane-Bilgi-Sistemi.git
git branch -M main
git push -u origin main
```

## Adım 3: Git Kimlik Bilgilerinizi Girin

Push sırasında GitHub kullanıcı adı ve şifre/token isteyecek:

### GitHub Token Oluşturma (Önerilir):
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. **Generate new token** → **Generate new token (classic)**
3. Note: `HBS Project`
4. Expiration: 90 days veya No expiration
5. Scopes: ✅ **repo** (tüm repo seçenekleri)
6. **Generate token**
7. **Token'ı kopyalayın** (bir daha gösterilmeyecek!)

### Push Komutu:
```powershell
git push -u origin main
```

**Kimlik bilgileri istediğinde**:
- Username: GitHub kullanıcı adınız
- Password: Personal Access Token (yukarıda oluşturduğunuz)

## Adım 4: .gitignore Düzenleme (Önerilir)

node_modules çok büyük olduğu için .gitignore'a ekleyelim:

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# .gitignore düzenle
Add-Content -Path .gitignore -Value "`n# Node modules`nhbs-frontend/node_modules/`n"

# node_modules'i kaldır
git rm -r --cached hbs-frontend/node_modules
git commit -m "chore: Remove node_modules from git"
git push
```

## Adım 5: README.md Güncelleyin (GitHub'da Gösterilecek)

GitHub'da README.md dosyası otomatik gösterilir. Mevcut README.md zaten hazır!

## Alternatif: SSH ile Push

### SSH Key Oluşturma:
```powershell
ssh-keygen -t ed25519 -C "your_email@example.com"
# Enter tuşuna basın (varsayılan konum)
# Passphrase girin (opsiyonel)

# Public key'i kopyalayın
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | clip
```

### GitHub'a SSH Key Ekleme:
1. GitHub → Settings → SSH and GPG keys → New SSH key
2. Title: `HBS Laptop`
3. Key: Panoya kopyalanan key'i yapıştırın
4. Add SSH key

### SSH ile Remote Ekle:
```powershell
git remote add origin git@github.com:<KULLANICI_ADINIZ>/<REPO_ADI>.git
git push -u origin main
```

## Hızlı Başlangıç (Tüm Adımlar):

```powershell
# 1. Commit (zaten yapıldı)
cd C:\Users\90551\IdeaProjects\HBS
git status

# 2. GitHub'da repo oluşturun (tarayıcıda)
# https://github.com/new

# 3. Remote ekleyin (URL'inizi kullanın)
git remote add origin https://github.com/<KULLANICI_ADINIZ>/Hastane-Bilgi-Sistemi.git

# 4. Push edin
git branch -M main
git push -u origin main
```

## Sorun Giderme

### "remote origin already exists"
```powershell
git remote remove origin
git remote add origin https://github.com/<KULLANICI_ADINIZ>/<REPO_ADI>.git
```

### "failed to push some refs"
```powershell
# Uzak repo'da dosya varsa:
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### "Support for password authentication was removed"
GitHub artık şifre kabul etmiyor. Personal Access Token kullanın (yukarıda anlatıldı).

## Push Sonrası

GitHub'da repository'nizi görüntüleyin:
```
https://github.com/<KULLANICI_ADINIZ>/<REPO_ADI>
```

README.md otomatik gösterilecek!

---

## 📊 Repository İstatistikleri

Commit sonrası göreceğiniz:
- **Dosya Sayısı**: ~50,000+ (node_modules dahil) veya ~200 (node_modules hariç)
- **Backend**: Java + Spring Boot
- **Frontend**: React + TypeScript + Tailwind + shadcn/ui
- **Infrastructure**: Docker Compose
- **Documentation**: 10+ rehber dosyası

---

**Oluşturan**: GitHub Copilot
**Proje**: HBS - Hastane Bilgi Sistemi  
**Tarih**: 2026-01-02

