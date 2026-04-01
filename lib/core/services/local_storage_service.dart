import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const _tokenKey = "auth_token";
  static const _onboardedKey = 'onboarding_completed';
  static const _nearestStoreIdKey = "nearest_store_id";
  static const _nearestStoreEtaKey = "nearest_store_eta";
  static const _recentSearchesKey = "recent_searches";

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

  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _getPrefs();
    await prefs.setStringList(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key);
  }

  Future<List<String>> getStringList(String key) async {
    final prefs = await _getPrefs();
    return prefs.getStringList(key) ?? <String>[];
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

  // Nearest store ETA helpers
  Future<void> saveNearestStoreEta(String eta) async {
    await setString(_nearestStoreEtaKey, eta);
  }

  Future<String?> getNearestStoreEta() async {
    return getString(_nearestStoreEtaKey);
  }

  Future<void> clearNearestStoreEta() async {
    await remove(_nearestStoreEtaKey);
  }

  // Recent search helpers
  Future<List<String>> getRecentSearches() async {
    return getStringList(_recentSearchesKey);
  }

  Future<void> saveRecentSearches(List<String> searches) async {
    await setStringList(_recentSearchesKey, searches);
  }

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final list = await getRecentSearches();
    list.removeWhere((e) => e.toLowerCase() == trimmed.toLowerCase());
    list.insert(0, trimmed);
    if (list.length > 5) {
      list.removeRange(5, list.length);
    }
    await saveRecentSearches(list);
  }

  Future<void> clearRecentSearches() async {
    await remove(_recentSearchesKey);
  }
}
