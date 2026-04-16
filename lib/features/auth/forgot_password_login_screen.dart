import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/local_profile_service.dart';
import '../../navigation/main_navigation.dart';
import 'services/auth_api_service.dart';

class ForgotPasswordLoginScreen extends StatefulWidget {
  final String initialEmail;
  final String initialPassword;
  final String? successMessage;

  const ForgotPasswordLoginScreen({
    super.key,
    required this.initialEmail,
    required this.initialPassword,
    this.successMessage,
  });

  @override
  State<ForgotPasswordLoginScreen> createState() =>
      _ForgotPasswordLoginScreenState();
}

class _ForgotPasswordLoginScreenState extends State<ForgotPasswordLoginScreen> {
  final AuthApiService _authApi = const AuthApiService();
  final LocalProfileService _profileService = const LocalProfileService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.text = widget.initialEmail;
    _passCtrl.text = widget.initialPassword;
    _loadSavedCredentials();
    _showSuccessMessage();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail =
        (prefs.getString(AppConstants.keyUserEmail) ?? '').trim().isNotEmpty
        ? (prefs.getString(AppConstants.keyUserEmail) ?? '').trim()
        : (prefs.getString(AppConstants.keySignupEmail) ?? '').trim();
    final savedPassword = prefs.getString(AppConstants.keyUserPassword) ?? '';

    if (!mounted) {
      return;
    }

    setState(() {
      if (_emailCtrl.text.trim().isEmpty && savedEmail.isNotEmpty) {
        _emailCtrl.text = savedEmail;
      }
      if (_passCtrl.text.isEmpty && savedPassword.isNotEmpty) {
        _passCtrl.text = savedPassword;
      }
    });
  }

  void _showSuccessMessage() {
    final successMessage = widget.successMessage?.trim() ?? '';
    if (successMessage.isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final response = await _authApi.login(
      username: email,
      password: _passCtrl.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);

    if (response.isSuccess) {
      final prefs = await SharedPreferences.getInstance();
      await _profileService.saveAuthIdentity(
        email: email,
        userId: response.userId,
      );
      if ((prefs.getBool(AppConstants.keyRememberMe) ?? false) &&
          _passCtrl.text.isNotEmpty) {
        await prefs.setString(AppConstants.keyUserPassword, _passCtrl.text);
      }

      if (response.sessionId != null && response.sessionId!.isNotEmpty) {
        await prefs.setString(AppConstants.keySessionId, response.sessionId!);
      }

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 42),
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 28),
                _buildLabel('Email Address'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: _inputDecoration(
                    'Enter your email',
                    Icons.email_outlined,
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Email address is required';
                    }
                    if (!RegExp(AppConstants.emailRegex).hasMatch(email)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildLabel('Password'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration:
                      _inputDecoration(
                        'Enter your password',
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: _isLoading
                              ? null
                              : () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      disabledBackgroundColor: AppColors.buttonDisabled,
                      disabledForegroundColor: AppColors.buttonTextDisabled,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.textWhite,
                              strokeWidth: 2.4,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        color: AppColors.textTertiary,
      ),
      prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 22),
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }
}
