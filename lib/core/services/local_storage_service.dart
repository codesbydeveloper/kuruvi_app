import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const _tokenKey = "auth_token";
  static const _onboardedKey = 'onboarding_completed';
  static const _nearestStoreIdKey = "nearest_store_id";

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> setString(String key, String value) async {
    final prefs = await _getPrefs();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    return prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key);
  }

  Future<void> remove(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  // Token helpers
  Future<void> saveToken(String token) async {
    await setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await remove(_tokenKey);
  }

  // Onboarding helpers
  Future<bool> isOnboarded() async {
    return (await getBool(_onboardedKey)) ?? false;
  }

  Future<void> setOnboarded(bool value) async {
    await setBool(_onboardedKey, value);
  }

  // Nearest store helpers
  Future<void> saveNearestStoreId(String storeId) async {
    await setString(_nearestStoreIdKey, storeId);
  }

  Future<String?> getNearestStoreId() async {
    return getString(_nearestStoreIdKey);
  }

  Future<void> clearNearestStoreId() async {
    await remove(_nearestStoreIdKey);
  }
}
