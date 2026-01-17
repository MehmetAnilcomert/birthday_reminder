## Firebase Yapılandırma Adımları

### 1. Firebase Console Yapılandırması

1. [Firebase Console](https://console.firebase.google.com/) adresine gidin
2. "Add project" veya "Proje ekle" butonuna tıklayın
3. Proje adını girin (örn: "birthday-reminder")
4. Google Analytics'i istediğiniz gibi yapılandırın
5. Proje oluşturulmasını bekleyin

### 2. Authentication Aktivasyonu

1. Sol menüden "Authentication" sekmesine gidin
2. "Get started" butonuna tıklayın
3. "Sign-in method" sekmesinde "Email/Password" seçeneğini etkinleştirin
4. "Enable" switch'ini açın ve "Save" butonuna basın

### 3. Cloud Firestore Aktivasyonu

1. Sol menüden "Firestore Database" sekmesine gidin
2. "Create database" butonuna tıklayın
3. "Start in production mode" seçeneğini seçin (güvenlik kurallarını sonra güncelleyeceğiz)
4. Location seçin (Europe (west) önerilir)
5. "Enable" butonuna basın

### 4. Firestore Security Rules Güncelleme

1. Firestore Database sayfasında "Rules" sekmesine gidin
2. Aşağıdaki kuralları yapıştırın:

\`\`\`javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Birthdays collection
    match /birthdays/{birthdayId} {
      allow read, write: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
    }
  }
}
\`\`\`

3. "Publish" butonuna basın

### 5. Android Yapılandırması

1. Firebase Console'da projenize Android uygulaması ekleyin
2. Package name: \`com.example.birthday_reminder\` (veya kendi package name'iniz)
3. \`google-services.json\` dosyasını indirin
4. Bu dosyayı \`android/app/\` klasörüne kopyalayın

### 6. iOS Yapılandırması

1. Firebase Console'da projenize iOS uygulaması ekleyin
2. Bundle ID: \`com.example.birthdayReminder\` (veya kendi bundle ID'niz)
3. \`GoogleService-Info.plist\` dosyasını indirin
4. Bu dosyayı \`ios/Runner/\` klasörüne kopyalayın
5. Xcode'da projeyi açın ve dosyayı Runner target'ına ekleyin

### 7. Firebase Options Dosyasını Güncelleme

FlutterFire CLI ile otomatik yapılandırma (Önerilen):

\`\`\`bash
# FlutterFire CLI'ı global olarak yükleyin
dart pub global activate flutterfire_cli

# Firebase yapılandırmasını otomatik oluşturun
flutterfire configure --project=birthday-reminder

# Bu komut:
# - Firebase projelerinizi listeler
# - Seçtiğiniz proje için yapılandırma dosyası oluşturur
# - lib/firebase_options.dart dosyasını otomatik günceller
\`\`\`

Manuel yapılandırma:

1. Firebase Console'da Project Settings > General sayfasına gidin
2. Her platform için (Web, Android, iOS) yapılandırma değerlerini kopyalayın
3. \`lib/firebase_options.dart\` dosyasındaki placeholder değerleri değiştirin

### 8. Firebase Messaging (İsteğe Bağlı - Push Notifications için)

1. Firebase Console'da "Cloud Messaging" sekmesine gidin
2. Server key'i kopyalayın (push notification için gerekli)
3. Android için:
   - \`android/app/google-services.json\` dosyası yeterli
4. iOS için:
   - APNs certificate yüklemeniz gerekebilir
   - Apple Developer Console'dan APNs key oluşturun
   - Firebase Console'a yükleyin

### 9. Test Etme

\`\`\`bash
# Uygulamayı çalıştırın
flutter run

# Veya debug modda
flutter run --debug
\`\`\`

1. Kayıt ol butonuna tıklayın
2. Email ve şifre ile hesap oluşturun
3. Giriş yapın
4. Doğum günü ekleyin

### 10. Firestore'da Verileri Kontrol Etme

1. Firebase Console > Firestore Database'e gidin
2. \`users\` ve \`birthdays\` collection'larını görmelisiniz
3. Test kullanıcınızı ve doğum günlerini görebilirsiniz

## Sorun Giderme

### "Default FirebaseApp not initialized" Hatası
- \`firebase_options.dart\` dosyasının doğru yapılandırıldığından emin olun
- \`google-services.json\` (Android) ve \`GoogleService-Info.plist\` (iOS) dosyalarının doğru konumda olduğundan emin olun

### "Permission denied" Hatası
- Firestore security rules'ı kontrol edin
- Kullanıcının giriş yapmış olduğundan emin olun

### Build Hataları
\`\`\`bash
# Clean ve rebuild deneyin
flutter clean
flutter pub get
flutter run
\`\`\`

### iOS Build Sorunları
\`\`\`bash
cd ios
pod install --repo-update
cd ..
flutter run
\`\`\`

## Ek Notlar

- Geliştirme ortamında test ederken Firebase Authentication'ın email doğrulama özelliğini kapatabilirsiniz
- Production'da mutlaka güvenlik kurallarını gözden geçirin
- Rate limiting ve security monitoring ekleyin
- Firebase pricing planınızı kontrol edin
