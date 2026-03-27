import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class LocationServiceDisabledDialog extends StatelessWidget {
  const LocationServiceDisabledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: AppColors.whiteColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      titlePadding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h),
      actionsPadding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_disabled_outlined,
              color: AppColors.brownColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Location service is off',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackTextColor,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'Turn on location services to find the nearest store and improve your experience.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textMutedColor,
          height: 1.35,
        ),
      ),
      actions: [
        SizedBox(
          width: 32.w,
          height: 4.8.h,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.greyTextColor,
              side: BorderSide(color: AppColors.borderGreyLightColor2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Not Now',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 32.w,
          height: 4.8.h,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Enable',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
