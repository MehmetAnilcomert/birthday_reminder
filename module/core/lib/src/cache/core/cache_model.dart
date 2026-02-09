/// A mixin for cache models. It provides the basic structure for cache models.
mixin CacheModel {
  /// The unique identifier for the cache model.
  String get id;

  /// Creates the model from a dynamic JSON representation.
  CacheModel fromDynamicJson(dynamic json);

  /// Converts the model to a JSON representation.
  Map<String, dynamic> toJson();
}
