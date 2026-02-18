import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// App Helpers - Common utility functions
class AppHelpers {
  AppHelpers._();

  /// Format date
  static String formatDate(
    DateTime date, {
    String format = AppConstants.displayDateFormat,
  }) {
    return DateFormat(format).format(date);
  }

  /// Format time
  static String formatTime(
    DateTime time, {
    String format = AppConstants.displayTimeFormat,
  }) {
    return DateFormat(format).format(time);
  }

  /// Format date and time
  static String formatDateTime(
    DateTime dateTime, {
    String format = AppConstants.displayDateTimeFormat,
  }) {
    return DateFormat(format).format(dateTime);
  }

  /// Parse date string
  static DateTime? parseDate(
    String dateString, {
    String format = AppConstants.dateFormat,
  }) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Validate email
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailRegex).hasMatch(email);
  }

  /// Validate phone
  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phoneRegex).hasMatch(phone);
  }

  /// Validate password
  static bool isValidPassword(String password) {
    return RegExp(AppConstants.passwordRegex).hasMatch(password);
  }

  /// Hide keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Copy to clipboard
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red);
  }

  /// Show info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.blue);
  }

  /// Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.orange);
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if is mobile
  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < AppConstants.mobileWidth;
  }

  /// Check if is tablet
  static bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= AppConstants.mobileWidth &&
        width < AppConstants.tabletWidth;
  }

  /// Check if is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= AppConstants.desktopWidth;
  }

  /// Get platform
  static String getPlatform() {
    // Can be extended to return more specific platform info
    return 'unknown';
  }

  /// Debounce function
  static Function debounce(
    Function func, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => func());
    };
  }

  /// Throttle function
  static Function throttle(
    Function func, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    bool isThrottled = false;
    return () {
      if (!isThrottled) {
        func();
        isThrottled = true;
        Future.delayed(delay, () => isThrottled = false);
      }
    };
  }
}
