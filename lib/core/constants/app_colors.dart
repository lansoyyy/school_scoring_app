import 'package:flutter/material.dart';

/// App Colors for School Sports Scoring Management App
/// Using clean White and Gray palette for authentication and home content
class AppColors {
  AppColors._();

  // Primary Colors - Dark Gray for primary actions
  static const Color primary = Color(0xFF1F2937);
  static const Color primaryDark = Color(0xFF111827);
  static const Color primaryLight = Color(0xFF374151);

  // Secondary Colors - Medium Gray
  static const Color secondary = Color(0xFF6B7280);
  static const Color secondaryDark = Color(0xFF4B5563);
  static const Color secondaryLight = Color(0xFF9CA3AF);

  // Accent Colors - Light Gray
  static const Color accent = Color(0xFF9CA3AF);
  static const Color accentDark = Color(0xFF6B7280);
  static const Color accentLight = Color(0xFFD1D5DB);

  // Background Colors - White and Light Gray
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1F2937);
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF374151);

  // Text Colors - Gray Scale
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF9CA3AF);

  // Border Colors - Light Gray
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFFD1D5DB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Status Colors - Muted tones
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF2563EB);

  // Gray Scale - Complete palette
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Sports Related Colors - Muted tones
  static const Color basketball = Color(0xFF9CA3AF);
  static const Color volleyball = Color(0xFF9CA3AF);
  static const Color football = Color(0xFF9CA3AF);
  static const Color badminton = Color(0xFF9CA3AF);
  static const Color tennis = Color(0xFF9CA3AF);
  static const Color swimming = Color(0xFF9CA3AF);

  // Gradient Colors - Gray gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gray600, gray800],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [gray400, gray600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [gray200, gray400],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient whiteGradient = LinearGradient(
    colors: [gray50, gray100],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors - Subtle shadows
  static Color shadowColor = Colors.black.withOpacity(0.05);
  static Color shadowColorDark = Colors.black.withOpacity(0.15);
  static Color shadowColorLight = Colors.black.withOpacity(0.03);

  // Overlay Colors
  static Color overlay = Colors.black.withOpacity(0.5);
  static Color overlayLight = Colors.black.withOpacity(0.3);
  static Color overlayGray = Colors.black.withOpacity(0.1);

  // Input Colors
  static const Color inputBackground = Color(0xFFF9FAFB);
  static const Color inputFocusedBorder = Color(0xFF6B7280);
  static const Color inputErrorBorder = Color(0xFFEF4444);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF1F2937);
  static const Color buttonSecondary = Color(0xFFFFFFFF);
  static const Color buttonDisabled = Color(0xFFE5E7EB);
  static const Color buttonTextPrimary = Color(0xFFFFFFFF);
  static const Color buttonTextSecondary = Color(0xFF1F2937);
  static const Color buttonTextDisabled = Color(0xFF9CA3AF);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color cardShadow = Color(0x0A000000);

  // Divider Colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFF3F4F6);
}
