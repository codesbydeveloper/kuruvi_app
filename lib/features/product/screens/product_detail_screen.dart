import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/features/product/screens/order_summery_screen.dart';
import 'package:sizer/sizer.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedWeightIndex = 3; // 1kg selected by default
  bool _sellerExpanded = true;
  bool _otherInfoExpanded = true;
  int _currentImageIndex = 0;
  String _selectedPiece = '7 Piece';

  final List<Map<String, dynamic>> _weightOptions = [
    {'label': '250g', 'price': '₹ 35'},
    {'label': '500g', 'price': '₹ 50'},
    {'label': '750g', 'price': '₹ 70'},
    {'label': '1kg', 'price': '₹ 90'},
  ];

  // Placeholder colors for weight option images
  final List<Color> _weightColors = [
    const Color(0xFFE8F5E9),
    const Color(0xFFFFF3E0),
    const Color(0xFFFFEBEE),
    const Color(0xFFE8F5E9),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Image Section ──
                  _buildHeroImage(context),

                  // ── Weight Selector ──
                  _buildWeightSelector(),

                  // ── Product Card (scrollable bottom sheet style) ──
                  _buildProductCard(),

                  const SizedBox(height: 16),

                  // ── Explore all Fruits & Vegetables ──
                  _buildExploreSection(),

                  const SizedBox(height: 16),

                  // ── Seller Details ──
                  _buildSellerDetails(),

                  // ── Other Information ──
                  _buildOtherInformation(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Hero Image
  // ────────────────────────────────────────────────
  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      children: [
        // Main image placeholder
        Image.asset(
          ImageAssetPath.home2,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: _circleButton(
            icon: Icons.keyboard_arrow_down,
            onTap: () => Navigator.maybePop(context),
          ),
        ),

        // Bookmark button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 56,
          child: _circleButton(icon: Icons.bookmark_border, onTap: () {}),
        ),

        // Share button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: _circleButton(icon: Icons.share_outlined, onTap: () {}),
        ),

        // "15 Mins" badge
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '15 Mins',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Page indicator dots
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentImageIndex ? 10 : 8,
                height: i == _currentImageIndex ? 10 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _currentImageIndex
                      ? AppColors.redColor
                      : Colors.white.withOpacity(0.7),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.blackTextColor),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Weight Selector
  // ────────────────────────────────────────────────
  Widget _buildWeightSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Select Weight:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A2A2A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Red Strawberry',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 15.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _weightOptions.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedWeightIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedWeightIndex = index),
                  child: Container(
                    width: 22.w,
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        // Image box
                        Stack(
                          children: [
                            Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: _weightColors[index],
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.greenColor,
                                        width: 2,
                                      )
                                    : Border.all(
                                        color: AppColors.greyLightColor,
                                        width: 1,
                                      ),
                              ),
                              child: Center(
                                child: Image.asset(ImageAssetPath.home2),
                              ),
                            ),
                            // Radio circle top-right
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.greenColor
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.greenColor
                                        : AppColors.greyLightColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 10,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _weightOptions[index]['label'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                        Text(
                          _weightOptions[index]['price'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Product Card
  // ────────────────────────────────────────────────
  Widget _buildProductCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGreyLightColor2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Strawberry',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A2A2A),
            ),
          ),
          const SizedBox(height: 6),
          // Description
          Text(
            'Lorem ipsum dolor amet, consectetuer adipiscing elit aenean com modo ligula eget dolor.',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.greyTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          // Weight label
          const Text(
            '1kg',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A2A2A),
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.greyLightColor, height: 1),
          const SizedBox(height: 12),

          // Discount + Piece selector + ADD button row
          Row(
            children: [
              // Discount badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '32% Off',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE65100),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Piece dropdown
              _buildPieceDropdown(),
              const Spacer(),
              // ADD button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'ADD',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Price row
          Row(
            children: [
              Text(
                '₹ 84',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greenColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹ 90',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyTextColor2,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // View Products Details
          Center(
            child: GestureDetector(
              onTap: () {
                NavigationService().push(OrderSummaryScreen());
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Products Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.greenColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieceDropdown() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: ['7 Piece', '14 Piece', '21 Piece']
                .map(
                  (e) => ListTile(
                    title: Text(e),
                    onTap: () {
                      setState(() => _selectedPiece = e);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyLightColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedPiece,
              style: TextStyle(fontSize: 12, color: AppColors.blackTextColor),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.greyTextColor,
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Explore Section
  // ────────────────────────────────────────────────
  Widget _buildExploreSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.store_outlined,
              color: Color(0xFFE65100),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Explore all Fruits & Vegetables Item',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),
          ),
          Icon(Icons.double_arrow, color: AppColors.greyTextColor, size: 20),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Seller Details
  // ────────────────────────────────────────────────
  Widget _buildSellerDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          GestureDetector(
            onTap: () => setState(() => _sellerExpanded = !_sellerExpanded),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Seller Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2A2A),
                    ),
                  ),
                ),
                Icon(
                  _sellerExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.greyTextColor,
                ),
              ],
            ),
          ),
          if (_sellerExpanded) ...[
            const SizedBox(height: 10),
            Text(
              'Seller Name: Swinsta Ent Pvt Ltd - Vesu - Surat',
              style: TextStyle(fontSize: 13, color: AppColors.greyTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              'FSSAI Number: 518154894505112',
              style: TextStyle(fontSize: 13, color: AppColors.greyTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              '........',
              style: TextStyle(fontSize: 13, color: AppColors.greyTextColor),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Show More +',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greenColor,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: AppColors.greyLightColor, height: 1),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Other Information
  // ────────────────────────────────────────────────
  Widget _buildOtherInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () =>
                setState(() => _otherInfoExpanded = !_otherInfoExpanded),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Other Information',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2A2A),
                    ),
                  ),
                ),
                Icon(
                  _otherInfoExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.greyTextColor,
                ),
              ],
            ),
          ),
          if (_otherInfoExpanded) ...[
            const SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.greyTextColor,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Show More +',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greenColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
