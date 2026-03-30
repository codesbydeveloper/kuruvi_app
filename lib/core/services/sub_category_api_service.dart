import 'package:kuruvikal/core/constants/api_constants.dart';
import 'package:kuruvikal/core/services/api_client.dart';

class SubCategoryApiService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getSubCategories(String categoryId) async {
    final response =
        await _apiClient.get(ApiConstants.getSubCategories(categoryId));

    return response['data'];
  }
}
