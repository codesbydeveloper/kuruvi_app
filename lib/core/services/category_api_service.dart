import 'package:kuruvikal/core/constants/api_constants.dart';

import '../../../core/services/api_client.dart';

class CategoryApiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getCategories() async {
    final response =
    await _apiClient.get(ApiConstants.getCategories);

    return response['data'];
  }
}