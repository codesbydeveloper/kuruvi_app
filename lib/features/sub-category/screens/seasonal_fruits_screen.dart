import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:sizer/sizer.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';

class SeasonalFruitsScreen extends StatelessWidget {
  const SeasonalFruitsScreen({super.key});

  static const List<_FruitProduct> _products = [
    _FruitProduct(
      image: 'assets/product/fruit1.png',
      title: 'Lorem ipsum dolor sit ametisa, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit ametisa fafbust, consectetuer inaep adipiscing elit etgagp.',
      rating: 4.9,
      reviews: 236,
      quantity: '2 Piece',
      price: '₹ 45.00',
    ),
    _FruitProduct(
      image: 'assets/product/fruit2.png',
      title: 'Lorem ipsum dolor sit ametisa, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit ametisa fafbust, consectetuer inaep adipiscing elit etgagp.',
      rating: 4.5,
      reviews: 84,
      quantity: '8 Piece',
      price: '₹ 25.00',
    ),
    _FruitProduct(
      image: 'assets/product/fruit3.png',
      title: 'Lorem ipsum dolor sit ametisa, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit ametisa fafbust, consectetuer inaep adipiscing elit etgagp.',
      rating: 4.8,
      reviews: 236,
      quantity: '8 Piece',
      price: '₹ 96.00',
    ),
    _FruitProduct(
      image: 'assets/product/fruit4.png',
      title: 'Lorem ipsum dolor sit ametisa, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit ametisa fafbust, consectetuer inaep adipiscing elit etgagp.',
      rating: 4.5,
      reviews: 284,
      quantity: '6 Piece',
      price: '₹ 32.00',
    ),
    _FruitProduct(
      image: 'assets/product/fruit1.png',
      title: 'Lorem ipsum dolor sit ametisa, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit ametisa fafbust, consectetuer inaep adipiscing elit etgagp.',
      rating: 4.2,
      reviews: 238,
      quantity: '2 Piece',
      price: '₹ 45.00',
    ),
    _FruitProduct(
      image: 'assets/product/fruit2.png',
      title: 'Lorem ipsum dolor sit ametisa, consectetur adipiscing elit.',
      description: 'Lorem ipsum dolor sit ametisa fafbust, consectetuer inaep adipiscing elit etgagp.',
      rating: 4.5,
      reviews: 284,
      quantity: '8 Piece',
      price: '₹ 25.00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ── App Bar ────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => NavigationService().goBack(),
          child: const Icon(Icons.arrow_back_sharp, color: Colors.black),
        ),
        title: Text(
          'Seasonal Fruits',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          const Icon(Icons.search, color: AppColors.maroonColor, size: 22),
          const SizedBox(width: 16),
          const Icon(Icons.share_outlined, color: AppColors.maroonColor, size: 22),
          const SizedBox(width: 16),
        ],
      ),

      // ── Bottom bar ─────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        color: const Color(0xFF00897B),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'FREE DELIVERY ON ORDER ABOVE ₹99',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── Body: 2-column grid ────────────────────────────────────────────
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) =>
            _FruitCard(product: _products[index]),
      ),
    );
  }
}

// ── Fruit card ────────────────────────────────────────────────────────────────

class _FruitCard extends StatelessWidget {
  const _FruitCard({required this.product});
  final _FruitProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──────────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Image.asset(
                  product.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: const Color(0xFFF0F4F0),
                    child: const Center(
                      child: Icon(Icons.image_outlined,
                          size: 36, color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),
              ),
              // Bookmark (top-left)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.bookmark_border,
                      size: 15, color: AppColors.maroonColor),
                ),
              ),
              // Add button (top-right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00897B),
                    shape: BoxShape.circle,
                      border: BoxBorder.symmetric(vertical: BorderSide(color: Colors.white, width: 2), horizontal: BorderSide(color: Colors.white, width: 2))
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
              // Rating badge (bottom-left, overlapping image)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          size: 11, color: Color(0xFFFFC107)),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating} (${product.reviews})',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Details ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF9E9E9E),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),

                // Quantity selector + Price
                Row(
                  children: [
                    // Quantity pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: const Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.quantity,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF444444),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 12, color: Color(0xFF888888)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Price
                    Text(
                      product.price,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00897B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _FruitProduct {
  final String image;
  final String title;
  final String description;
  final double rating;
  final int reviews;
  final String quantity;
  final String price;

  const _FruitProduct({
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.quantity,
    required this.price,
  });
}
