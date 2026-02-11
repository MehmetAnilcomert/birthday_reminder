import 'package:core/src/cache/core/cache_manager.dart';
import 'package:core/src/cache/core/cache_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A cache manager implementation using SharedPreferences for local storage.
final class SharedPrefCacheManager extends CacheManager {
  /// Creates a [SharedPrefCacheManager].
  SharedPrefCacheManager({super.path});

  late final SharedPreferences _preferences;

  /// Returns the [SharedPreferences] instance.
  SharedPreferences get preferences => _preferences;

  @override
  Future<void> init({required List<CacheModel> items}) async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }
}
