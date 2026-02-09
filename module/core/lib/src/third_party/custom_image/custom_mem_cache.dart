/// A custom memory cache configuration for images.
final class CustomMemCache {
  /// Creates a [CustomMemCache] with the given [height] and [width].
  const CustomMemCache({required this.height, required this.width});

  /// The height of the cache.
  final int height;

  /// The width of the cache.
  final int width;
}
