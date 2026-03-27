class CategoryMenuModel {
  final String id;
  final String name;
  final List<SubCategory> children;

  CategoryMenuModel({
    required this.id,
    required this.name,
    required this.children,
  });

  factory CategoryMenuModel.fromJson(Map<String, dynamic> json) {
    return CategoryMenuModel(
      id: json['_id'],
      name: json['name'],
      children: (json['children'] as List)
          .map((e) => SubCategory.fromJson(e))
          .toList(),
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String image;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'] ?? '',
    );
  }
}