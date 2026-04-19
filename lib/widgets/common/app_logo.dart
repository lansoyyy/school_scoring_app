import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.url = AppConstants.appLogoUrl,
    this.localAssetPath = AppAssets.logo,
  });

  final double? width;
  final double? height;
  final BoxFit fit;
  final String url;
  final String localAssetPath;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildLocalLogo(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return _buildLocalLogo();
      },
    );
  }

  Widget _buildLocalLogo() {
    return Image.asset(
      localAssetPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}