import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_and_conditions_screen.dart';
import '../../widgets/common/app_logo.dart';
import 'login_screen.dart';
import 'services/auth_api_service.dart';
import 'signup_login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthApiService _authApi = const AuthApiService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit => _agreeTerms && !_isLoading;

  void _openTermsAndConditions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
    );
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

    if (trimmedValue.contains(RegExp(r'\s'))) {
      return 'Email address must not contain spaces';
    }

    if (!RegExp(AppConstants.emailRegex).hasMatch(trimmedValue)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> _register() async {
    if (_isLoading) {
      return;
    }

    _trimEmail();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeTerms) {
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final responseFuture = _authApi.signup(username: email);
    final delayFuture = Future<void>.delayed(const Duration(seconds: 7));
    final results = await Future.wait<Object?>(<Future<Object?>>[
      responseFuture,
      delayFuture,
    ]);

    final response = results.first as AuthApiResponse;

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);

    if (response.isSuccess) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keySignupEmail, email);
      await prefs.setString(AppConstants.keyUserEmail, email);
      if ((response.generatedPassword ?? '').isNotEmpty) {
        await prefs.setString(
          AppConstants.keyUserPassword,
          response.generatedPassword!,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SignupLoginScreen(
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
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Center(
                  child: AppLogo(
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 52),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your details to get started.',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                _buildLabel('Email Address'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
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
                    'Enter email address',
                    Icons.email_outlined,
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeTerms,
                        activeColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.textPrimary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: _isLoading
                            ? null
                            : (value) =>
                                  setState(() => _agreeTerms = value ?? false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'I agree to the ',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                          InkWell(
                            onTap: _isLoading ? null : _openTermsAndConditions,
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            ' and ',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                          InkWell(
                            onTap: _isLoading ? null : _openPrivacyPolicy,
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _register : null,
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
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Sign In',
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  );

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
