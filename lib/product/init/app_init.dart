import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../cache/cache_manager.dart';
import 'injection.dart';

@immutable
final class AppInit {
  const AppInit._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize Hive
    await Hive.initFlutter();
    await CacheManager.init();

    // Setup dependency injection
    await configureDependencies();
  }
}
