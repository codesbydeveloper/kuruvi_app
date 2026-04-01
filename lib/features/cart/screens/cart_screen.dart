import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:sizer/sizer.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';

class CartItem {
  final String name;
  final String weight;
  final int originalPrice;
  final int discountedPrice;
  int qty;

  CartItem({
    required this.name,
    required this.weight,
    required this.originalPrice,
    required this.discountedPrice,
    this.qty = 1,
  });
}

class SuggestionItem {
  final String name;
  final String weight;
  final String time;
  final String discount;

  const SuggestionItem({
    required this.name,
    required this.weight,
    required this.time,
    required this.discount,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(
      name: 'Anokhi Jivraj Chai Patti',
      weight: '1 kg',
      originalPrice: 186,
      discountedPrice: 160,
    ),
    CartItem(
      name: 'Britiana Bourbon Biscuit',
      weight: '1 Piece',
      originalPrice: 35,
      discountedPrice: 20,
    ),
  ];

  final List<SuggestionItem> _suggestions = const [
    SuggestionItem(
      name: 'Anokhi Jivraj Chai Patti',
      weight: '1 kg',
      time: '45 MINS',
      discount: '26% Off',
    ),
    SuggestionItem(
      name: 'Dev Snacks Banana Chips',
      weight: '550 g',
      time: '05 MINS',
      discount: '19% Off',
    ),
    SuggestionItem(
      name: 'Vedaka Organic Suji',
      weight: '1 kg',
      time: '16 MINS',
      discount: '25% Off',
    ),
    SuggestionItem(
      name: 'Saffola Active Gold Oil',
      weight: '1 ltr',
      time: '33 MINS',
      discount: '12% Off',
    ),
  ];

  int get _totalPay =>
      _cartItems.fold(0, (sum, item) => sum + item.discountedPrice * item.qty);

  int get _totalOriginal =>
      _cartItems.fold(0, (sum, item) => sum + item.originalPrice * item.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildAppBar(context)),
                SliverToBoxAdapter(child: _buildCartButton()),
                SliverToBoxAdapter(child: SizedBox(height: 0.5.h)),
                SliverToBoxAdapter(child: _buildSavingsBanner()),
                SliverToBoxAdapter(child: SizedBox(height: 1.5.h)),
                SliverToBoxAdapter(child: _buildSavingCorner()),
                SliverToBoxAdapter(child: SizedBox(height: 1.5.h)),
                SliverToBoxAdapter(child: _buildCartItemsCard()),
                SliverToBoxAdapter(child: SizedBox(height: 1.5.h)),
                SliverToBoxAdapter(child: _buildDidYouForget()),
                SliverToBoxAdapter(child: SizedBox(height: 5.h)),
                SliverToBoxAdapter(child: _buildNewLocationBanner()),
                SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                SliverToBoxAdapter(child: _buildAddressButton()),
                SliverToBoxAdapter(child: SizedBox(height: 3.h)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 1.h,
        left: 4.w,
        right: 4.w,
        bottom: 1.5.h,
      ),
      child: Row(
        children: [
          SizedBox(width: 3.w),
          Text(
            'Your Cart',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── CART Button ─────────────────────────────────────────────────────────────
  Widget _buildCartButton() {
    return Container(
      color: AppColors.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Container(
        width: double.infinity,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.greenColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.whiteColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.yellowColor.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'CART',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  // ── Savings Banner ──────────────────────────────────────────────────────────
  Widget _buildSavingsBanner() {
    return Center(
      child: Text(
        '₹41 Saved! Add items worth ₹109 to get ₹100 free cash',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.greenColor,
        ),
      ),
    );
  }

  // ── Saving Corner ───────────────────────────────────────────────────────────
  Widget _buildSavingCorner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SAVING CORNER',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.greyTextColor,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 1.2.h),
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_offer,
                  size: 4.w,
                  color: const Color(0xFFE65100),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Save ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                          TextSpan(
                            text: '₹20',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                          TextSpan(
                            text: ' with BHIMPNEW',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View all coupons & offers >',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Apply',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brownColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Cart Items Card ─────────────────────────────────────────────────────────
  Widget _buildCartItemsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              children: [
                Text(
                  '20 Mins',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackTextColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_cartItems.length} Items',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.greyTextColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.greyLightColor, height: 1, thickness: 0.5),

          // Items list
          ...List.generate(_cartItems.length, (index) {
            return Column(
              children: [
                _buildCartItem(index),
                if (index < _cartItems.length - 1)
                  Divider(
                    color: AppColors.greyLightColor,
                    height: 1,
                    thickness: 0.5,
                    indent: 4.w,
                    endIndent: 4.w,
                  ),
              ],
            );
          }),

          // Add more items
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyLightColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+ Add more items',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Image.asset(ImageAssetPath.home2, width: 15.w, height: 15.w, fit: BoxFit.cover),
          SizedBox(width: 3.w),
          // Name + weight + wishlist
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  item.weight,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.greyTextColor,
                  ),
                ),
                SizedBox(height: 0.6.h),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 3.5.w,
                        color: AppColors.greyTextColor,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Move to whistlist',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          // Qty stepper + price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Stepper
              Row(
                children: [
                  _stepperButton(
                    icon: Icons.remove,
                    onTap: () {
                      setState(() {
                        if (item.qty > 1) item.qty--;
                      });
                    },
                  ),
                  SizedBox(width: 2.5.w),
                  Text(
                    '${item.qty}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(width: 2.5.w),
                  _stepperButton(
                    icon: Icons.add,
                    onTap: () {
                      setState(() => item.qty++);
                    },
                  ),
                ],
              ),
              SizedBox(height: 0.6.h),
              // Original price strikethrough
              Text(
                '₹${item.originalPrice}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.greyTextColor2,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.greyTextColor2,
                ),
              ),
              // Discounted price
              Text(
                '₹ ${item.discountedPrice}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greenColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 6.5.w,
        height: 6.5.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyLightColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 3.5.w, color: AppColors.blackTextColor),
      ),
    );
  }

  // ── Did You Forget ──────────────────────────────────────────────────────────
  Widget _buildDidYouForget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              children: [
                Text(
                  'Did you forget?',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Freshness That Bright Skin',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Ice-Cream',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.blackTextColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.greyLightColor, height: 1, thickness: 0.5),
          SizedBox(height: 1.h),

          // Horizontal product list
          SizedBox(
            height: 22.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return _buildSuggestionItem(_suggestions[index]);
              },
            ),
          ),

          // To Pay row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'To Pay: ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                      TextSpan(
                        text: '₹ $_totalPay  ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greenColor,
                        ),
                      ),
                      TextSpan(
                        text: '₹$_totalOriginal',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.greyTextColor2,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.greyTextColor2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View Detailed Bill',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(SuggestionItem item) {
    return Container(
      width: 20.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with bookmark + add button
          Stack(
            children: [
              Image.asset(ImageAssetPath.home4, width: 20.w, height: 10.h, fit: BoxFit.cover),
              // Bookmark
              Positioned(
                top: 1.w,
                left: 1.w,
                child: Icon(
                  Icons.bookmark_border,
                  size: 4.w,
                  color: AppColors.greyTextColor,
                ),
              ),
              // Add button
              Positioned(
                top: 1.w,
                right: 0.5.w,
                child: Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 3.5.w, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Text(
            item.time,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.greyTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
            ),
          ),
          Text(
            item.weight,
            style: TextStyle(fontSize: 12.sp, color: AppColors.greyTextColor),
          ),
          SizedBox(height: 0.4.h),
          Text(
            item.discount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.brownColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── New Location Banner ─────────────────────────────────────────────────────
  Widget _buildNewLocationBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageAssetPath.locationIcon, width: 5.w, height: 5.w),
          SizedBox(width: 2.w),
          Text(
            'You seem to be in a new location!',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Add Address Button ──────────────────────────────────────────────────────
  Widget _buildAddressButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 5.h,
          decoration: BoxDecoration(
            color: AppColors.greenColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              'Add Your Address to Proceed',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
