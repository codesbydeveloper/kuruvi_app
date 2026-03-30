import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/api_constants.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/features/sub-category/models/inventory_product_model.dart';
import 'package:kuruvikal/features/sub-category/providers/sub_category_provider.dart';
import 'package:kuruvikal/features/sub-category/screens/seasonal_fruits_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
  });
  final String categoryId;
  final String? categoryName;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  int _selectedCategoryIndex = 0;
  String? _selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<SubCategoryProvider>();
      await provider.fetchSubCategories(widget.categoryId);
      if (!mounted) return;
      if (provider.subCategories.isNotEmpty) {
        final first = provider.subCategories.first;
        setState(() {
          _selectedCategoryIndex = 0;
          _selectedSubCategoryId = first.id;
        });
        await provider.fetchProductsForSubCategory(first.id);
      }
    });
  }

  List<_ProductItem> _mapProducts(List<InventoryProduct> items) {
    return items.map((item) {
      final variant = item.variant;
      final name = variant.product.name.isNotEmpty
          ? variant.product.name
          : 'Product';
      final brand = variant.product.brand;
      final weightLabel = variant.size.isNotEmpty && variant.unit.isNotEmpty
          ? '${variant.size}${variant.unit}'
          : (variant.weight > 0 ? '${variant.weight}g' : '1 pc');
      final imageUrl = _resolveImageUrl(
          variant.images.isNotEmpty ? variant.images.first : '');

      return _ProductItem(
        title: name,
        description: brand.isNotEmpty ? brand : ' ',
        weight: weightLabel,
        originalPrice:
            variant.mrp > 0 ? '₹ ${variant.mrp.toStringAsFixed(0)}' : null,
        discountedPrice: '₹ ${item.price.toStringAsFixed(0)}',
        rating: null,
        reviews: null,
        image: imageUrl,
      );
    }).toList();
  }

  String _resolveImageUrl(String raw) {
    if (raw.isEmpty) return '';
    if (raw.startsWith('http')) return raw;
    final base = ApiConstants.baseUrl.replaceAll('/api/', '/');
    return '$base$raw';
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubCategoryProvider>();
    final subCategories = provider.subCategories;
    final title = widget.categoryName ?? provider.category?.name ?? 'Sub Category';
    final products = _mapProducts(provider.products);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => NavigationService().goBack(),
          child: const Icon(Icons.arrow_back_sharp, color: Colors.black),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color:Colors.black, size: 22),
          ),
        ],
      ),

      // ── Bottom bar ───────────────────────────────────────────────────────
      bottomNavigationBar: Container(
        color: AppColors.greenColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'FREE DELIVERY ON ORDER ABOVE ₹99',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.whiteColor,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── Body: sidebar + content side by side ─────────────────────────────
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left category sidebar ──────────────────────────────────────
          SizedBox(
            width: 80,
            child: provider.isLoading && subCategories.isEmpty
                ? const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : subCategories.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            'No sub categories',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.greyTextColor,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: subCategories.length,
                        itemBuilder: (context, index) {
                          final cat = subCategories[index];
                          final isSelected = _selectedSubCategoryId != null
                              ? _selectedSubCategoryId == cat.id
                              : _selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                                _selectedSubCategoryId = cat.id;
                              });
                              provider.fetchProductsForSubCategory(cat.id);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  // Category image inside rounded tile
                                  Container(
                                    width: 55,
                                    height: 55,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.yellowColor
                                            : AppColors
                                                .borderGreyLightColor2,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: CachedNetworkImage(
                                        imageUrl: cat.image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors
                                                  .borderGreyLightColor2,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.category_outlined,
                                          size: 22,
                                          color: AppColors.iconGreyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cat.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.blackTextColor
                                          : AppColors.greyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          Container(
            width: 2,
            height: double.infinity,
            color: AppColors.verticalBorderColor,
          ),

          // ── Right content area ─────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner — fixed: uses ClipRRect + BoxFit.cover so the
                // image actually fills the container instead of floating
                // on top of it.
                const _BannerWidget(),

                // Filter row
                const _FilterRow(),

                // Tag chips
                const _TagChips(),

                // Product grid
                Expanded(
                  child: provider.isProductsLoading
                      ? const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : products.isEmpty
                          ? Center(
                              child: Text(
                                'No products available',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.greyTextColor,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              itemCount: (products.length / 2).ceil(),
                              itemBuilder: (context, rowIndex) {
                                final leftIndex = rowIndex * 2;
                                final rightIndex = leftIndex + 1;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: _ProductCard(
                                            product: products[leftIndex]),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: rightIndex < products.length
                                            ? _ProductCard(
                                                product:
                                                    products[rightIndex])
                                            : const SizedBox(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Banner widget ─────────────────────────────────────────────────────────────
// Fixed: ClipRRect wraps the Image so it respects the border radius, and
// BoxFit.cover ensures it fills the container properly.

class _BannerWidget extends StatelessWidget {
  const _BannerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Gradient shows if image fails / has transparent areas
        gradient: AppColors.subCategoryGradient,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          ImageAssetPath.subCategoryBannerImage,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.image_outlined,
                size: 36, color: AppColors.iconGreyColor),
          ),
        ),
      ),
    );
  }
}

// ── Filter row ────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            _FilterChipWidget(label: 'Sort By', hasArrow: true),
            SizedBox(width: 6),
            _FilterChipWidget(label: 'Type',    hasArrow: true),
            SizedBox(width: 6),
            _FilterChipWidget(label: 'Brand',   hasArrow: true),
            SizedBox(width: 6),
            _FilterChipWidget(label: 'Price',   hasArrow: true),
          ],
        ),
      ),
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  const _FilterChipWidget({required this.label, this.hasArrow = false});
  final String label;
  final bool hasArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.greyTextColor2,
            ),
          ),
          if (hasArrow) ...[
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down,
                size: 12, color: AppColors.greyTextColor2),
          ],
        ],
      ),
    );
  }
}

