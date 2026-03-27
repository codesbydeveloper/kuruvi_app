import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/utils/logger.dart';
import 'package:kuruvikal/core/widgets/location_permission_dialog.dart';
import 'package:kuruvikal/core/widgets/location_service_disabled_dialog.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  static const Duration _settingsPollInterval = Duration(seconds: 1);
  static const Duration _settingsPollTimeout = Duration(seconds: 10);

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
        AppLogger.warning('Location services are disabled');
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
      AppLogger.error('Error getting current location: $e');
      return null;
    }
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
