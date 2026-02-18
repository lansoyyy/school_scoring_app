import 'package:flutter/material.dart';
import 'app_assets.dart';

/// App Images Helper Class
class AppImages {
  AppImages._();

  /// Get image from assets
  static Image asset(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
    Alignment alignment = Alignment.center,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
    );
  }

  /// User image
  static Image user({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return asset(AppAssets.userImage, width: width, height: height, fit: fit);
  }

  /// Network image with error handling
  static Image network(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
      },
    );
  }

  /// Circle avatar from asset
  static CircleAvatar circleAvatar({
    required String imagePath,
    double radius = 24,
    Color? backgroundColor,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: AssetImage(imagePath),
    );
  }

  /// Circle avatar from network
  static CircleAvatar networkAvatar({
    required String url,
    double radius = 24,
    Color? backgroundColor,
    Widget? errorWidget,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey[300],
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (exception, stackTrace) {
        // Handle error
      },
      child: errorWidget,
    );
  }
}
