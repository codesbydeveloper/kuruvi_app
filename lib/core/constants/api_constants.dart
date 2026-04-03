class ApiConstants {
  static const bool isProduction = false;

  static const String prodBaseUrl = "https://admin.kuruvikal.in/";
  static const String localBaseUrl = "http://43.205.241.171/api/v1/";

  static String get baseUrl =>
      isProduction ? prodBaseUrl : localBaseUrl;

  // auth
  static const String sendOtp = "auth/send-otp";
  static const String login = "auth/login";

  // category
  static const String getCategories = "categories/menu";

  // sub-categories
  static String getSubCategories(String categoryId) =>
      "categories/$categoryId/subcategories";

  // inventory products by store + sub-category
  static String getInventoryProducts(
    String storeId,
    String categoryId,
  ) =>
      "inventories/$storeId/products?categoryId=$categoryId";

  // get stores
  static const String nearestStore = "stores/nearest";
}
