import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class NotificationPermissionService {
  const NotificationPermissionService();

  Future<bool> shouldShowInitialPrompt() async {
    if (!_supportsSystemNotificationPermission) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(AppConstants.keyNotificationPromptShown) ?? false);
  }

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final appEnabled = prefs.getBool(AppConstants.keyAllowNotifications) ?? false;

    if (!appEnabled || !_supportsSystemNotificationPermission) {
      return appEnabled;
    }

    final status = await Permission.notification.status;
    return _isGranted(status);
  }

  Future<bool> requestPermission() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyNotificationPromptShown, true);

    if (!_supportsSystemNotificationPermission) {
      await prefs.setBool(AppConstants.keyAllowNotifications, true);
      return true;
    }

    final status = await Permission.notification.request();
    final isEnabled = _isGranted(status);
    await prefs.setBool(AppConstants.keyAllowNotifications, isEnabled);
    return isEnabled;
  }

  Future<void> dismissInitialPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyNotificationPromptShown, true);
    await prefs.setBool(AppConstants.keyAllowNotifications, false);
  }

  Future<void> disableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyAllowNotifications, false);
    await prefs.setBool(AppConstants.keyNotificationPromptShown, true);
  }

  bool get _supportsSystemNotificationPermission {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool _isGranted(PermissionStatus status) {
    return status.isGranted || status.isProvisional;
  }
}