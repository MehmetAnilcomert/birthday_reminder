# Birthday Reminder App 🎂

Firebase tabanlı doğum günü hatırlatma uygulaması. Clean Architecture prensiplerine uygun olarak geliştirilmiştir.

## Özellikler

✨ **Temel Özellikler:**
- Firebase Authentication ile kullanıcı kaydı ve girişi
- Doğum günü ekleme, düzenleme ve silme
- Doğum günlerini tarihlerine göre sıralama
- Bugün ve yaklaşan doğum günlerini vurgulama
- Arama özelliği
- Offline cache desteği (Hive)
- Çoklu dil desteği (TR/EN)
- Modern ve responsive UI

🎨 **Tasarım:**
- Material 3 Design
- Kırmızı-mavi renk paleti (doğum günü temalı)
- Smooth animasyonlar
- Bottom navigation
- Drawer menü ile hesap bilgileri

🏗️ **Mimari:**
- Clean Architecture
- Feature-based klasör yapısı
- BLoC pattern (state management)
- Repository pattern
- Dependency injection hazır

## Kurulum

### 1. Bağımlılıkları Yükleyin

```bash
flutter pub get
```

### 2. Firebase Yapılandırması

Firebase Console'dan projenizi oluşturun ve yapılandırma dosyalarını indirin:

#### Android için:
1. Firebase Console'dan `google-services.json` dosyasını indirin
2. `android/app/` klasörüne kopyalayın

#### iOS için:
1. Firebase Console'dan `GoogleService-Info.plist` dosyasını indirin
2. `ios/Runner/` klasörüne kopyalayın

#### Firebase Options Güncelleme:
`lib/firebase_options.dart` dosyasındaki placeholder değerleri Firebase Console'dan aldığınız değerlerle değiştirin.

Alternatif olarak FlutterFire CLI kullanabilirsiniz:

```bash
# FlutterFire CLI'ı yükleyin
dart pub global activate flutterfire_cli

# Firebase yapılandırmasını otomatik oluşturun
flutterfire configure
```

Detaylı Firebase kurulum adımları için `FIREBASE_SETUP.md` dosyasına bakın.

### 3. Uygulamayı Çalıştırın

```bash
flutter run
```

## Proje Yapısı

```
lib/
├── features/                    # Feature modülleri
│   ├── auth/                   # Authentication
│   │   ├── bloc/              # Auth BLoC
│   │   └── view/              # Login/Register screens
│   ├── home/                   # Ana sayfa
│   │   ├── bloc/              # Birthday BLoC
│   │   ├── view/              # Home screen
│   │   └── widgets/           # Home widgets
│   ├── birthday_form/          # Doğum günü ekleme/düzenleme
│   │   └── view/              
│   └── navigation/             # Bottom nav & Drawer
│       └── main_navigation_view.dart
│
├── product/                     # Core katmanı
│   ├── cache/                  # Cache yönetimi (Hive)
│   ├── init/                   # App initialization
│   ├── models/                 # Data models
│   ├── repositories/           # Repository katmanı
│   └── utility/               
│       ├── constants/          # Sabitler
│       ├── theme/              # Tema yapılandırması
│       └── validators.dart     # Form validators
│
├── firebase_options.dart        # Firebase config
└── main.dart                   # Entry point
```

## Kullanılan Paketler

**State Management:**
- flutter_bloc: ^8.1.6
- equatable: ^2.0.5

**Firebase:**
- firebase_core: ^3.10.0
- firebase_auth: ^5.3.3
- cloud_firestore: ^5.5.0
- firebase_messaging: ^15.1.7

**Local Storage:**
- shared_preferences: ^2.3.4
- hive: ^2.2.3

**Localization:**
- easy_localization: ^3.0.7

**Utilities:**
- jiffy: ^6.3.1 (tarih işlemleri)
- dartz: ^0.10.1 (functional programming)
- get_it: ^8.0.3 (dependency injection)

## Firebase Firestore Yapısı

### Users Collection:
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "displayName": "User Name",
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

### Birthdays Collection:
```json
{
  "id": "birthday_id",
  "userId": "user_id",
  "name": "John",
  "surname": "Doe",
  "birthdayDate": "1990-05-15T00:00:00.000Z",
  "relationship": "friend",
  "greetingMessage": "Happy Birthday!",
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /birthdays/{birthdayId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## Gelecek Özellikler

- [ ] Firebase Push Notifications (doğum günü bildirimleri)
- [ ] Doğum günü kartları ve şablonları
- [ ] Sosyal medya paylaşımı
- [ ] Widget desteği
- [ ] Takvim entegrasyonu
- [ ] Hediye önerileri
- [ ] Yıldönümü takibi

## Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## İletişim

Sorularınız için issue açabilirsiniz.

---

Made with ❤️ and Flutter
