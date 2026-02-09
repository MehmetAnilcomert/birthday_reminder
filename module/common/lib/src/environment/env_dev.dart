import 'package:common/src/environment/prod_configuration.dart';
import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(obfuscate: true, path: 'assets/env/.dev.env')
/// Development environment configuration implementation.
final class DevEnv implements ProductConfiguration {
  @EnviedField(varName: 'BASE_URL')
  final String _baseUrl = _DevEnv._baseUrl;

  @EnviedField(varName: 'API_KEY')
  final String _apiKey = _DevEnv._apiKey;

  @EnviedField(varName: 'FIREBASE_WEB_API_KEY')
  final String _firebaseWebApiKey = _DevEnv._firebaseWebApiKey;

  @EnviedField(varName: 'FIREBASE_WEB_APP_ID')
  final String _firebaseWebAppId = _DevEnv._firebaseWebAppId;

  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID')
  final String _firebaseMessagingSenderId = _DevEnv._firebaseMessagingSenderId;

  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  final String _firebaseProjectId = _DevEnv._firebaseProjectId;

  @EnviedField(varName: 'FIREBASE_AUTH_DOMAIN')
  final String _firebaseAuthDomain = _DevEnv._firebaseAuthDomain;

  @EnviedField(varName: 'FIREBASE_ANDROID_API_KEY')
  final String _firebaseAndroidApiKey = _DevEnv._firebaseAndroidApiKey;

  @EnviedField(varName: 'FIREBASE_ANDROID_APP_ID')
  final String _firebaseAndroidAppId = _DevEnv._firebaseAndroidAppId;

  @EnviedField(varName: 'FIREBASE_STORAGE_BUCKET')
  final String _firebaseStorageBucket = _DevEnv._firebaseStorageBucket;

  @EnviedField(varName: 'FIREBASE_IOS_API_KEY')
  final String _firebaseIosApiKey = _DevEnv._firebaseIosApiKey;

  @EnviedField(varName: 'FIREBASE_IOS_APP_ID')
  final String _firebaseIosAppId = _DevEnv._firebaseIosAppId;

  @EnviedField(varName: 'FIREBASE_IOS_BUNDLE_ID')
  final String _firebaseIosBundleId = _DevEnv._firebaseIosBundleId;

  @EnviedField(varName: 'FIREBASE_MACOS_API_KEY')
  final String _firebaseMacOsApiKey = _DevEnv._firebaseMacOsApiKey;

  @EnviedField(varName: 'FIREBASE_MACOS_APP_ID')
  final String _firebaseMacOsAppId = _DevEnv._firebaseMacOsAppId;

  @EnviedField(varName: 'FIREBASE_WINDOWS_API_KEY')
  final String _firebaseWindowsApiKey = _DevEnv._firebaseWindowsApiKey;

  @EnviedField(varName: 'FIREBASE_WINDOWS_APP_ID')
  final String _firebaseWindowsAppId = _DevEnv._firebaseWindowsAppId;

  @override
  String get baseUrl => _baseUrl;

  @override
  String get apiKey => _apiKey;

  @override
  String get firebaseWebApiKey => _firebaseWebApiKey;

  @override
  String get firebaseWebAppId => _firebaseWebAppId;

  @override
  String get firebaseMessagingSenderId => _firebaseMessagingSenderId;

  @override
  String get firebaseProjectId => _firebaseProjectId;

  @override
  String get firebaseAuthDomain => _firebaseAuthDomain;

  @override
  String get firebaseStorageBucket => _firebaseStorageBucket;

  @override
  String get firebaseAndroidApiKey => _firebaseAndroidApiKey;

  @override
  String get firebaseAndroidAppId => _firebaseAndroidAppId;

  @override
  String get firebaseIosApiKey => _firebaseIosApiKey;

  @override
  String get firebaseIosAppId => _firebaseIosAppId;

  @override
  String get firebaseIosBundleId => _firebaseIosBundleId;

  @override
  String get firebaseMacOsApiKey => _firebaseMacOsApiKey;

  @override
  String get firebaseMacOsAppId => _firebaseMacOsAppId;

  @override
  String get firebaseWindowsApiKey => _firebaseWindowsApiKey;

  @override
  String get firebaseWindowsAppId => _firebaseWindowsAppId;
}
