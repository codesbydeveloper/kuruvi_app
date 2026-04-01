import 'package:kuruvikal/core/utils/app_snackbar.dart';
import 'package:kuruvikal/core/utils/logger.dart';

class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class AppErrorHandler {
  static void handle(Object error, {String? fallbackMessage}) {
    final message = _extractMessage(error) ?? fallbackMessage ?? 'Something went wrong';
    AppLogger.error(message, error: error);
    AppSnackBar.showError(message);
  }

  static void handleMessage(String message) {
    AppLogger.error(message);
    AppSnackBar.showError(message);
  }

  static String? _extractMessage(Object error) {
    if (error is AppException) return error.message;
    final text = error.toString();
    if (text.startsWith('Exception: ')) {
      return text.replaceFirst('Exception: ', '').trim();
    }
    if (text.isNotEmpty) return text;
    return null;
  }
}
