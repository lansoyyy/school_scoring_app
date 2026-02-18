import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';

/// Custom Card Widget with predefined styles
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Color? shadowColor;
  final double elevation;
  final ShapeBorder? shape;
  final bool borderOnForeground;
  final Clip clipBehavior;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool isClickable;
  final bool bordered;
  final BorderSide? borderSide;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.shadowColor,
    this.elevation = AppConstants.defaultElevation,
    this.shape,
    this.borderOnForeground = true,
    this.clipBehavior = Clip.none,
    this.borderRadius = AppConstants.defaultRadius,
    this.onTap,
    this.isClickable = false,
    this.bordered = false,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveShape =
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: bordered
              ? borderSide ??
                    BorderSide(
                      color: AppColors.border,
                      width: AppConstants.defaultBorderWidth,
                    )
              : BorderSide.none,
        );

    final card = Card(
      margin: margin,
      color: color ?? Theme.of(context).cardColor,
      shadowColor: shadowColor ?? AppColors.shadowColor,
      elevation: elevation,
      shape: effectiveShape,
      borderOnForeground: borderOnForeground,
      clipBehavior: clipBehavior,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
        child: child,
      ),
    );

    if (isClickable || onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}

/// Primary Card Widget with default styling
class AppPrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppPrimaryCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = AppConstants.defaultRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
      isClickable: onTap != null,
    );
  }
}

/// Secondary Card Widget with border
class AppSecondaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppSecondaryCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = AppConstants.defaultRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      bordered: true,
      onTap: onTap,
      isClickable: onTap != null,
    );
  }
}

/// Elevated Card Widget with higher elevation
class AppElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = AppConstants.defaultRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      elevation: 4,
      onTap: onTap,
      isClickable: onTap != null,
    );
  }
}

/// Rounded Card Widget
class AppRoundedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppRoundedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.borderRadius = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
      isClickable: onTap != null,
    );
  }
}

/// Colored Card Widget with predefined color
class AppColoredCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppColoredCard({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = AppConstants.defaultRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: child,
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      width: width,
      height: height,
      color: backgroundColor,
      borderRadius: borderRadius,
      elevation: 0,
      onTap: onTap,
      isClickable: onTap != null,
    );
  }
}
