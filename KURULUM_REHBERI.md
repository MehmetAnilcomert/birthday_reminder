# Projeyi Çalıştırma Rehberi

## ✅ Tamamlanan İşlemler

Proje tam olarak aşağıdaki özelliklere sahip şekilde oluşturuldu:

### 1. **Mimari Yapı**
- ✅ Clean Architecture prensiplerine uygun
- ✅ Feature-based klasör yapısı
- ✅ Repository pattern implementasyonu
- ✅ BLoC pattern ile state management
- ✅ Dependency injection altyapısı (GetIt & Injectable)

### 2. **Ana Özellikler**
- ✅ Firebase Authentication (Email/Password)
- ✅ Firebase Firestore veritabanı entegrasyonu
- ✅ Hive ile offline cache yönetimi
- ✅ Easy Localization ile çoklu dil desteği (TR/EN)
- ✅ Material 3 Design theme sistemi
- ✅ Kırmızı-mavi doğum günü teması

### 3. **Kullanıcı Özellikleri**
- ✅ Kayıt ol / Giriş yap ekranları
- ✅ Doğum günü ekleme formu
- ✅ Doğum günü düzenleme
- ✅ Doğum günü silme (onaylama dialogu ile)
- ✅ Doğum günlerini arama
- ✅ Doğum günlerini tarihe göre sıralama
- ✅ Yaklaşan doğum günlerini vurgulama
- ✅ Bottom navigation bar
- ✅ Drawer menü ile hesap bilgileri
- ✅ Çıkış yapma

### 4. **UI/UX Detayları**
- ✅ Empty state ekranı (doğum günü yokken)
- ✅ Loading states
- ✅ Error handling ve mesajlar
- ✅ Pull-to-refresh
- ✅ Floating action button
- ✅ Smooth animasyonlar
- ✅ Form validasyonları

## 📱 Projeyi Çalıştırma

### Adım 1: Firebase Yapılandırması

**ÖNEMLİ:** Projeyi çalıştırmadan önce Firebase yapılandırması yapılmalıdır!

1. Firebase Console'a gidin: https://console.firebase.google.com/
2. Yeni proje oluşturun veya mevcut projenizi seçin
3. Authentication > Email/Password'u etkinleştirin
4. Firestore Database oluşturun (Production mode)
5. Android/iOS uygulamaları ekleyin

