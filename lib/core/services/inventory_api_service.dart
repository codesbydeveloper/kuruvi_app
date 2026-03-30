import 'package:kuruvikal/core/constants/api_constants.dart';
import 'package:kuruvikal/core/services/api_client.dart';

class InventoryApiService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getProductsBySubCategory(
    String storeId,
    String subCategoryId,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.getInventoryProducts(storeId, subCategoryId),
    );

    return response['data'];
  }
}
