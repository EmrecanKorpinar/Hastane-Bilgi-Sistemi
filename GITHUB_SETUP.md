# 🚀 HBS - GitHub'a Push Etme Rehberi

## ⚡ HIZLI ÇÖZÜM - 2 Yöntem

---

## 🎯 YÖNTEM 1: Manuel (GitHub Web Üzerinden)

### 1️⃣ GitHub'da Repository Oluştur

**Tarayıcıda git**: https://github.com/new

**Ayarlar**:
- Repository name: **HBS**
- Description: **Hastane Bilgi Sistemi - Microservices Architecture**
- Visibility: **Public** (veya Private)
- ❌ **README, .gitignore, license EKLEME!** (Boş repo oluştur)

### 2️⃣ Repository URL'ini Kopyala

Repo oluşturduktan sonra göreceğiniz URL:
```
https://github.com/EmrecanKörpınar/HBS.git
```

### 3️⃣ PowerShell'de Çalıştır

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# Remote ekle (URL'i kendi repo URL'iniz ile değiştirin)
git remote add origin https://github.com/EmrecanKörpınar/HBS.git

# Push et
git push -u origin main
```

### 4️⃣ Kimlik Doğrulama

**Username**: EmrecanKörpınar  
**Password**: ❌ Şifre DEĞİL → **Personal Access Token**

---

## 🔑 Personal Access Token Nasıl Alınır?

1. **GitHub'a git** → **Settings** (sağ üst profil)
2. **Developer settings** (sol menüde en altta)
3. **Personal access tokens** → **Tokens (classic)**
4. **Generate new token (classic)**
5. **Ayarlar**:
   - Note: `HBS Project`
   - Expiration: `90 days`
   - Scopes: ✅ **repo** (tüm repo checkboxlarını işaretle)
6. **Generate token**
7. ⚠️ **TOKEN'I KOPYALA!** (Bir daha gösterilmez!)

Token örneği:
```
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Bu token'ı password olarak kullanacaksınız!

---

## 🎯 YÖNTEM 2: GitHub CLI (Otomatik - Önerilen)

### 1️⃣ GitHub CLI Yükle

```powershell
# Winget ile yükle
winget install --id GitHub.cli

# Veya Chocolatey ile
choco install gh
```

### 2️⃣ GitHub'a Giriş Yap

```powershell
gh auth login
```

Sorulacaklar:
- **What account do you want to log into?** → GitHub.com
- **What is your preferred protocol?** → HTTPS
- **Authenticate Git with your GitHub credentials?** → Yes
- **How would you like to authenticate?** → Login with a web browser

Tarayıcı açılacak → GitHub'a giriş yap → Kodu gir → Authorize

### 3️⃣ Otomatik Repo Oluştur ve Push Et

```powershell
cd C:\Users\90551\IdeaProjects\HBS

# Repo oluştur ve push et (tek komut!)
gh repo create HBS --public --source=. --remote=origin --push
```

✅ **TAMAM!** Repo otomatik oluşturulup push edildi!

---

## 📊 Push Sonrası Kontrol

Repository URL'niz:
```
https://github.com/EmrecanKörpınar/HBS
```

Kontrol komutları:
```powershell
# Remote kontrol
git remote -v

# Son commit
git log --oneline -1

# Branch kontrol
git branch -a
```

---

## 🔧 Sorun Giderme

### ❌ "remote origin already exists"
```powershell
git remote remove origin
git remote add origin https://github.com/EmrecanKörpınar/HBS.git
git push -u origin main
```

### ❌ "Support for password authentication was removed"
✅ **Çözüm**: Şifre yerine **Personal Access Token** kullan!

### ❌ "repository not found"
1. GitHub'da repo oluşturuldu mu kontrol et
2. URL doğru mu kontrol et: `git remote -v`
3. Repo adı tam olarak **HBS** mi?
4. Repository public mi yoksa private mı?

### ❌ "Permission denied"
1. Personal Access Token'ın **repo** scope'u var mı?
2. Token süresi dolmadı mı?
3. Yeni token oluştur ve tekrar dene

---

## 🎯 ÖNERİM

**GitHub CLI (Yöntem 2) kullanın!**

Neden?
- ✅ Otomatik repo oluşturur
- ✅ Token yönetimi otomatik
- ✅ Tek komutla tamamlanır
- ✅ Hata yapmaz

Hızlı kurulum:
```powershell
# 1. CLI'ı yükle
winget install --id GitHub.cli

# 2. PowerShell'i yeniden başlat

# 3. Giriş yap
gh auth login

# 4. Repo oluştur ve push et
cd C:\Users\90551\IdeaProjects\HBS
gh repo create HBS --public --source=. --remote=origin --push
```

**5 dakikada biter!** 🚀

---

## ✅ Başarılı Push Sonrası

GitHub'da görecekleriniz:
```
https://github.com/EmrecanKörpınar/HBS

HBS/
├── 📁 common/
├── 📁 patient-service/
├── 📁 appointment-service/
├── 📁 gateway/
├── 📁 hbs-frontend/          ← React + shadcn/ui
├── 📁 infra/
├── 📄 README.md
├── 📄 pom.xml
└── ... (tüm dosyalar)
```

**İyi çalışmalar!** 🎉

