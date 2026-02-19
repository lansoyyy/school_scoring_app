import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';

/// Custom Button Widget with predefined styles
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonType type;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? icon;
  final double? iconSize;
  final EdgeInsets? padding;
  final double borderRadius;
  final BorderSide? borderSide;

  const AppButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.iconSize,
    this.padding,
    this.borderRadius = AppConstants.defaultRadius,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = (isLoading || isDisabled) ? null : onPressed;

    return SizedBox(
      width: width,
      height: height ?? _getHeight(),
      child: _buildButton(context, effectiveOnPressed),
    );
  }

  Widget _buildButton(BuildContext context, VoidCallback? onPressed) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            disabledBackgroundColor: AppColors.buttonDisabled,
            disabledForegroundColor: AppColors.buttonTextDisabled,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: borderSide ?? BorderSide.none,
            ),
            elevation: 0,
          ),
          child: _buildChild(),
        );

      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            side: borderSide,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildChild(),
        );

      case ButtonType.tertiary:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildChild(),
        );

      case ButtonType.icon:
        return IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: padding ?? _getPadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          icon: _buildChild(),
        );
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: iconSize ?? _getIconSize(),
        height: iconSize ?? _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor ?? Colors.white),
        ),
      );
    }

    if (icon != null && type == ButtonType.icon) {
      return SizedBox(
        width: iconSize ?? _getIconSize(),
        height: iconSize ?? _getIconSize(),
        child: icon,
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text, style: _getTextStyle()),
        ],
      );
    }

    return Text(text, style: _getTextStyle());
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall.copyWith(color: textColor);
      case ButtonSize.medium:
        return AppTextStyles.buttonMedium.copyWith(color: textColor);
      case ButtonSize.large:
        return AppTextStyles.buttonLarge.copyWith(color: textColor);
    }
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 44;
      case ButtonSize.large:
        return 52;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

/// Button Types
enum ButtonType { primary, secondary, tertiary, icon }

/// Button Sizes
enum ButtonSize { small, medium, large }

/// Primary Button Widget
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final Widget? icon;

  const AppPrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      type: ButtonType.primary,
      size: size,
      backgroundColor: backgroundColor,
      textColor: textColor,
      width: width,
      icon: icon,
    );
  }
}

/// Secondary Button Widget
class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonSize size;
  final Color? textColor;
  final double? width;
  final Widget? icon;

  const AppSecondaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.textColor,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      type: ButtonType.secondary,
      size: size,
      textColor: textColor,
      width: width,
      icon: icon,
    );
  }
}

/// Tertiary Button Widget
class AppTertiaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonSize size;
  final Color? textColor;
  final double? width;
  final Widget? icon;

  const AppTertiaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.textColor,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      type: ButtonType.tertiary,
      size: size,
      textColor: textColor,
      width: width,
      icon: icon,
    );
  }
}

/// Icon Button Widget
class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      '',
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      type: ButtonType.icon,
      size: size,
      backgroundColor: backgroundColor,
      textColor: iconColor,
      iconSize: iconSize,
      icon: icon,
    );
  }
}
