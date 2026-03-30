import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppColors {
  AppColors();

  static const Color primaryColor = Color(0xFF4DA0CE);
  static const Color primaryColorDark = Color(0xFF00729D);
  static const Color primaryColorLight = Color(0xFF60A5FA);
  static const Color secondaryColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0XFFF8F6F6);
  static const Color greenTextColor = Color(0xFF1F7A6C);
  static const Color lightRedTextColor1 = Color(0xFFA03030);
  static const Color lightRedTextColor2 = Color(0xFFC09090);
  static const Color maroonColor = Color(0xFF7A1F1F);

  /// white color
  static const Color whiteColor = Color(0xFFFFFFFF);

  /// black color
  static const Color blackColor = Color(0xFF000000);

  /// text color
  static const Color blackTextColor = Color(0xFF2A2A2A);
  static const Color greyTextColor = Color(0xFF5E5E5E);
  static const Color greyTextColor2 = Color(0xFF757575);
  static const Color textMutedColor = Color(0xFF64748B);

  static final Color mainColor = Color(0xFFF8D072);
  static final Color yellowColor = Color(0xFFFFDC7E);

  /// main green col
  static final Color greenColor = Color(0xFF00A275);
  static final Color greenColor2 = Color(0xFF008E67);
  static final Color lightGreenColor = Color(0xFF70E3C1);
  static final Color lightGreenColor2 = Color(0xFF19C292);
  static final Color borderGreenColor = Color(0xFF31E7B5);

  /// brown color
  static final Color brownColor = Color(0xFF89292D);

  /// grey color
  static final Color greyLightColor = Color(0xFFD0D0D0);
  static final Color iconGreyColor = Color(0xFF797979);
  static final Color borderGreyLightColor = Color(0xFF9D9D9D);
  static final Color borderGreyLightColor2 = Color(0xFFD4D4D4);
  static final Color verticalBorderColor = Color(0xFFD9D9D9);

  /// blue color
  static final Color colorsBlue = Color(0xFF2674F0);
  static final Color colorLightsBlue = Color(0xFFDFECFF);

  static final Color safeareBackGround = mainColor;

  /// gradients
  static const LinearGradient categoryTopGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF2EEEE), Color(0xFFFFE7A7)],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient subCategoryGradient = LinearGradient(
    colors: [Color(0xFFFFE0EC), Color(0xFFFFF0F5)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient homeGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFFFDC7E)],
  );

  static final themeData = ThemeData(
    primaryColor: AppColors.mainColor,
    fontFamily: 'Poppins',
    splashColor: AppColors.greyLightColor,
  );

  /// think font
  // static TextStyle smallTextStyle = TextStyle(
  //   color: AppColors.blackColor,
  //   fontSize: 12.sp,
  //   fontWeight: FontWeight.w600,
  // );
  //
  // static TextStyle mediumTextStyle = TextStyle(
  //   color: AppColors.blackColor,
  //   fontSize: 14.sp,
  //   fontWeight: FontWeight.w600,
  // );
  // static TextStyle largeLargeTextStyle = TextStyle(
  //   color: AppColors.blackColor,
  //   fontSize: 15.sp,
  //   fontWeight: FontWeight.w600,
  // );
}
