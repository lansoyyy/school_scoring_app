import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_scoring_app/features/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/app_logo.dart';
import 'forgot_password_login_screen.dart';
import 'services/auth_api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthApiService _authApi = const AuthApiService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  bool get _canSubmit => !_isLoading && _emailCtrl.text.trim().isNotEmpty;

  void _goBackToSignIn() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
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

  Future<void> _sendReset() async {
    if (_isLoading) {
      return;
    }

    _trimEmail();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final responseFuture = _authApi.forgotPassword(username: email);
    final delayFuture = Future<void>.delayed(const Duration(seconds: 7));
    final results = await Future.wait<Object?>(<Future<Object?>>[
      responseFuture,
      delayFuture,
    ]);

    final response = results.first as AuthApiResponse;

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.isSuccess) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserEmail, email);
      await prefs.setString(AppConstants.keySignupEmail, email);
      if ((prefs.getBool(AppConstants.keyRememberMe) ?? false) &&
          (response.generatedPassword ?? '').isNotEmpty) {
        await prefs.setString(
          AppConstants.keyUserPassword,
          response.generatedPassword!,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotPasswordLoginScreen(
            initialEmail: email,
            initialPassword: response.generatedPassword ?? '',
            successMessage: response.message,
          ),
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
          child: _buildFormState(context),
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 18),
          Center(
            child: AppLogo(
              fit: BoxFit.contain,
              height: 150,
            ),
          ),
          const SizedBox(height: 56),
          const Text(
            'Forgot Password',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter email address associated with your account.',
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          _buildLabel('Email Address'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onChanged: (_) => setState(() {}),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
            onEditingComplete: _trimEmail,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            decoration: _inputDecoration(
              'Enter your email',
              Icons.email_outlined,
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _canSubmit ? _sendReset : null,
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
              const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change your mind? ',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : _goBackToSignIn,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
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
