import 'package:core/src/cache/core/cache_model.dart';

/// An abstract class for cache operations. Concrete implementations should
/// provide the actual cache logic.
abstract class CacheOperation<T extends CacheModel> {
  /// Adds a single item to the cache.
  void add(T item);

  /// Removes a single item from the cache by its ID.
  void remove(String id);

  /// Removes multiple items from the cache by their IDs.
  void removeAll(List<String> ids);

  /// Adds multiple items to the cache.
  void addAll(List<T> items);

  /// Clears all items from the cache.
  void clear();

  /// Retrieves a single item from the cache by its ID.
  T? get(String id);

  /// Retrieves all items from the cache.
  List<T> getAll();
}
