import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/app_logo.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