// ── Tag chips ─────────────────────────────────────────────────────────────────

class _TagChips extends StatelessWidget {
  const _TagChips();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          _TagChipItem(
            icon: Icons.arrow_downward,
            label: 'Price Drop',
            iconColor: AppColors.greenColor,
          ),
          SizedBox(width: 6),
          _TagChipItem(
            icon: Icons.star,
            label: 'Best Seller',
            iconColor: AppColors.yellowColor,
          ),
          SizedBox(width: 6),
          _TagChipItem(
            icon: Icons.trending_up,
            label: 'Trending',
            iconColor: AppColors.greenColor,
          ),
        ],
      ),
    );
  }
}

class _TagChipItem extends StatelessWidget {
  const _TagChipItem({
    required this.icon,
    required this.label,
    required this.iconColor,
  });
  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.greyTextColor2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final _ProductItem product;

  Widget _buildImage() {
    if (product.image.isEmpty) {
      return Container(
        height: 130,
        color: AppColors.borderGreyLightColor2,
        child: Center(
          child: Icon(Icons.image_outlined,
              size: 36, color: AppColors.iconGreyColor),
        ),
      );
    }

    if (product.image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: product.image,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 130,
          color: AppColors.borderGreyLightColor2,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.borderGreyLightColor2,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 130,
          color: AppColors.borderGreyLightColor2,
          child: Center(
            child: Icon(Icons.image_outlined,
                size: 36, color: AppColors.iconGreyColor),
          ),
        ),
      );
    }

    return Image.asset(
      product.image,
      height: 130,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 130,
        color: AppColors.borderGreyLightColor2,
        child: Center(
          child: Icon(Icons.image_outlined,
              size: 36, color: AppColors.iconGreyColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          NavigationService().push(const SeasonalFruitsScreen()),
      child: Container(
        decoration:  BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ───────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  child: _buildImage(),
                ),
                // Bookmark icon (top-left)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(Icons.bookmark_border,
                        size: 16, color: AppColors.brownColor),
                  ),
                ),
                // Add button (top-right)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      shape: BoxShape.circle,
                      border: BoxBorder.symmetric(vertical: BorderSide(color: AppColors.whiteColor, width: 2), horizontal: BorderSide(color: Colors.white, width: 2))
                    ),
                    child:
                    const Icon(Icons.add, size: 16, color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),

            // ── Details ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.rating != null &&
                      product.reviews != null) ...[
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: 10, color: AppColors.greenColor),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating} (${product.reviews})',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greenColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                  ],

                  // Title
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Description
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.greyTextColor2,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Weight selector
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "26% Off",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brownColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderGreyLightColor2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.weight,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.greyTextColor2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Row(
                        children: [
                          Text(
                            product.discountedPrice,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.greenColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (product.originalPrice != null)
                            Text(
                              product.originalPrice!,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackTextColor,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 3,
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

/// Fixed: `image` is now a proper named required field.
/// Fixed: `image` field added; both the class definition and all
/// instantiation sites are consistent.
class _ProductItem {
  final String title;
  final String description;
  final String weight;
  final String? originalPrice;
  final String discountedPrice;
  final double? rating;
  final int? reviews;
  final String image;

  const _ProductItem({
    required this.title,
    required this.description,
    required this.weight,
    this.originalPrice,
    required this.discountedPrice,
    this.rating,
    this.reviews,
    required this.image,
  });
}
