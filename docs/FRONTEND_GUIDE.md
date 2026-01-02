# 🎨 HBS Frontend - React Kullanım Kılavuzu

## 🚀 Hızlı Başlangıç

### 1. Dependencies Kurulumu
```powershell
cd C:\Users\90551\IdeaProjects\HBS\hbs-frontend
npm install
```

### 2. Frontend'i Başlat
```powershell
npm start
```

Frontend **http://localhost:3001** adresinde açılacak.

---

## 📱 Ekranlar

### 🏠 Ana Sayfa
- Hoş geldin mesajı
- Hızlı erişim linkleri

### 👤 Yeni Hasta Kaydı (`/create-patient`)
**Özellikler:**
- ✅ Form validasyonu
- ✅ TC Kimlik No kontrolü (11 haneli)
- ✅ Doğum tarihi seçici
- ✅ Kan grubu seçimi
- ✅ Responsive tasarım
- ✅ Loading state
- ✅ Başarı/Hata mesajları

**Zorunlu Alanlar:**
- TC Kimlik No (11 haneli)
- Ad
- Soyad
- Doğum Tarihi
- Cinsiyet

**Opsiyonel Alanlar:**
- Telefon
- E-posta
- Adres, Şehir, Ülke
- Kan Grubu
- Acil Durum İletişim

### 📋 Hasta Listesi (`/patients`)
**Özellikler:**
- ✅ Tablo görünümü
- ✅ Arama fonksiyonu (ad/soyad)
- ✅ Pagination
- ✅ Sıralama
- ✅ Hasta detayı görüntüleme

**Kolonlar:**
- Dosya No
- TC Kimlik No
- Ad Soyad
- Doğum Tarihi
- Cinsiyet
- Telefon
- Şehir
- Kan Grubu
- Durum (Aktif/Pasif)
- İşlemler

---

## 🎯 Test Senaryosu

### Senaryo 1: Yeni Hasta Kaydı
1. **http://localhost:3001** adresini açın
2. Menüden **"Yeni Hasta"** tıklayın
3. Formu doldurun:
   ```
   TC Kimlik No: 12345678901
   Ad: Ahmet
   Soyad: Yılmaz
   Doğum Tarihi: 15/05/1990
   Cinsiyet: Erkek
   Telefon: +905551234567
   E-posta: ahmet@example.com
   Şehir: İstanbul
   Kan Grubu: A+
   ```
4. **"Hasta Kaydı Oluştur"** butonuna tıklayın
5. ✅ Başarı mesajı ve dosya numarası görünecek

### Senaryo 2: Hasta Listesini Görüntüleme
1. Menüden **"Hasta Listesi"** tıklayın
2. ✅ Kaydettiğiniz hasta tabloda görünecek
3. Arama kutusuna **"Ahmet"** yazın
4. ✅ Filtrelenmiş sonuçlar gösterilecek

### Senaryo 3: API Hata Kontrolü
1. Yeni hasta formunda aynı TC Kimlik No'yu tekrar girin
2. ✅ "Patient with this national ID already exists" hatası alınacak

---

## 🔧 API Entegrasyonu

### API Client Yapılandırması
```typescript
// src/api/client.ts
const API_URL = 'http://localhost:8000';  // Gateway URL

// Automatic trace ID injection
config.headers['X-Trace-Id'] = generateTraceId();
```

### Patient Service
```typescript
// src/api/patientService.ts

// Create patient
await patientService.createPatient(data);

// Get patient by ID
await patientService.getPatientById(id);

// Search patients
await patientService.searchPatients(query);

// Get active patients
await patientService.getActivePatients();
```

---

## 🎨 UI Components (Ant Design)

### Kullanılan Componentler
- **Layout**: Header, Content, Footer
- **Menu**: Navigation menu
- **Form**: Form validation
- **Input**: Text inputs
- **Select**: Dropdown selects
- **DatePicker**: Date selection
- **Table**: Data table
- **Button**: Action buttons
- **Card**: Content cards
- **Message**: Toast notifications
- **Tag**: Status tags

### Tema
- Primary Color: `#1890ff` (Ant Design default)
- Dark Theme: Navigation header
- Responsive: Mobile-friendly

---

## 📁 Dosya Yapısı

```
hbs-frontend/
├── public/
│   └── index.html
├── src/
│   ├── api/
│   │   ├── client.ts           # Axios client + interceptors
│   │   └── patientService.ts   # Patient API calls
│   ├── components/
│   │   ├── CreatePatientForm.tsx
│   │   └── PatientList.tsx
│   ├── types/
│   │   └── patient.ts          # TypeScript types
│   ├── App.tsx                 # Main app + routing
│   ├── App.css
│   └── index.tsx
├── .env                        # Environment variables
├── package.json
├── tsconfig.json
└── README.md
```

---

## 🐛 Troubleshooting

### Port 3001 zaten kullanımda
```powershell
# Port'u değiştir (.env)
PORT=3002
npm start
```

### API bağlantı hatası
```
Error: Network Error
```

**Çözüm:**
1. Backend servislerin çalıştığını kontrol edin:
   ```powershell
   curl http://localhost:8081/actuator/health
   ```
2. CORS ayarlarını kontrol edin (Gateway'de CORS enabled)

### "Cannot find module" hatası
```powershell
# node_modules'ü sil ve tekrar kur
Remove-Item -Recurse -Force node_modules
npm install
```

### TypeScript hataları
```powershell
# TypeScript cache'i temizle
Remove-Item -Recurse -Force node_modules/.cache
npm start
```

---

## 🚀 Production Build

### Build
```powershell
npm run build
```

Build dosyaları `build/` klasörüne oluşturulur.

### Serve (Test)
```powershell
npm install -g serve
serve -s build -l 3001
```

---

## 📊 Performance

### Optimizasyonlar
- ✅ Code splitting (React.lazy)
- ✅ Production build minification
- ✅ Tree shaking
- ✅ Gzip compression (ready)

### Bundle Size
- Main bundle: ~500 KB (gzipped)
- Ant Design: ~200 KB (gzipped)

---

## 🔐 Güvenlik

### Implemented
- ✅ Input validation (frontend)
- ✅ XSS protection (React default)
- ✅ CSRF ready (token support)
- ✅ Secure HTTP headers

### TODO
- [ ] JWT token management
- [ ] Refresh token flow
- [ ] Role-based UI (RBAC)
- [ ] Audit logging

---

## 📱 Mobile Responsive

### Breakpoints
- **XS**: < 576px (mobile)
- **SM**: ≥ 576px (tablet)
- **MD**: ≥ 768px (desktop)
- **LG**: ≥ 992px (large desktop)
- **XL**: ≥ 1200px (extra large)

Form ve tablo tamamen responsive!

---

## 🎉 Başarılı Test Çıktısı

```
✅ Hasta kaydedildi: HBS-2026-000001
✅ Hasta listede görüntülendi
✅ Arama çalışıyor
✅ Form validasyonu aktif
✅ API entegrasyonu başarılı
```

---

## 📞 Yardım

Sorun yaşarsanız:
1. Browser console'u kontrol edin (F12)
2. Network tab'de API çağrılarını inceleyin
3. Backend loglarını kontrol edin

**Happy Coding! 🚀**

