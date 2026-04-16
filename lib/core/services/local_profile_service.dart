import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocalProfileData {
  const LocalProfileData({
    required this.userId,
    required this.name,
    required this.email,
    required this.imageBase64,
  });

  final String userId;
  final String name;
  final String email;
  final String imageBase64;

  Uint8List? get imageBytes {
    if (imageBase64.trim().isEmpty) {
      return null;
    }

    try {
      return base64Decode(imageBase64);
    } catch (_) {
      return null;
    }
  }

  String get displayName {
    final trimmedName = name.trim();
    if (trimmedName.isNotEmpty) {
      return trimmedName;
    }

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      return 'Student';
    }

    final localPart = trimmedEmail.split('@').first;
    final normalized = localPart.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    if (normalized.isEmpty) {
      return trimmedEmail;
    }

    return normalized.split(RegExp(r'\s+')).map(_capitalizeWord).join(' ');
  }

  static String _capitalizeWord(String word) {
    if (word.isEmpty) {
      return word;
    }

    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }
}

class LocalProfileService {
  const LocalProfileService();

  Future<LocalProfileData> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalProfileData(
      userId: (prefs.getString(AppConstants.keyUserId) ?? '').trim(),
      name: (prefs.getString(AppConstants.keyUserName) ?? '').trim(),
      email: (prefs.getString(AppConstants.keyUserEmail) ?? '').trim(),
      imageBase64: prefs.getString(AppConstants.keyUserProfileImage) ?? '',
    );
  }

  Future<void> saveAuthIdentity({required String email, String? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedEmail = email.trim();
    final previousEmail = (prefs.getString(AppConstants.keyUserEmail) ?? '')
        .trim()
        .toLowerCase();
    final isDifferentUser =
        previousEmail.isNotEmpty &&
        previousEmail != normalizedEmail.toLowerCase();

    if (isDifferentUser) {
      await prefs.remove(AppConstants.keyUserName);
      await prefs.remove(AppConstants.keyUserProfileImage);
    }

    await prefs.setString(AppConstants.keyUserEmail, normalizedEmail);
    await prefs.setString(AppConstants.keySignupEmail, normalizedEmail);

    final trimmedUserId = userId?.trim() ?? '';
    if (trimmedUserId.isNotEmpty) {
      await prefs.setString(AppConstants.keyUserId, trimmedUserId);
    }
  }

  Future<void> saveProfileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserName, name.trim());
  }

  Future<void> saveProfileImageBytes(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.keyUserProfileImage,
      base64Encode(imageBytes),
    );
  }
}
