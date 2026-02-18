import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';

/// Custom Container Widget with predefined styles
class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final double borderRadius;
  final double? elevation;
  final bool bordered;
  final BorderSide? borderSide;
  final bool shadow;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.borderRadius = AppConstants.defaultRadius,
    this.elevation,
    this.bordered = false,
    this.borderSide,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      color: color,
      decoration: decoration ?? _buildDecoration(context),
      foregroundDecoration: foregroundDecoration,
      alignment: alignment,
      clipBehavior: clipBehavior,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      child: child,
    );
  }

  BoxDecoration? _buildDecoration(BuildContext context) {
    if (decoration != null) return null;
    if (!bordered && !shadow && elevation == null) return null;

    return BoxDecoration(
      color: color ?? Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: bordered
          ? Border.fromBorderSide(
              borderSide ??
                  BorderSide(
                    color: AppColors.border,
                    width: AppConstants.defaultBorderWidth,
                  ),
            )
          : null,
      boxShadow: shadow || (elevation != null && elevation! > 0)
          ? [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: elevation?.toDouble() ?? 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }
}

/// Primary Container Widget with default styling
class AppPrimaryContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final bool shadow;

  const AppPrimaryContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = AppConstants.defaultRadius,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      shadow: shadow,
    );
  }
}

/// Secondary Container Widget with border
class AppSecondaryContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final BorderSide? borderSide;

  const AppSecondaryContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = AppConstants.defaultRadius,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      bordered: true,
      borderSide: borderSide,
    );
  }
}

/// Rounded Container Widget
class AppRoundedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final bool shadow;

  const AppRoundedContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = 24,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      shadow: shadow,
    );
  }
}

/// Gradient Container Widget
class AppGradientContainer extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool shadow;

  const AppGradientContainer({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = AppConstants.defaultRadius,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Spacer Widget with predefined height
class AppVerticalSpacer extends StatelessWidget {
  final double height;

  const AppVerticalSpacer({
    super.key,
    this.height = AppConstants.defaultSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Horizontal Spacer Widget with predefined width
class AppHorizontalSpacer extends StatelessWidget {
  final double width;

  const AppHorizontalSpacer({
    super.key,
    this.width = AppConstants.defaultSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

/// Divider Widget with customizable color and height
class AppDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  const AppDivider({
    super.key,
    this.height = 1,
    this.color,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: color ?? AppColors.border,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
