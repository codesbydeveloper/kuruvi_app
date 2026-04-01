import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';

class AppSnackBar {
  static void showError(String message) {
    _show(message, background: AppColors.redColor);
  }

  static void showSuccess(String message) {
    _show(message, background: AppColors.greenColor);
  }

  static void showInfo(String message) {
    _show(message, background: AppColors.mainColor);
  }

  static void _show(String message, {required Color background}) {
    final context = NavigationService().context;
    if (context == null) return;
    final topInset = MediaQuery.of(context).padding.top;
    Flushbar(
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: background,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.fromLTRB(16, topInset + 8, 16, 0),
      borderRadius: BorderRadius.circular(12),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    ).show(context);
  }
}
