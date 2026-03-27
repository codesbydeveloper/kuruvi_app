import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';

class AuthApiService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    return await _apiClient.post(
      ApiConstants.sendOtp,
      {"mobile": mobile},
    );
  }

  Future<Map<String, dynamic>> login({
    required String mobile,
    required String otp,
  }) async {
    return await _apiClient.post(
      ApiConstants.login,
      {
        "mobile": mobile,
        "otp": otp,
        'adminemail': 'gaurav@gmail.com',
        'adminpassword': '123',
      },
    );
  }
}