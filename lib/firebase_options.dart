import 'package:flutter/foundation.dart';

class FirebaseOptions {
  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.databaseURL,
    this.storageBucket,
    this.measurementId,
    this.trackingId,
    this.deepLinkURLScheme,
    this.androidClientId,
    this.iosClientId,
    this.iosBundleId,
    this.appGroupId,
  });

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? databaseURL;
  final String? storageBucket;
  final String? measurementId;
  final String? trackingId;
  final String? deepLinkURLScheme;
  final String? androidClientId;
  final String? iosClientId;
  final String? iosBundleId;
  final String? appGroupId;
}

// TODO: Replace with your Firebase project configuration
// You can get these values from Firebase Console
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAicqWGn3SPEcNoI83npkvjSZTbQBLgU-U',
    appId: '1:17337740461:web:2de2b97ca25994b8452a24',
    messagingSenderId: '17337740461',
    projectId: 'birthday-note-app',
    authDomain: 'birthday-note-app.firebaseapp.com',
    storageBucket: 'birthday-note-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEcTwlCZA6u9wy4eM-EOZiZJapv4KV5_Q',
    appId: '1:17337740461:android:0c94564af7f4b651452a24',
    messagingSenderId: '17337740461',
    projectId: 'birthday-note-app',
    storageBucket: 'birthday-note-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDY4UnJI676SOf_c9zmulQOPFxNK6Dpb2E',
    appId: '1:17337740461:ios:e884ef59be486a13452a24',
    messagingSenderId: '17337740461',
    projectId: 'birthday-note-app',
    storageBucket: 'birthday-note-app.firebasestorage.app',
    iosBundleId: 'com.example.birthdayReminder',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDY4UnJI676SOf_c9zmulQOPFxNK6Dpb2E',
    appId: '1:17337740461:ios:e884ef59be486a13452a24',
    messagingSenderId: '17337740461',
    projectId: 'birthday-note-app',
    storageBucket: 'birthday-note-app.firebasestorage.app',
    iosBundleId: 'com.example.birthdayReminder',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAicqWGn3SPEcNoI83npkvjSZTbQBLgU-U',
    appId: '1:17337740461:web:85ddc6e161baa245452a24',
    messagingSenderId: '17337740461',
    projectId: 'birthday-note-app',
    authDomain: 'birthday-note-app.firebaseapp.com',
    storageBucket: 'birthday-note-app.firebasestorage.app',
  );

}