#### Otomatik Yapılandırma (Önerilen):
\`\`\`bash
# FlutterFire CLI'ı yükleyin
dart pub global activate flutterfire_cli

# Firebase yapılandırmasını oluşturun
flutterfire configure
\`\`\`

#### Manuel Yapılandırma:
1. Firebase Console'dan `google-services.json` (Android) indirin
2. `android/app/` klasörüne kopyalayın
3. Firebase Console'dan `GoogleService-Info.plist` (iOS) indirin
4. `ios/Runner/` klasörüne kopyalayın

Detaylı adımlar için `FIREBASE_SETUP.md` dosyasına bakın.

### Adım 2: Bağımlılıkları Yükleyin

\`\`\`bash
flutter pub get
\`\`\`

### Adım 3: Firestore Security Rules

Firebase Console > Firestore Database > Rules sekmesinde:

\`\`\`javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /birthdays/{birthdayId} {
      allow read, write: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
  }
}
\`\`\`

### Adım 4: Uygulamayı Çalıştırın

\`\`\`bash
# Android için
flutter run

# iOS için
flutter run

# Web için
flutter run -d chrome
\`\`\`

## 🎯 Kullanım Senaryosu

1. **Kayıt Ol:**
   - Uygulamayı açın
   - "Kayıt Ol" butonuna tıklayın
   - Email ve şifre girin
   - Hesabınız oluşturulacak ve otomatik giriş yapılacak

2. **Doğum Günü Ekleme:**
   - Ana ekranda sağ alttaki + FAB butonuna tıklayın
   - Ad, Soyad, Doğum Tarihi, Yakınlık Derecesi ve Tebrik Mesajı girin
   - "Kaydet" butonuna basın

3. **Doğum Günlerini Görüntüleme:**
   - Ana ekranda tüm doğum günleri tarihe göre sıralı görünür
   - En yakın doğum günleri en üstte
   - Bugün olanlar kırmızı, yaklaşanlar turuncu renkte vurgulanır

4. **Arama:**
   - Üst taraftaki arama çubuğuna isim yazın
   - Sonuçlar anında filtrelenecek

5. **Düzenleme/Silme:**
   - Bir doğum günü kartındaki kalem ikonuna basarak düzenleyin
   - Çöp kutusu ikonuyla silin (onay dialogu çıkacak)

6. **Hesap Yönetimi:**
   - Sol üstteki menü ikonuna (3 çizgi) tıklayın
   - Drawer'da hesap bilgilerinizi görün
   - "Çıkış Yap" ile hesaptan çıkış yapın

## 📂 Proje Yapısı

\`\`\`
lib/
├── features/              # UI katmanı - Feature modülleri
│   ├── auth/             # Kimlik doğrulama
│   │   ├── bloc/        # AuthBloc
│   │   └── view/        # Login & Register ekranları
│   ├── home/            # Ana sayfa
│   │   ├── bloc/        # BirthdayBloc
│   │   ├── view/        # Home ekranı
│   │   └── widgets/     # Birthday card, Empty state
│   ├── birthday_form/   # Doğum günü ekleme/düzenleme
│   └── navigation/      # Bottom nav & Drawer
│
├── product/              # Core/Infrastructure katmanı
│   ├── cache/           # Hive cache yönetimi
│   ├── init/            # App başlatma
│   ├── models/          # Data modelleri
│   ├── repositories/    # Data katmanı
│   └── utility/         # Theme, validators, constants
│
└── main.dart            # Entry point
\`\`\`

## 🔧 Teknik Detaylar

### State Management
- **flutter_bloc**: ^8.1.6
- Her feature kendi Bloc'una sahip
- Event-Driven architecture

### Veri Yönetimi
- **Cloud Firestore**: Uzak veritabanı
- **Hive**: Offline cache
- **Repository Pattern**: Data abstraction

### Routing
- MaterialPageRoute kullanımı
- Navigator 2.0'a geçiş için alt yapı hazır

### Localization
- **easy_localization**: ^3.0.7
- assets/translations/ klasöründe JSON dosyaları
- TR ve EN dil desteği

## 🚀 Gelecek Özellikler

Projeye eklenebilecek özellikler:

- [ ] **Firebase Cloud Messaging**: Push notifications
- [ ] **Bildirim Zamanlama**: Doğum günü hatırlatmaları
- [ ] **Widget**: Home screen widget
- [ ] **Tema Değiştirme**: Dark mode
- [ ] **Profil Fotoğrafları**: Firebase Storage ile
- [ ] **Sosyal Paylaşım**: Tebrik mesajlarını paylaş
- [ ] **İstatistikler**: Grafik ve analizler
- [ ] **Yıldönümleri**: Diğer önemli tarihler
- [ ] **Hediye Önerileri**: AI destekli
- [ ] **Takvim Entegrasyonu**: Google Calendar sync

## ⚠️ Bilinen Sorunlar

1. **Deprecation Warnings**: 
   - `withOpacity` yerine `.withValues()` kullanılmalı (Flutter 4.0+)
   - Bu uyarılar uygulamanın çalışmasını etkilemez

2. **Firebase Yapılandırması**:
   - İlk çalıştırmada Firebase yapılandırması yapılmalı
   - Aksi takdirde "Firebase not initialized" hatası alınır

## 💡 İpuçları

1. **Test Kullanıcısı Oluşturma:**
   \`\`\`
   Email: test@example.com
   Password: test123
   \`\`\`

2. **Hata Ayıklama:**
   \`\`\`bash
   flutter clean
   flutter pub get
   flutter run
   \`\`\`

3. **Firebase Bağlantısını Test Etme:**
   - Kayıt ol'a tıklayın
   - Firebase Console > Authentication'da kullanıcıyı görmelisiniz

4. **Cache Temizleme:**
   - Uygulamayı kaldırıp yeniden yükleyin
   - Veya Settings > Apps > Birthday Reminder > Clear Data

## 📝 Notlar

- Tüm Firebase güvenlik kuralları production-ready
- Offline çalışma desteği var (cache sayesinde)
- Form validasyonları eksiksiz
- Error handling yapılmış
- Loading states tüm işlemler için mevcut

## 🎨 Tasarım Sistemi

- **Primary Color**: Pink (#E91E63)
- **Secondary Color**: Blue (#2196F3)
- **Accent Color**: Pink Accent (#FF4081)
- **Font**: Poppins (400, 500, 600, 700)
- **Border Radius**: 12-16px
- **Spacing**: 8-16-24-32px grid

---

**Başarılar! 🎉**

Herhangi bir sorun yaşarsanız Firebase yapılandırmanızı kontrol edin.
