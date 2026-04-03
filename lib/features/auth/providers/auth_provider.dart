import 'package:flutter/material.dart';
import 'package:kuruvikal/core/services/auth_api_service.dart';
import 'package:kuruvikal/core/utils/app_error_handler.dart';
import 'package:kuruvikal/core/utils/logger.dart';
import '../../../core/services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _apiService = AuthApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  bool isLoading = false;
  String? otp;
  String? errorMessage;

  Future<bool> sendOtp(String mobile) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _apiService.sendOtp(mobile);

      if (response['success'] == true) {
        otp = response['otp']?.toString();
        AppLogger.log("OTP sent: $otp");
        return true;
      } else {
        errorMessage = response['message']?.toString() ?? 'Failed to send OTP';
        AppErrorHandler.handleMessage(errorMessage!);
        return false;
      }
    } catch (e) {
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = "Something went wrong";
        AppErrorHandler.handle(e, fallbackMessage: errorMessage);
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String mobile, String enteredOtp) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _apiService.login(
        mobile: mobile,
        otp: enteredOtp,
      );

      if (response['success'] == true) {
        final token = response['token'];

        await _localStorageService.saveToken(token);
        return true;
      } else {
        errorMessage = response['message']?.toString() ?? 'Login failed';
        AppErrorHandler.handleMessage(errorMessage!);
        return false;
      }

    } catch (e) {
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = "Login failed";
        AppErrorHandler.handle(e, fallbackMessage: errorMessage);
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _localStorageService.clearToken();
  }
}
