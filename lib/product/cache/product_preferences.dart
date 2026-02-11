import 'package:shared_preferences/shared_preferences.dart';

/// Application configuration items
enum ProductPreferencesKeys {
  /// User authentication token
  token,

  /// User profile data
  user,

  /// User's birthdays list
  birthdays,

  /// App theme mode
  /// Whether the tutorial has been shown
  isTutorialShown,
}

/// A class responsible for managing product preferences using SharedPreferences.
final class ProductPreferences {
  /// Initializes the preferences manager.
  ProductPreferences();

  late final SharedPreferences _preferences;

  /// Initializes the SharedPreferences instance.
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Saves a [String] value for the given [key].
  Future<bool> setString(ProductPreferencesKeys key, String value) async {
    return _preferences.setString(key.name, value);
  }

  /// Retrieves a [String] value for the given [key].
  String? getString(ProductPreferencesKeys key) {
    return _preferences.getString(key.name);
  }

  /// Saves a [bool] value for the given [key].
  Future<bool> setBool({
    required ProductPreferencesKeys key,
    required bool value,
  }) async {
    return _preferences.setBool(key.name, value);
  }

  /// Retrieves a [bool] value for the given [key].
  bool getBool({required ProductPreferencesKeys key}) {
    return _preferences.getBool(key.name) ?? false;
  }

  /// Removes the value for the given [key].
  Future<bool> remove(ProductPreferencesKeys key) async {
    return _preferences.remove(key.name);
  }

  /// Clears all preferences.
  Future<bool> clear() async {
    return _preferences.clear();
  }
}
