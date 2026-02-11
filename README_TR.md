# BirthNote Application 🎂

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Gemini](https://img.shields.io/badge/Gemini-8E75B2?style=for-the-badge&logo=google-gemini&logoColor=white)](https://ai.google.dev/)

Modern, güvenli ve yapay zeka destekli, Flutter ve Firebase ile geliştirilmiş bir doğum günü hatırlatma uygulaması.

🌍 **Diller:** [English](README.md) | **Türkçe**

---

## 📸 Ekran Görüntüleri

| Giriş Yap | Kayıt Ol | Ana Sayfa | Boş Ana Sayfa |
| :---: | :---: | :---: | :---: |
| ![Giriş](images/login.png) | ![Kayıt](images/register.png) | ![Boş Ana Sayfa](images/empty_home.png) | ![Ana Sayfa](images/home.png) |
| **Doğum Günü Formu** | **Öğretici 1** | **Öğretici 2** | |
| ![Form](images/form.png) | ![Öğretici 1](images/tutorial_1.png) | ![Öğretici 2](images/tutorial_2.png) | |

---

## 🚀 Özellikler

- 🔐 **Güvenli Kimlik Doğrulama**: Firebase Authentication ile kullanıcı hesapları.
- 📅 **Doğum Günü Yönetimi**: Doğum günlerini kolayca ekleyin, güncelleyin ve yönetin.
- 🤖 **Yapay Zeka Tebrik Asistanı**: İlişki türüne göre kişiselleştirilmiş mesajlar oluşturmak için **Google Gemini** entegrasyonu.
- 🔔 **Akıllı Bildirimler**: Firebase Cloud Messaging (FCM) ile hiçbir doğum gününü kaçırmayın.
- 💬 **WhatsApp Yönlendirmesi**: Bildirim tıklandığında veya uygulama içinden doğrudan WhatsApp üzerinden tebrik mesajı gönderme.
- 🛡️ **Veri Gizliliği**: İletişim bilgileri **AES şifreleme** ile güvenli bir şekilde saklanır.
- 🌓 **Dinamik Tema**: Açık ve Koyu mod desteği.
- 🌐 **Yerelleştirme**: Tamamen İngilizce ve Türkçe dil desteği.
- 📱 **Çevrimdışı Destek**: İnternet olmasa bile kesintisiz deneyim için yerel önbellekleme.
- 🎨 **Modern Arayüz**: Material 3 tasarımı, pürüzsüz Lottie animasyonları ve etkileşimli öğreticiler.

## 🏗️ Mimari

Proje, özellik odaklı modüler bir yapı ile **Clean Architecture** prensiplerini takip eder:

- **Katmanlı Yapı**:
    - **Görünüm (View)**: Widget'lar ve mixin'ler kullanan kullanıcı arayüzü bileşenleri.
    - **Cubit (ViewModel)**: BLoC pattern kullanılarak yönetilen uygulama durumu.
    - **Repo (Repository)**: Servisler ve view model'ler arasındaki veri soyutlama katmanı.
    - **Servis (Service)**: Dış servis entegrasyonları (Firebase, Gemini, Şifreleme).
- **Modülerlik**: Paylaşılan mantık, dahili modüllere (`core`, `common`) ayrılmıştır.
- **Bağımlılık Enjeksiyonu**: `GetIt` kullanılarak merkezi servis yönetimi.
- **Navigasyon**: `AutoRoute` ile tip güvenli yönlendirme.

## 🛠️ Teknoloji Yığını

- **Framework**: [Flutter](https://flutter.dev)
- **Durum Yönetimi**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Arka Plan**: [Firebase](https://firebase.google.com) (Auth, Firestore, FCM)
- **Yapay Zeka**: [Google Gemini](https://pub.dev/packages/google_generative_ai)
- **Navigasyon**: [AutoRoute](https://pub.dev/packages/auto_route)
- **Yerelleştirme**: [Easy Localization](https://pub.dev/packages/easy_localization)
- **Ağ**: [Vexana](https://pub.dev/packages/vexana) & [Dio](https://pub.dev/packages/dio)
- **Depolama**: [Shared Preferences](https://pub.dev/packages/shared_preferences) & [Secure Storage](https://pub.dev/packages/flutter_secure_storage)

## 📥 Kurulum

1.  **Projeyi Klonlayın**:
    ```bash
    git clone https://github.com/MehmetAnilcomert/birthday_reminder.git
    ```
2.  **Bağımlılıkları Yükleyin**:
    ```bash
    flutter pub get
    ```
3.  **Firebase Yapılandırması**:
    - `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ekleyin.
    - CLI yüklüyse `flutterfire configure` komutunu çalıştırın.
4.  **Build Runner'ı Çalıştırın**:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
5.  **Uygulamayı Başlatın**:
    ```bash
    flutter run
    ```
