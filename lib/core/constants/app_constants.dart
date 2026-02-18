/// App Constants for School Sports Scoring Management App
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'School Sports Scoring';
  static const String appVersion = '1.0.0';

  // Font Family
  static const String fontFamily = 'Urbanist';

  // Default Values
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultSpacing = 8.0;
  static const double defaultBorderWidth = 1.0;
  static const double defaultElevation = 2.0;

  // Animation Duration
  static const int animationDuration = 300;
  static const int shortAnimationDuration = 150;
  static const int longAnimationDuration = 500;

  // Screen Sizes
  static const double mobileWidth = 600;
  static const double tabletWidth = 900;
  static const double desktopWidth = 1200;

  // Pagination
  static const int defaultPageSize = 20;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  static const String displayDateTimeFormat = 'MMM dd, yyyy hh:mm a';

  // Regex Patterns
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^[0-9]{10,15}$';
  static const String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';

  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyRememberMe = 'remember_me';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // API Constants
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Sport Types
  static const List<String> sportTypes = [
    'Basketball',
    'Volleyball',
    'Football',
    'Badminton',
    'Tennis',
    'Swimming',
  ];

  // Score Limits
  static const int maxScore = 100;
  static const int minScore = 0;

  // Team Size Limits
  static const int minTeamSize = 1;
  static const int maxTeamSize = 30;
}
