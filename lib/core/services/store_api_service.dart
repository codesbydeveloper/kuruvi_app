import 'package:kuruvikal/core/constants/api_constants.dart';
import 'package:kuruvikal/core/services/api_client.dart';

class StoreApiService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> getNearestStore({
    required double lat,
    required double lng,
  }) async {
    return _apiClient.post(
      ApiConstants.nearestStore,
      {
        "lat": lat.toString(),
        "lng": lng.toString(),
      },
    );
  }
}
