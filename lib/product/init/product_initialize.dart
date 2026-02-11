import 'dart:async';

import 'package:birthday_reminder/product/init/config/prod_environment.dart';
import 'package:birthday_reminder/product/service/firebase_options.dart';
import 'package:birthday_reminder/product/state/container/product_state_container.dart';
import 'package:birthday_reminder/product/state/container/product_state_items.dart';
import 'package:birthday_reminder/product/service/notification/notification_service.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kartal/kartal.dart';
import 'package:logger/logger.dart';

@immutable
// ignore: lines_longer_than_80_chars
/// A class responsible for initializing product-level configurations before the app starts.
final class ProductInitialize {
  /// Starts the application by initializing necessary configurations.
  Future<void> startApplication() async {
    WidgetsFlutterBinding.ensureInitialized();
    await runZoned<Future<void>>(() async {
      await _initialize();
    });
  }

  /// Initializes necessary configurations for the product.
  Future<void> _initialize() async {
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableLevels = [LevelMessages.error];
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]); // Sets the app to portrait mode only
    await DeviceUtility.instance.initPackageInfo();

    /// Set environment configurations
    ProductEnvironment.general();

    /// Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Initialize Getit
    ProductContainer.setUp();

    // Initialize cache manager
    final cacheManager = ProductContainer.read<SharedPrefCacheManager>();
    await cacheManager.init(items: <CacheModel>[]);

    // Initialize preferences
    await ProductStateItems.productPreferences.init();

    // Initialize notification service
    await ProductContainer.read<INotificationService>().initialize();

    /// Global error handling
    /// Todo: Customize error handling as needed
    FlutterError.onError = (details) {
      Logger().e(details.exceptionAsString());
      // You can also log the error to an external service here.
    };
    // Add other initialization code here if needed
  }
}
