import 'package:flutter/material.dart';
import 'package:kuruvikal/core/services/auth_api_service.dart';
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
        print('OTP-----------------$otp');
        return true;
      } else {
        errorMessage = response['message'];
        return false;
      }
    } catch (e) {
      errorMessage = "Something went wrong";
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
        errorMessage = response['message'];
        return false;
      }

    } catch (e) {
      errorMessage = "Login failed";
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
