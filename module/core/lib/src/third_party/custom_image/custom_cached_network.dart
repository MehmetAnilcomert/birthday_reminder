import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/src/third_party/custom_image/custom_mem_cache.dart';
import 'package:flutter/widgets.dart';

/// Widget that displays a cached network image with optional loading and empty state widgets.
/// This is a custom implementation that wraps around [CachedNetworkImage].
class CustomCachedNetworkImage extends StatelessWidget {
  /// Creates a [CustomCachedNetworkImage] with the given parameters.
  const CustomCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.emptyWidget,
    this.loadingWidget,
    this.memCache = const CustomMemCache(height: 200, width: 200),
    this.boxFit = BoxFit.cover,
    this.size,
  });

  /// The URL of the image to be displayed.
  final String? imageUrl;

  /// An optional widget to display when [imageUrl] is null or empty.
  final Widget? emptyWidget;

  /// An optional widget to display while the image is loading.
  final Widget? loadingWidget;

  /// The custom memory cache configuration for the image.
  final CustomMemCache memCache;

  /// The box fit for the image. Defaults to [BoxFit.cover].
  final BoxFit boxFit;

  /// The size of the image.
  final Size? size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      memCacheHeight: memCache.height,
      memCacheWidth: memCache.width,
      errorWidget: (context, url, error) =>
          emptyWidget ?? const SizedBox.shrink(),
      fit: boxFit,
      height: size?.height,
      width: size?.width,
      progressIndicatorBuilder: (context, url, progress) =>
          loadingWidget ?? const SizedBox.shrink(),
    );
  }
}
