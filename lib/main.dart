import 'package:flutter/material.dart';
import 'package:school_scoring_app/features/auth/change_password_screen.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/splash_screen.dart';

void main() {
  runApp(const SchoolScoringApp());
}

class SchoolScoringApp extends StatelessWidget {
  const SchoolScoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: const ChangePasswordScreen(),
    );
  }
}
