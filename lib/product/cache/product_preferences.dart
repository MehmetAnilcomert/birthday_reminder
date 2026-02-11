import 'package:birthday_reminder/product/models/project_setting_model.dart';
import 'package:core/core.dart';

/// Application configuration items
enum ProductPreferencesKeys {
  /// User authentication token
  token,

  /// User profile data
  user,

  /// User's birthdays list
  birthdays,

  /// APP theme mode
  themeMode,

  /// Whether the tutorial has been shown
  isTutorialShown,

  /// Last date the user's birthday greeting was shown
  lastBirthdayGreetingShownDate,
}

/// A class responsible for managing product preferences using SharedPreferences.
final class ProductPreferences {
  /// Initializes the preferences manager.
  ProductPreferences(SharedPrefCacheManager cacheManager)
    : _cacheManager = cacheManager;

  final SharedPrefCacheManager _cacheManager;
  late final SharedPrefCacheOperation<ProjectSettingModel> _operation;

  static const _settingsId = 'project_settings';

  /// Initializes the SharedPreferences instance.
  Future<void> init() async {
    _operation = SharedPrefCacheOperation<ProjectSettingModel>(
      preferences: _cacheManager.preferences,
      itemBase: const ProjectSettingModel(id: _settingsId),
    );
  }

  ProjectSettingModel _getSettings() {
    return _operation.get(_settingsId) ??
        const ProjectSettingModel(id: _settingsId);
  }

  /// Saves a [String] value for the given [key].
  Future<void> setString(ProductPreferencesKeys key, String value) async {
    final settings = _getSettings();
    ProjectSettingModel newSettings;
    switch (key) {
      case ProductPreferencesKeys.token:
        newSettings = settings.copyWith(token: value);
      case ProductPreferencesKeys.themeMode:
        newSettings = settings.copyWith(themeMode: value);
      case ProductPreferencesKeys.lastBirthdayGreetingShownDate:
        newSettings = settings.copyWith(lastBirthdayGreetingShownDate: value);
      default:
        newSettings = settings;
    }
    _operation.add(newSettings);
  }

  /// Retrieves a [String] value for the given [key].
  String? getString(ProductPreferencesKeys key) {
    final settings = _getSettings();
    return switch (key) {
      ProductPreferencesKeys.token => settings.token,
      ProductPreferencesKeys.themeMode => settings.themeMode,
      ProductPreferencesKeys.lastBirthdayGreetingShownDate =>
        settings.lastBirthdayGreetingShownDate,
      _ => null,
    };
  }

  /// Saves a [bool] value for the given [key].
  Future<void> setBool({
    required ProductPreferencesKeys key,
    required bool value,
  }) async {
    final settings = _getSettings();
    ProjectSettingModel newSettings;
    switch (key) {
      case ProductPreferencesKeys.isTutorialShown:
        newSettings = settings.copyWith(isTutorialShown: value);
      default:
        newSettings = settings;
    }
    _operation.add(newSettings);
  }

  /// Retrieves a [bool] value for the given [key].
  bool getBool({required ProductPreferencesKeys key}) {
    final settings = _getSettings();
    return switch (key) {
      ProductPreferencesKeys.isTutorialShown =>
        settings.isTutorialShown ?? false,
      _ => false,
    };
  }

  /// Removes the value for the given [key].
  Future<void> remove(ProductPreferencesKeys key) async {
    // For simplicity, we just set the field to null in our model
    final settings = _getSettings();
    ProjectSettingModel newSettings;
    switch (key) {
      case ProductPreferencesKeys.token:
        newSettings = settings.copyWith(token: null);
      case ProductPreferencesKeys.themeMode:
        newSettings = settings.copyWith(themeMode: null);
      case ProductPreferencesKeys.isTutorialShown:
        newSettings = settings.copyWith(isTutorialShown: null);
      case ProductPreferencesKeys.lastBirthdayGreetingShownDate:
        newSettings = settings.copyWith(lastBirthdayGreetingShownDate: null);
      default:
        newSettings = settings;
    }
    _operation.add(newSettings);
  }

  /// Clears all preferences.
  Future<void> clear() async {
    _operation.clear();
  }
}
