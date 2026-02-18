import 'package:flutter/material.dart';

/// App Colors for School Sports Scoring Management App
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF357ABD);
  static const Color primaryLight = Color(0xFF6BA8EB);

  // Secondary Colors
  static const Color secondary = Color(0xFF50C878);
  static const Color secondaryDark = Color(0xFF3AA860);
  static const Color secondaryLight = Color(0xFF7DD99A);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentDark = Color(0xFFE55555);
  static const Color accentLight = Color(0xFFFF8585);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1E1E2E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2A2A3C);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0F0F1A);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Sports Related Colors
  static const Color basketball = Color(0xFFFF6B35);
  static const Color volleyball = Color(0xFF00A896);
  static const Color football = Color(0xFF0077B6);
  static const Color badminton = Color(0xFF00B4D8);
  static const Color tennis = Color(0xFF90BE6D);
  static const Color swimming = Color(0xFF5E60CE);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentLight, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static Color shadowColor = Colors.black.withOpacity(0.1);
  static Color shadowColorDark = Colors.black.withOpacity(0.2);

  // Overlay Colors
  static Color overlay = Colors.black.withOpacity(0.5);
  static Color overlayLight = Colors.black.withOpacity(0.3);
}
