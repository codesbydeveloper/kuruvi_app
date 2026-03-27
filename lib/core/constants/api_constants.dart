class ApiConstants {
  static const bool isProduction = false;

  static const String prodBaseUrl = "https://admin.kuruvikal.in/";
  static const String localBaseUrl = "http://43.205.241.171/api/";

  static String get baseUrl =>
      isProduction ? prodBaseUrl : localBaseUrl;

  // auth
  static const String sendOtp = "auth/send-otp";
  static const String login = "auth/login";

  // category
  static const String getCategories = "categories/menu";

  // get stores
  static const String nearestStore = "stores/nearest";
}
