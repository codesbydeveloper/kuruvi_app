import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/services/local_storage_service.dart';
import 'package:kuruvikal/features/onboarding/screens/onboarding_screen.dart';
import 'package:kuruvikal/features/dashboard/screens/dahsboard_screen.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final LocalStorageService _localStorageService = LocalStorageService();
  late final AnimationController _logoController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );
    _logoScale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOut,
      ),
    );
    _logoController.forward();

    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay

    final isOnboarded = await _localStorageService.isOnboarded();
    if (!isOnboarded) {
      _goNext(const OnBoardingScreen());
      return;
    }

   _goNext(const DashboardScreen());
  }

  void _goNext(Widget screen) {
    if (!mounted) return;

    NavigationService().pushReplacement(screen);
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: FadeTransition(
          opacity: _logoFade,
          child: SlideTransition(
            position: _logoSlide,
            child: ScaleTransition(
              scale: _logoScale,
              child: Image.asset(
                ImageAssetPath.splashScreenLogo,
                width: 80.w,
                height: 40.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
