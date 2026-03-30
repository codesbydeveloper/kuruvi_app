class SubCategoryResponse {
  final String id;
  final String name;
  final String image;
  final List<SubCategoryItem> subCategories;

  SubCategoryResponse({
    required this.id,
    required this.name,
    required this.image,
    required this.subCategories,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    final subCategoriesJson = json['subCategories'] as List? ?? [];
    return SubCategoryResponse(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      subCategories: subCategoriesJson
          .map((e) => SubCategoryItem.fromJson(e))
          .toList()
          .cast<SubCategoryItem>(),
    );
  }
}

class SubCategoryItem {
  final String id;
  final String name;
  final String image;

  SubCategoryItem({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategoryItem.fromJson(Map<String, dynamic> json) {
    return SubCategoryItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
