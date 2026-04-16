import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/local_profile_service.dart';
import 'about_screen.dart';
import '../auth/change_password_screen.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_and_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalProfileService _profileService = const LocalProfileService();
  LocalProfileData _profile = const LocalProfileData(
    userId: '',
    name: '',
    email: '',
    imageBase64: '',
  );
  bool _isLoadingProfile = true;

  static Future<void> _signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keySessionId);

    if (!context.mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.loadProfile();
    if (!mounted) {
      return;
    }

    setState(() {
      _profile = profile;
      _isLoadingProfile = false;
    });
  }

  Future<void> _openEditProfile({bool pickImageOnOpen = false}) async {
    final didUpdate = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(pickImageOnOpen: pickImageOnOpen),
      ),
    );

    if (didUpdate == true) {
      await _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImageBytes = _profile.imageBytes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _openEditProfile(),
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: _isLoadingProfile
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              )
                            : profileImageBytes == null
                            ? const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Color(0xFF888888),
                                ),
                              )
                            : Image.memory(
                                profileImageBytes,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isLoadingProfile
                        ? 'Loading profile...'
                        : _profile.displayName,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _profile.userId.isEmpty
                        ? 'Student ID: Not available'
                        : 'Student ID: ${_profile.userId}',
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                  if (_profile.email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _profile.email,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => _openEditProfile(pickImageOnOpen: true),
                    icon: const Icon(Icons.photo_camera_back_outlined),
                    label: const Text('Update Picture'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Settings Options
            _buildSettingItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => _openEditProfile(),
            ),
            _buildSettingItem(
              icon: Icons.photo_camera_back_outlined,
              title: 'Update Picture',
              onTap: () => _openEditProfile(pickImageOnOpen: true),
            ),
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              ),
            ),
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TermsAndConditionsScreen(),
                ),
              ),
            ),
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              ),
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
            ),
            _buildSettingItem(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () => _signOut(context),
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF1A1A1A),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF1A1A1A),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF888888)),
        onTap: onTap,
      ),
    );
  }
}
