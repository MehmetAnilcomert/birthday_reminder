import 'package:common/src/environment/prod_configuration.dart';
import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(obfuscate: true, path: 'assets/env/.prod.env')
/// Production environment configuration implementation.
final class ProdEnv implements ProductConfiguration {
  @EnviedField(varName: 'BASE_URL')
  final String _baseUrl = _ProdEnv._baseUrl;

  @EnviedField(varName: 'API_KEY')
  final String _apiKey = _ProdEnv._apiKey;

  @EnviedField(varName: 'FIREBASE_WEB_API_KEY')
  final String _firebaseWebApiKey = _ProdEnv._firebaseWebApiKey;

  @EnviedField(varName: 'FIREBASE_WEB_APP_ID')
  final String _firebaseWebAppId = _ProdEnv._firebaseWebAppId;

  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID')
  final String _firebaseMessagingSenderId = _ProdEnv._firebaseMessagingSenderId;

  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  final String _firebaseProjectId = _ProdEnv._firebaseProjectId;

  @EnviedField(varName: 'FIREBASE_AUTH_DOMAIN')
  final String _firebaseAuthDomain = _ProdEnv._firebaseAuthDomain;

  @EnviedField(varName: 'FIREBASE_STORAGE_BUCKET')
  final String _firebaseStorageBucket = _ProdEnv._firebaseStorageBucket;

  @EnviedField(varName: 'FIREBASE_ANDROID_API_KEY')
  final String _firebaseAndroidApiKey = _ProdEnv._firebaseAndroidApiKey;

  @EnviedField(varName: 'FIREBASE_ANDROID_APP_ID')
  final String _firebaseAndroidAppId = _ProdEnv._firebaseAndroidAppId;

  @EnviedField(varName: 'FIREBASE_IOS_API_KEY')
  final String _firebaseIosApiKey = _ProdEnv._firebaseIosApiKey;

  @EnviedField(varName: 'FIREBASE_IOS_APP_ID')
  final String _firebaseIosAppId = _ProdEnv._firebaseIosAppId;

  @EnviedField(varName: 'FIREBASE_IOS_BUNDLE_ID')
  final String _firebaseIosBundleId = _ProdEnv._firebaseIosBundleId;

  @EnviedField(varName: 'FIREBASE_MACOS_API_KEY')
  final String _firebaseMacOsApiKey = _ProdEnv._firebaseMacOsApiKey;

  @EnviedField(varName: 'FIREBASE_MACOS_APP_ID')
  final String _firebaseMacOsAppId = _ProdEnv._firebaseMacOsAppId;

  @EnviedField(varName: 'FIREBASE_WINDOWS_API_KEY')
  final String _firebaseWindowsApiKey = _ProdEnv._firebaseWindowsApiKey;

  @EnviedField(varName: 'FIREBASE_WINDOWS_APP_ID')
  final String _firebaseWindowsAppId = _ProdEnv._firebaseWindowsAppId;

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
