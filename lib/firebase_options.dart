import 'package:birthday_reminder/product/init/config/prod_environment.dart';
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
