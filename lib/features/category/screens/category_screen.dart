import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/features/category/providers/category_provider.dart';
import 'package:kuruvikal/features/sub-category/screens/sub_category_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoryProvider>().fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Gradient top section ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.categoryTopGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // ── Top bar ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Image.asset(ImageAssetPath.locationIcon),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Subhlaxmi Residency',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blackTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: AppColors.blackTextColor,
                                  ),
                                ],
                              ),
                              Text(
                                'C.R. Colony, Dindoli, Surat, Gujarat 394210, India',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.blackTextColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.yellowColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(ImageAssetPath.profileIcon),
                        ),
                      ],
                    ),
                  ),

                  // ── Search bar ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.borderGreyLightColor),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Search for the Products...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.search,
                                  color: AppColors.brownColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _TopIconButton(icon: Icons.edit_square),
                        const SizedBox(width: 8),
                        _TopIconButton(icon: Icons.bookmark_border),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Coming Soon banner (no card — blends into gradient) ──
                  const _ComingSoonBanner(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── White scrollable category list ───────────────────────────────
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                ...provider.categories.map((category) {
                  if (category.children.isEmpty) {
                    return const SizedBox();
                  }
                  return _CategorySection(category: category);
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Top icon button ──────────────────────────────────────────────────────────

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGreyLightColor),
      ),
      child: Icon(icon, size: 20, color: AppColors.iconGreyColor),
    );
  }
}

// ── Coming Soon banner ───────────────────────────────────────────────────────

class _ComingSoonBanner extends StatelessWidget {
  const _ComingSoonBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comming Soon to\nYour Area!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackTextColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Try changing your location',
                  style:
                  TextStyle(fontSize: 14.sp, color: Color(0xFF5E5E5E)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 90,
            child:
            Image.asset(ImageAssetPath.houseImage, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

// ── Category section ─────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category});
  final dynamic category;

  @override
  Widget build(BuildContext context) {
    final children = category.children as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackTextColor,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.brownColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        LayoutBuilder(
          builder: (context, constraints) {
            const double horizontalPadding = 16;
            const double crossAxisSpacing = 10;
            const double mainAxisSpacing = 12;

            final double tileWidth =
                (constraints.maxWidth - (horizontalPadding * 2) - (crossAxisSpacing * 3)) /
                    4;
            final double imageHeight = tileWidth;
            final double tileHeight = imageHeight + 36; // image + label space
            final double aspectRatio = tileWidth / tileHeight;

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: children.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, index) {
                final sub = children[index];
                return _ProductTile(
                  sub: sub,
                  tileWidth: tileWidth,
                  imageHeight: imageHeight,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ── Product tile ─────────────────────────────────────────────────────────────

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.sub,
    required this.tileWidth,
    required this.imageHeight,
  });

  final dynamic sub;
  final double tileWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService().push(const SubCategoryScreen());
      },
      child: SizedBox(
        width: tileWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image tile with border
            Container(
              width: tileWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.borderGreyLightColor2, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: CachedNetworkImage(
                    imageUrl: sub.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.borderGreyLightColor2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.borderGreyLightColor2,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Label
            Text(
              sub.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
