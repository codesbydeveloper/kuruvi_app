import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/features/auth/providers/auth_provider.dart';
import 'package:kuruvikal/features/auth/screens/splash_screen.dart';
import 'package:kuruvikal/features/category/providers/category_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'Kuruvi',
              debugShowCheckedModeBanner: false,
              theme: AppColors.themeData,
              builder: EasyLoading.init(),
              navigatorKey: NavigationService().navigatorKey,
              home: SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
