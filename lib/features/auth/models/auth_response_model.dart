
import 'package:kuruvikal/features/auth/models/user_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final UserModel user;
  final String token;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      user: UserModel.fromJson(json['user'] ?? {}),
      token: json['token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "user": user.toJson(),
      "token": token,
    };
  }
}