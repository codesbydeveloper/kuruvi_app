import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/app_error_handler.dart';
import 'local_storage_service.dart';

class ApiClient {
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _localStorageService.getToken();

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      }
      final message = data is Map && data['message'] is String
          ? data['message'] as String
          : 'Something went wrong';
      throw AppException(message);
    } catch (e) {
      if (e is AppException) {
        AppErrorHandler.handle(e);
        throw e;
      }
      const fallback = 'Unable to process server response';
      AppErrorHandler.handle(e, fallbackMessage: fallback);
      throw AppException(fallback);
    }
  }
}
