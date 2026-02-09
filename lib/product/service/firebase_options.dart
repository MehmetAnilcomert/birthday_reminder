import 'package:birthday_reminder/product/init/config/prod_environment.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';

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

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: EnvironmentItems.firebaseWebApiKey.value,
    appId: EnvironmentItems.firebaseWebAppId.value,
    messagingSenderId: EnvironmentItems.firebaseMessagingSenderId.value,
    projectId: EnvironmentItems.firebaseProjectId.value,
    authDomain: EnvironmentItems.firebaseAuthDomain.value,
    storageBucket: EnvironmentItems.firebaseStorageBucket.value,
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: EnvironmentItems.firebaseAndroidApiKey.value,
    appId: EnvironmentItems.firebaseAndroidAppId.value,
    messagingSenderId: EnvironmentItems.firebaseMessagingSenderId.value,
    projectId: EnvironmentItems.firebaseProjectId.value,
    storageBucket: EnvironmentItems.firebaseStorageBucket.value,
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: EnvironmentItems.firebaseIosApiKey.value,
    appId: EnvironmentItems.firebaseIosAppId.value,
    messagingSenderId: EnvironmentItems.firebaseMessagingSenderId.value,
    projectId: EnvironmentItems.firebaseProjectId.value,
    storageBucket: EnvironmentItems.firebaseStorageBucket.value,
    iosBundleId: EnvironmentItems.firebaseIosBundleId.value,
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: EnvironmentItems.firebaseMacOsApiKey.value,
    appId: EnvironmentItems.firebaseMacOsAppId.value,
    messagingSenderId: EnvironmentItems.firebaseMessagingSenderId.value,
    projectId: EnvironmentItems.firebaseProjectId.value,
    storageBucket: EnvironmentItems.firebaseStorageBucket.value,
    iosBundleId: EnvironmentItems.firebaseIosBundleId.value,
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: EnvironmentItems.firebaseWindowsApiKey.value,
    appId: EnvironmentItems.firebaseWindowsAppId.value,
    messagingSenderId: EnvironmentItems.firebaseMessagingSenderId.value,
    projectId: EnvironmentItems.firebaseProjectId.value,
    authDomain: EnvironmentItems.firebaseAuthDomain.value,
    storageBucket: EnvironmentItems.firebaseStorageBucket.value,
  );
}
