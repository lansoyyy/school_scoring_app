import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _textFadeAnim;
  late Animation<Offset> _textSlideAnim;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _textFadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
    _textSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));

    _runSplash();
  }

  Future<void> _runSplash() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gray800, AppColors.gray700, AppColors.gray600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _logoCtrl,
                      builder: (context, child) => Opacity(
                        opacity: _fadeAnim.value,
                        child: Transform.scale(
                          scale: _scaleAnim.value,
                          child: child,
                        ),
                      ),
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColorDark,
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'DSI',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.gray800,
                                  letterSpacing: 3,
                                ),
                              ),
                              Text(
                                'INSTITUTE',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gray600,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    AnimatedBuilder(
                      animation: _textCtrl,
                      builder: (context, child) => Opacity(
                        opacity: _textFadeAnim.value,
                        child: SlideTransition(
                          position: _textSlideAnim,
                          child: child,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Don Stevens Institute',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textWhite,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 50,
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppColors.gray400,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Student Grades & Sports\nManagement System',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textWhite.withOpacity(0.75),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textWhite.withOpacity(0.6),
                        ),
                        strokeWidth: 2.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 11,
                        color: AppColors.textWhite.withOpacity(0.4),
                      ),
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
