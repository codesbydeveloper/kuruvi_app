import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kuruvikal/core/constants/api_keys.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/utils/app_error_handler.dart';
import 'package:kuruvikal/core/utils/app_snackbar.dart';
import 'package:kuruvikal/core/widgets/location_permission_dialog.dart';
import 'package:kuruvikal/core/widgets/location_service_disabled_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressInfo {
  final String title;
  final String subtitle;
  const AddressInfo({required this.title, required this.subtitle});
}

class PlaceSuggestion {
  final String description;
  final String placeId;
  const PlaceSuggestion({required this.description, required this.placeId});
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  static const Duration _settingsPollInterval = Duration(seconds: 1);
  static const Duration _settingsPollTimeout = Duration(seconds: 10);
  static const String _googleApiKey = ApiKeys.googleGeocodingApiKey;
  static const String _googlePlacesApiKey = ApiKeys.googlePlacesApiKey;

  Future<bool> _showPermissionDialog() async {
    final context = NavigationService().context;
    if (context == null) return false;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LocationPermissionDialog(),
    );
    return result ?? false;
  }

  Future<bool> _showServiceDisabledDialog() async {
    final context = NavigationService().context;
    if (context == null) return false;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LocationServiceDisabledDialog(),
    );
    if (result == true) {
      await Geolocator.openLocationSettings();
    }
    return result ?? false;
  }

  Future<bool> _waitForServiceEnabled() async {
    final endTime = DateTime.now().add(_settingsPollTimeout);
    while (DateTime.now().isBefore(endTime)) {
      if (await Geolocator.isLocationServiceEnabled()) return true;
      await Future.delayed(_settingsPollInterval);
    }
    return false;
  }

  Future<bool> _waitForPermissionGranted() async {
    final endTime = DateTime.now().add(_settingsPollTimeout);
    while (DateTime.now().isBefore(endTime)) {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      }
      await Future.delayed(_settingsPollInterval);
    }
    return false;
  }

  /// Get single location update (useful for one-time checks)
  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.showInfo('Location services are disabled');
        final approved = await _showServiceDisabledDialog();
        if (!approved) return null;
        final enabledAfterSettings = await _waitForServiceEnabled();
        if (!enabledAfterSettings) return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          final approved = await _showPermissionDialog();
          if (!approved) return null;
          permission = await Geolocator.requestPermission();
        }
      } else if (permission == LocationPermission.deniedForever) {
        final approved = await _showPermissionDialog();
        if (!approved) return null;
        await Geolocator.openAppSettings();
        final grantedAfterSettings = await _waitForPermissionGranted();
        if (!grantedAfterSettings) return null;
        permission = await Geolocator.checkPermission();
      }

      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return position;
    } catch (e) {
      AppErrorHandler.handle(e, fallbackMessage: 'Unable to get location');
      return null;
    }
  }

  Future<AddressInfo?> getCurrentAddressInfo() async {
    final position = await getCurrentLocation();
    if (position == null) return null;

    try {
      if (_googleApiKey.isEmpty) {
        AppSnackBar.showInfo('Location unavailable');
        return const AddressInfo(
          title: 'Your Location',
          subtitle: 'Location unavailable',
        );
      }

      return await _fetchAddressFromGoogle(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      AppErrorHandler.handle(e, fallbackMessage: 'Unable to get address');
      return null;
    }
  }

  Future<AddressInfo?> _fetchAddressFromGoogle({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '$latitude,$longitude',
      'key': _googleApiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      AppErrorHandler.handleMessage('Unable to fetch address');
      return null;
    }

    final data = jsonDecode(response.body);
    if (data is! Map) return null;
    if (data['status'] != 'OK') {
      AppSnackBar.showInfo('Location unavailable');
      return null;
    }

    final results = data['results'];
    if (results is! List || results.isEmpty) return null;
    final first = results.first as Map;

    final formatted = (first['formatted_address'] ?? '').toString();
    final components = (first['address_components'] as List?) ?? const [];

    String title = '';
    for (final c in components) {
      if (c is! Map) continue;
      final types = (c['types'] as List?)?.cast<String>() ?? const [];
      if (types.contains('sublocality') ||
          types.contains('sublocality_level_1') ||
          types.contains('locality')) {
        title = (c['long_name'] ?? '').toString();
        if (title.isNotEmpty) break;
      }
    }

    return AddressInfo(
      title: title.isEmpty ? 'Your Location' : title,
      subtitle: formatted.isEmpty ? 'Location unavailable' : formatted,
    );
  }

  Future<AddressInfo?> fetchAddressFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      if (_googleApiKey.isEmpty) {
        AppSnackBar.showInfo('Location unavailable');
        return const AddressInfo(
          title: 'Your Location',
          subtitle: 'Location unavailable',
        );
      }
      return await _fetchAddressFromGoogle(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      AppErrorHandler.handle(e, fallbackMessage: 'Unable to fetch address');
      return null;
    }
  }

  Future<List<PlaceSuggestion>> fetchPlaceSuggestions(String input) async {
    if (input.trim().isEmpty) return [];
    if (_googlePlacesApiKey.isEmpty) return [];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': input,
        'key': _googlePlacesApiKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      AppErrorHandler.handleMessage('Unable to fetch places');
      return [];
    }

    final data = jsonDecode(response.body);
    if (data is! Map) return [];
    if (data['status'] != 'OK') {
      AppSnackBar.showInfo('No places found');
      return [];
    }

    final predictions = data['predictions'];
    if (predictions is! List) return [];

    return predictions
        .whereType<Map>()
        .map((p) => PlaceSuggestion(
              description: (p['description'] ?? '').toString(),
              placeId: (p['place_id'] ?? '').toString(),
            ))
        .where((p) => p.description.isNotEmpty && p.placeId.isNotEmpty)
        .toList();
  }

  Future<LatLng?> fetchLatLngFromPlaceId(String placeId) async {
    if (placeId.trim().isEmpty) return null;
    if (_googlePlacesApiKey.isEmpty) return null;

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'fields': 'geometry',
        'key': _googlePlacesApiKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      AppErrorHandler.handleMessage('Unable to fetch place details');
      return null;
    }

    final data = jsonDecode(response.body);
    if (data is! Map) return null;
    if (data['status'] != 'OK') {
      AppSnackBar.showInfo('Place details unavailable');
      return null;
    }

    final result = data['result'];
    final geometry = result is Map ? result['geometry'] : null;
    final location = geometry is Map ? geometry['location'] : null;
    final lat = location is Map ? location['lat'] : null;
    final lng = location is Map ? location['lng'] : null;
    if (lat is num && lng is num) {
      return LatLng(lat.toDouble(), lng.toDouble());
    }
    return null;
  }

  /// Calculate distance between two positions (in meters)
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
