import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_permission_service.dart';
import '../../widgets/common/app_logo.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NotificationPermissionService _notificationPermissionService =
      const NotificationPermissionService();

  @override
  void initState() {
    super.initState();
    _runSplash();
  }

  Future<void> _runSplash() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await _handleInitialNotificationPrompt();

    if (!mounted) {
      return;
    }

    final savedUserEmail = (prefs.getString(AppConstants.keyUserEmail) ?? '')
        .trim();
    final savedSignupEmail =
        (prefs.getString(AppConstants.keySignupEmail) ?? '').trim();
    final hasSavedEmail =
        savedUserEmail.isNotEmpty || savedSignupEmail.isNotEmpty;
    final Widget nextScreen = hasSavedEmail
        ? const LoginScreen()
        : const SignupScreen();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextScreen,
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _handleInitialNotificationPrompt() async {
    final shouldPrompt =
        await _notificationPermissionService.shouldShowInitialPrompt();
    if (!mounted || !shouldPrompt) {
      return;
    }

    final shouldEnable = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Enable Notifications',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Allow notifications on this phone so you can receive important updates from the app.',
            style: TextStyle(fontFamily: 'Urbanist', height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Not Now'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
              ),
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );

    if (shouldEnable == true) {
      await _notificationPermissionService.requestPermission();
      return;
    }

    await _notificationPermissionService.dismissInitialPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AppLogo(
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
