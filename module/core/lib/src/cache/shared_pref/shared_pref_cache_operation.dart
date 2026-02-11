import 'dart:convert';
import 'package:core/src/cache/core/cache_model.dart';
import 'package:core/src/cache/core/cache_operation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A SharedPreferences-based implementation of [CacheOperation].
final class SharedPrefCacheOperation<T extends CacheModel>
    extends CacheOperation<T> {
  /// Creates a [SharedPrefCacheOperation] instance.
  SharedPrefCacheOperation({
    required SharedPreferences preferences,
    required T itemBase,
  }) : _preferences = preferences,
       _itemBase = itemBase;

  final SharedPreferences _preferences;
  final T _itemBase;

  String _getKey(String id) => '${T.toString()}_$id';

  @override
  void add(T item) {
    _preferences.setString(_getKey(item.id), jsonEncode(item.toJson()));
  }

  @override
  void addAll(List<T> items) {
    items.forEach(add);
  }

  @override
  void clear() {
    final keys = _preferences.getKeys();
    final prefix = '${T.toString()}_';
    for (final key in keys) {
      if (key.startsWith(prefix)) {
        _preferences.remove(key);
      }
    }
  }

  @override
  T? get(String id) {
    final value = _preferences.getString(_getKey(id));
    if (value == null) return null;
    return _itemBase.fromDynamicJson(jsonDecode(value)) as T;
  }

  @override
  List<T> getAll() {
    final keys = _preferences.getKeys();
    final prefix = '${T.toString()}_';
    final items = <T>[];
    for (final key in keys) {
      if (key.startsWith(prefix)) {
        final value = _preferences.getString(key);
        if (value != null) {
          items.add(_itemBase.fromDynamicJson(jsonDecode(value)) as T);
        }
      }
    }
    return items;
  }

  @override
  void remove(String id) {
    _preferences.remove(_getKey(id));
  }

  @override
  void removeAll(List<String> ids) {
    ids.forEach(remove);
  }
}
