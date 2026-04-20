import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/notification_permission_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationPermissionService _notificationPermissionService =
      const NotificationPermissionService();
  bool _allowNotifications = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final allowNotifications =
        await _notificationPermissionService.isNotificationsEnabled();
    if (!mounted) {
      return;
    }

    setState(() {
      _allowNotifications = allowNotifications;
      _isLoading = false;
    });
  }

  Future<void> _updatePreference(bool value) async {
    if (value) {
      final allowNotifications =
          await _notificationPermissionService.requestPermission();

      if (!mounted) {
        return;
      }

      setState(() => _allowNotifications = allowNotifications);
      if (!allowNotifications) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notifications are blocked on this phone. Enable them in system settings if needed.',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    await _notificationPermissionService.disableNotifications();

    if (!mounted) {
      return;
    }

    setState(() => _allowNotifications = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Allow this app to receive notifications on this device.',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Allow Notifications',
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _allowNotifications
                                      ? 'Notifications are enabled.'
                                      : 'Notifications are disabled.',
                                  style: const TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Switch.adaptive(
                            value: _allowNotifications,
                            activeColor: AppColors.primary,
                            onChanged: _updatePreference,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
