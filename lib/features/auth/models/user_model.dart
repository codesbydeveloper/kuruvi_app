class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String role;
  final String? oneSignalId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.role,
    this.oneSignalId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      mobile: json['mobile'] ?? "",
      role: json['role'] ?? "",
      oneSignalId: json['oneSignalId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "mobile": mobile,
      "role": role,
      "oneSignalId": oneSignalId,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}