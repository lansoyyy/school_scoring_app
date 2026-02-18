import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'widgets/common/app_text.dart';

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
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppH1(AppStrings.appTitle),
              SizedBox(height: 16),
              AppBodyMedium('Architecture setup complete!'),
            ],
          ),
        ),
      ),
    );
  }
}
