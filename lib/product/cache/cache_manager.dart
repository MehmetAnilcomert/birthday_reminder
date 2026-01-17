import 'package:hive_flutter/hive_flutter.dart';

enum CacheKeys { user, birthdays, token }

final class CacheManager {
  static late Box<dynamic> _box;

  static Future<void> init() async {
    _box = await Hive.openBox('app_cache');
  }

  static Future<void> write(CacheKeys key, dynamic value) async {
    await _box.put(key.name, value);
  }

  static T? read<T>(CacheKeys key) {
    return _box.get(key.name) as T?;
  }

  static Future<void> remove(CacheKeys key) async {
    await _box.delete(key.name);
  }

  static Future<void> clear() async {
    await _box.clear();
  }

  static bool containsKey(CacheKeys key) {
    return _box.containsKey(key.name);
  }
}
