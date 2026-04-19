import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_scoring_app/features/auth/login_screen.dart';
import 'package:school_scoring_app/features/home/home_screen.dart';
import 'package:school_scoring_app/navigation/main_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'services/auth_api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthApiService _authApi = const AuthApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _currentPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserEmail = (prefs.getString(AppConstants.keyUserEmail) ?? '')
        .trim();
    final savedSignupEmail =
        (prefs.getString(AppConstants.keySignupEmail) ?? '').trim();
    final emailToLoad = savedUserEmail.isNotEmpty
        ? savedUserEmail
        : savedSignupEmail;

    if (!mounted || emailToLoad.isEmpty) {
      return;
    }

    _emailCtrl.value = TextEditingValue(
      text: emailToLoad,
      selection: TextSelection.collapsed(offset: emailToLoad.length),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _trimEmail() {
    final trimmedEmail = _emailCtrl.text.trim();
    if (trimmedEmail == _emailCtrl.text) {
      return;
    }

    _emailCtrl.value = TextEditingValue(
      text: trimmedEmail,
      selection: TextSelection.collapsed(offset: trimmedEmail.length),
    );
  }

  String? _validateEmail(String? value) {
    final rawValue = value ?? '';
    final trimmedValue = rawValue.trim();

    if (trimmedValue.isEmpty) {
      return 'Email address is required';
    }

    if (rawValue.contains(RegExp(r'\s'))) {
      return 'Email address must not contain spaces';
    }

    if (!RegExp(AppConstants.emailRegex).hasMatch(trimmedValue)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }

    _trimEmail();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final response = await _authApi.changePassword(
      username: email,
      currentPassword: _currentPasswordCtrl.text,
      newPassword: _newPasswordCtrl.text,
      confirmPassword: _confirmPasswordCtrl.text,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);

    if (response.isSuccess) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserEmail, email);
      await prefs.setString(AppConstants.keySignupEmail, email);
      if ((prefs.getBool(AppConstants.keyRememberMe) ?? false) &&
          _newPasswordCtrl.text.isNotEmpty) {
        await prefs.setString(
          AppConstants.keyUserPassword,
          _newPasswordCtrl.text,
        );
      }

      _currentPasswordCtrl.clear();
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: AppColors.success,
        ),
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                const SizedBox(height: 52),
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Fill in your details to get started.',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 20),
                _buildLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  onEditingComplete: _trimEmail,
                  decoration: _inputDecoration(
                    'Enter your email',
                    Icons.email_outlined,
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                _buildLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _currentPasswordCtrl,
                  obscureText: _obscureCurrentPassword,
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
                                  () => _obscureCurrentPassword =
                                      !_obscureCurrentPassword,
                                ),
                          icon: Icon(
                            _obscureCurrentPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildLabel('New Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPasswordCtrl,
                  obscureText: _obscureNewPassword,
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
                                  () => _obscureNewPassword =
                                      !_obscureNewPassword,
                                ),
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'New password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildLabel('Confirm Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _obscureConfirmPassword,
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
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != _newPasswordCtrl.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      disabledBackgroundColor: AppColors.buttonDisabled,
                      disabledForegroundColor: AppColors.buttonTextDisabled,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
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
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: InkWell(
                    onTap: _isLoading
                        ? null
                        : () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainNavigation(),
                            ),
                          ),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Change your mind? ',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Home',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
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
