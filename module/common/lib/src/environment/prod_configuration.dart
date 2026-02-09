/// Defines the product configuration for the production environment.
/// Project configuration items are specified here.
abstract class ProductConfiguration {
  /// The base URL for API requests in the production environment.
  String get baseUrl;

  /// The API key for accessing services in the production environment.
  String get apiKey;

  /// The Firebase web API key for accessing services in the production environment.
  String get firebaseWebApiKey;

  /// The Firebase web app ID for accessing services in the production environment.
  String get firebaseWebAppId;

  /// The Firebase messaging sender ID for accessing services in the production environment.
  String get firebaseMessagingSenderId;

  /// The Firebase project ID for accessing services in the production environment.
  String get firebaseProjectId;

  /// The Firebase auth domain for accessing services in the production environment.
  String get firebaseAuthDomain;

  /// The Firebase storage bucket for accessing services in the production environment.
  String get firebaseStorageBucket;

  /// The Firebase android API key for accessing services in the production environment.
  String get firebaseAndroidApiKey;

  /// The Firebase android app ID for accessing services in the production environment.
  String get firebaseAndroidAppId;

  /// The Firebase iOS API key for accessing services in the production environment.
  String get firebaseIosApiKey;

  /// The Firebase iOS app ID for accessing services in the production environment.
  String get firebaseIosAppId;

  /// The Firebase iOS bundle ID for accessing services in the production environment.
  String get firebaseIosBundleId;

  /// The Firebase macOS API key for accessing services in the production environment.
  String get firebaseMacOsApiKey;

  /// The Firebase macOS app ID for accessing services in the production environment.
  String get firebaseMacOsAppId;

  /// The Firebase windows API key for accessing services in the production environment.
  String get firebaseWindowsApiKey;

  /// The Firebase windows app ID for accessing services in the production environment.
  String get firebaseWindowsAppId;
}
