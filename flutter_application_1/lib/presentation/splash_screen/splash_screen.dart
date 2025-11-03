import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundFadeAnimation;

  bool _isInitialized = false;
  String _loadingText = 'Memuat QuizMaster Daily...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Background fade animation
    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoAnimationController.forward();
    });
  }

  Future<void> _startInitialization() async {
    try {
      // Simulate checking authentication tokens
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _loadingText = 'Memeriksa autentikasi...';
        });
      }

      // Simulate loading user preferences
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _loadingText = 'Memuat preferensi pengguna...';
        });
      }

      // Simulate fetching AI recommendation model updates
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        setState(() {
          _loadingText = 'Memperbarui model rekomendasi AI...';
        });
      }

      // Simulate preparing cached quiz data
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _loadingText = 'Menyiapkan data kuis...';
        });
      }

      // Final initialization
      await Future.delayed(const Duration(milliseconds: 400));

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _loadingText = 'Siap!';
        });
      }

      // Navigate to homepage after successful initialization
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        setState(() {
          _loadingText = 'Terjadi kesalahan. Mencoba lagi...';
        });
      }

      // Retry after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _startInitialization();
      }
    }
  }

  void _navigateToNextScreen() {
    // For demo purposes, navigate to homepage
    // In real implementation, check authentication status here
    Navigator.pushReplacementNamed(context, '/homepage');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundFadeAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.primaryColor
                      .withValues(alpha: _backgroundFadeAnimation.value),
                  AppTheme.lightTheme.primaryColor
                      .withValues(alpha: _backgroundFadeAnimation.value * 0.8),
                  AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: _backgroundFadeAnimation.value * 0.6),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to push content to center
                  const Spacer(flex: 2),

                  // Logo section with animations
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_logoScaleAnimation, _logoFadeAnimation]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoFadeAnimation.value,
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: _buildLogoSection(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 8.h),

                  // Loading section
                  _buildLoadingSection(),

                  const Spacer(flex: 3),

                  // Footer section
                  _buildFooterSection(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App logo container with Indonesian educational elements
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Quiz icon
              CustomIconWidget(
                iconName: 'quiz',
                color: AppTheme.lightTheme.primaryColor,
                size: 8.w,
              ),
              SizedBox(height: 1.h),
              // Indonesian flag colors accent
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 3.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF0000), // Red
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Container(
                    width: 3.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // App name
        Text(
          'QuizMaster Daily',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Belajar Setiap Hari dengan Kuis Pintar',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading indicator
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Loading text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _loadingText,
            key: ValueKey(_loadingText),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 1.h),

        // Progress indicator
        Container(
          width: 60.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isInitialized ? 60.w : 30.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        // Educational badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'school',
                color: Colors.white,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Platform Edukasi Indonesia',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Version info
        Text(
          'Versi 1.0.0 • Dibuat dengan ❤️ untuk Indonesia',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
