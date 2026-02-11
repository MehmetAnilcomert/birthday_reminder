import 'package:common/index.dart';
import 'package:flutter/foundation.dart';

/// Application environment manager class.
final class ProductEnvironment {
  /// Sets up the product configuration for the current environment.
  ProductEnvironment.setup(ProductConfiguration configuration) {
    _configuration = configuration;
  }

  /// Sets up the product configuration with kDebugMode automatically.
  ProductEnvironment.general() {
    _configuration = kDebugMode ? DevEnv() : ProdEnv();
  }

  /// Gets the product configuration for the current environment.
  static late final ProductConfiguration _configuration;
}

/// Enum for accessing environment configuration items.
enum EnvironmentItems {
  /// The base URL for API requests.
  baseUrl,

  /// The API key for accessing services.
  apiKey,

  /// The Firebase web API key for accessing services.
  firebaseWebApiKey,

  /// The Firebase web app ID for accessing services.
  firebaseWebAppId,

  /// The Firebase messaging sender ID for accessing services.
  firebaseMessagingSenderId,

  /// The Firebase project ID for accessing services.
  firebaseProjectId,

  /// The Firebase auth domain for accessing services.
  firebaseAuthDomain,

  /// The Firebase storage bucket for accessing services.
  firebaseStorageBucket,

  /// The Firebase android API key for accessing services.
  firebaseAndroidApiKey,

  /// The Firebase android app ID for accessing services.
  firebaseAndroidAppId,

  /// The Firebase iOS API key for accessing services.
  firebaseIosApiKey,

  /// The Firebase iOS app ID for accessing services.
  firebaseIosAppId,

  /// The Firebase iOS bundle ID for accessing services.
  firebaseIosBundleId,

  /// The Firebase macOS API key for accessing services.
  firebaseMacOsApiKey,

  /// The Firebase macOS app ID for accessing services.
  firebaseMacOsAppId,

  /// The Firebase windows API key for accessing services.
  firebaseWindowsApiKey,

  /// The Firebase windows app ID for accessing services.
  firebaseWindowsAppId
  ;

  /// Gets the value of the environment item.
  String get value {
    switch (this) {
      case EnvironmentItems.baseUrl:
        return ProductEnvironment._configuration.baseUrl;
      case EnvironmentItems.apiKey:
        return ProductEnvironment._configuration.apiKey;
      case EnvironmentItems.firebaseWebApiKey:
        return ProductEnvironment._configuration.firebaseWebApiKey;
      case EnvironmentItems.firebaseWebAppId:
        return ProductEnvironment._configuration.firebaseWebAppId;
      case EnvironmentItems.firebaseMessagingSenderId:
        return ProductEnvironment._configuration.firebaseMessagingSenderId;
      case EnvironmentItems.firebaseProjectId:
        return ProductEnvironment._configuration.firebaseProjectId;
      case EnvironmentItems.firebaseAuthDomain:
        return ProductEnvironment._configuration.firebaseAuthDomain;
      case EnvironmentItems.firebaseStorageBucket:
        return ProductEnvironment._configuration.firebaseStorageBucket;
      case EnvironmentItems.firebaseAndroidApiKey:
        return ProductEnvironment._configuration.firebaseAndroidApiKey;
      case EnvironmentItems.firebaseAndroidAppId:
        return ProductEnvironment._configuration.firebaseAndroidAppId;
      case EnvironmentItems.firebaseIosApiKey:
        return ProductEnvironment._configuration.firebaseIosApiKey;
      case EnvironmentItems.firebaseIosAppId:
        return ProductEnvironment._configuration.firebaseIosAppId;
      case EnvironmentItems.firebaseIosBundleId:
        return ProductEnvironment._configuration.firebaseIosBundleId;
      case EnvironmentItems.firebaseMacOsApiKey:
        return ProductEnvironment._configuration.firebaseMacOsApiKey;
      case EnvironmentItems.firebaseMacOsAppId:
        return ProductEnvironment._configuration.firebaseMacOsAppId;
      case EnvironmentItems.firebaseWindowsApiKey:
        return ProductEnvironment._configuration.firebaseWindowsApiKey;
      case EnvironmentItems.firebaseWindowsAppId:
        return ProductEnvironment._configuration.firebaseWindowsAppId;
    }
  }
}
