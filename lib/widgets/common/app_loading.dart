import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/constants/app_colors.dart';

/// Custom Loading Widget with predefined styles
class AppLoading extends StatelessWidget {
  final double? size;
  final Color? color;
  final LoadingType type;
  final String? message;
  final bool showMessage;

  const AppLoading({
    super.key,
    this.size,
    this.color,
    this.type = LoadingType.circle,
    this.message,
    this.showMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _buildLoadingWidget();

    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    return loadingWidget;
  }

  Widget _buildLoadingWidget() {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveSize = size ?? 40.0;

    switch (type) {
      case LoadingType.circle:
        return SizedBox(
          width: effectiveSize,
          height: effectiveSize,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        );

      case LoadingType.dualRing:
        return SpinKitDualRing(color: effectiveColor, size: effectiveSize);

      case LoadingType.fadingCircle:
        return SpinKitFadingCircle(color: effectiveColor, size: effectiveSize);

      case LoadingType.threeBounce:
        return SpinKitThreeBounce(color: effectiveColor, size: effectiveSize);

      case LoadingType.wave:
        return SpinKitWave(color: effectiveColor, size: effectiveSize);

      case LoadingType.pulse:
        return SpinKitPulse(color: effectiveColor, size: effectiveSize);

      case LoadingType.chasingDots:
        return SpinKitChasingDots(color: effectiveColor, size: effectiveSize);

      case LoadingType.squareCircle:
        return SpinKitSquareCircle(color: effectiveColor, size: effectiveSize);

      case LoadingType.foldingCube:
        return SpinKitFoldingCube(color: effectiveColor, size: effectiveSize);

      case LoadingType.pouringHourGlass:
        return SpinKitPouringHourGlass(
          color: effectiveColor,
          size: effectiveSize,
        );

      case LoadingType.hourGlass:
        return SpinKitHourGlass(color: effectiveColor, size: effectiveSize);

      case LoadingType.rotatingCircle:
        return SpinKitRotatingCircle(
          color: effectiveColor,
          size: effectiveSize,
        );

      case LoadingType.rotatingPlain:
        return SpinKitRotatingPlain(color: effectiveColor, size: effectiveSize);

      case LoadingType.doubleBounce:
        return SpinKitDoubleBounce(color: effectiveColor, size: effectiveSize);

      case LoadingType.wanderingCubes:
        return SpinKitWanderingCubes(
          color: effectiveColor,
          size: effectiveSize,
        );

      case LoadingType.fourSquare:
        return SpinKitFoldingCube(color: effectiveColor, size: effectiveSize);

      case LoadingType.ripple:
        return SpinKitRipple(color: effectiveColor, size: effectiveSize);

      case LoadingType.circleFade:
        return SpinKitFadingCircle(color: effectiveColor, size: effectiveSize);

      case LoadingType.grid:
        return SpinKitFoldingCube(color: effectiveColor, size: effectiveSize);
    }
  }
}

/// Loading Types
enum LoadingType {
  circle,
  dualRing,
  fadingCircle,
  threeBounce,
  wave,
  pulse,
  chasingDots,
  squareCircle,
  foldingCube,
  pouringHourGlass,
  hourGlass,
  rotatingCircle,
  rotatingPlain,
  doubleBounce,
  wanderingCubes,
  fourSquare,
  ripple,
  circleFade,
  grid,
}

/// Full Screen Loading Overlay
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;
  final LoadingType loadingType;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    this.loadingType = LoadingType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: AppLoading(
                message: message,
                showMessage: message != null,
                type: loadingType,
              ),
            ),
          ),
      ],
    );
  }
}

/// Small Loading Indicator
class AppSmallLoading extends StatelessWidget {
  final Color? color;

  const AppSmallLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
      ),
    );
  }
}

/// Button Loading Indicator
class AppButtonLoading extends StatelessWidget {
  final Color? color;

  const AppButtonLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      ),
    );
  }
}
