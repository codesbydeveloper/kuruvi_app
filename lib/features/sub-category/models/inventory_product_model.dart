class InventoryProduct {
  final String id;
  final ProductVariant variant;
  final double price;
  final int stock;

  InventoryProduct({
    required this.id,
    required this.variant,
    required this.price,
    required this.stock,
  });

  factory InventoryProduct.fromJson(Map<String, dynamic> json) {
    final stockValue = json['stock'];
    return InventoryProduct(
      id: json['_id'] ?? '',
      variant: ProductVariant.fromJson(json['variantId'] ?? {}),
      price: (json['price'] ?? 0).toDouble(),
      stock: stockValue is num
          ? stockValue.toInt()
          : int.tryParse(stockValue?.toString() ?? '') ?? 0,
    );
  }
}

class ProductVariant {
  final String id;
  final ProductInfo product;
  final String sku;
  final double mrp;
  final String size;
  final String unit;
  final int weight;
  final List<String> images;
  final Map<String, dynamic> attributes;

  ProductVariant({
    required this.id,
    required this.product,
    required this.sku,
    required this.mrp,
    required this.size,
    required this.unit,
    required this.weight,
    required this.images,
    required this.attributes,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List? ?? [];
    return ProductVariant(
      id: json['_id'] ?? '',
      product: ProductInfo.fromJson(json['productId'] ?? {}),
      sku: json['sku'] ?? '',
      mrp: (json['mrp'] ?? 0).toDouble(),
      size: json['size']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      weight: (json['weight'] ?? 0) as int,
      images: rawImages.map((e) => e.toString()).toList(),
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
    );
  }
}

class ProductInfo {
  final String id;
  final String name;
  final String brand;

  ProductInfo({
    required this.id,
    required this.name,
    required this.brand,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
    );
  }
}
