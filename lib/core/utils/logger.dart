import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String tag = 'APP'}) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void error(String message, {String tag = 'ERROR', Object? error}) {
    if (kDebugMode) {
      print('[$tag] $message');
      if (error != null) {
        print('Error Details: $error');
      }
    }
  }

  static void success(String message, {String tag = 'SUCCESS'}) {
    if (kDebugMode) {
      print('[$tag] ✓ $message');
    }
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      print('[$tag] ⚠ $message');
    }
  }
}
