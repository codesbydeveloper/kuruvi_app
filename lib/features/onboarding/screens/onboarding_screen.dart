import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/local_storage_service.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/features/dashboard/screens/dahsboard_screen.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: 'Delivered to Your Doorstep',
      subtitle: 'Quick delivery by trusted by\nlocal partners',
      description: 'Fresh products, fair prices, and reliable service\nright from your village store to your home.',
      image: ImageAssetPath.onBoardingSlider2,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await LocalStorageService().setOnboarded(true);
    if (!mounted) return;
    NavigationService().pushReplacement(const DashboardScreen());
  }

  void _next() {
    if (_currentIndex == _items.length - 1) {
      _finishOnboarding();
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 3.h),
            Image.asset(
              ImageAssetPath.splashScreenLogo,
              height: 10.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 60.h,
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) => _buildPage(_items[index]),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45.w,
                  height: 4.h,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(Icons.arrow_forward, size: 16.sp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 2.h),
          Image.asset(
            height: 40.h,
            item.image,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 2.h),
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackTextColor,

            ),
          ),
          SizedBox(height: 1.2.h),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textMutedColor,
            ),
          ),
        ],
      ),
    );
  }

}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final String image;

  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
  });
}
