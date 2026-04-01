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

class _SplashScreenState extends State<SplashScreen> {

  final LocalStorageService _localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Image.asset(
          ImageAssetPath.splashScreenLogo,
          width: 80.w,
          height: 40.h,
        ),
      ),
    );
  }
}
