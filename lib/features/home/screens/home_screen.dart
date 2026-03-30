import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _GreenHeader(),
              const _ExploreBanner(),
              const SizedBox(height: 10),
              const _OfferCard(),
              const SizedBox(height: 14),
              const _MostShoppedSection(),
              const SizedBox(height: 14),
              const _LowestPriceSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreenHeader extends StatelessWidget {
  const _GreenHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greenColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Image.asset(ImageAssetPath.locationIcon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '11 Mins',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mahindra Colony, Near Police Station, Dindoli, Surat...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
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
                      border: Border.all(color: AppColors.borderGreyLightColor),
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
          const _BrandStrip(),
          const SizedBox(height: 12),
          const _QuickCategories(),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

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

class _TopIconBox extends StatelessWidget {
  const _TopIconBox({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.greenColor, size: 20),
    );
  }
}

class _BrandStrip extends StatelessWidget {
  const _BrandStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGreenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.asset(ImageAssetPath.brandStripImage, fit: BoxFit.contain),
    );
  }
}

class _QuickCategories extends StatelessWidget {
  const _QuickCategories();

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickCategoryData(
        title: 'Snacks &\nDrinks',
        image: ImageAssetPath.home1,
        color: AppColors.lightGreenColor2,
      ),
      _QuickCategoryData(
        title: 'Biscuits &\nChips',
        image: ImageAssetPath.home2,
        color: AppColors.lightGreenColor2,
      ),
      _QuickCategoryData(
        title: 'Dates, Dryfruits\n& Desserts',
        image: ImageAssetPath.home3,
        color: AppColors.lightGreenColor2,
      ),
      _QuickCategoryData(
        title: 'Chaitra\nNavratri',
        image: ImageAssetPath.home4,
        color: AppColors.lightGreenColor2,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.borderGreenColor,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 52,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(item.image, fit: BoxFit.fill),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickCategoryData {
  final String title;
  final String image;
  final Color color;

  const _QuickCategoryData({
    required this.title,
    required this.image,
    required this.color,
  });
}

class _ExploreBanner extends StatelessWidget {
  const _ExploreBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(color: AppColors.greenColor2),
      child: Text(
        'Explore 28 varieties of dates sourced from 12 countries!',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      ImageAssetPath.clockIcon,
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Expires in 15 days',
                      style: TextStyle(
                        color: AppColors.greenColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '₹100 FREE cash just for you!',
                  style: TextStyle(
                    color: AppColors.blackTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'On your first order above ₹249. T&C Applied',
                  style: TextStyle(
                    color: AppColors.greyTextColor2,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFEBEBEB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                ImageAssetPath.orderIcon,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MostShoppedSection extends StatelessWidget {
  const _MostShoppedSection();

  @override
  Widget build(BuildContext context) {
    final products = _demoProducts;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: AppColors.homeGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Most Shopped\nNear You',
                  style: TextStyle(
                    color: AppColors.greenColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Image.asset(
                ImageAssetPath.basketImage,
                width: 20.w,
                height: 10.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MiniProductRow(products: products),
        ],
      ),
    );
  }
}

class _MiniProduct {
  final String title;
  final String size;
  final String price;
  final String oldPrice;
  final String off;
  const _MiniProduct({
    required this.title,
    required this.size,
    required this.price,
    required this.oldPrice,
    required this.off,
  });
}

class _MiniProductCard extends StatelessWidget {
  const _MiniProductCard({required this.product});
  final _MiniProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGreyLightColor2),
                ),
                child: Center(
                  child: Image.asset(
                    ImageAssetPath.home1,
                    width: 20.w,
                    height: 10.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackTextColor,
            ),
          ),
          const SizedBox(height: 2),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
            product.off,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.brownColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Text(
              product.size,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.greyTextColor2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                product.price,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.greenColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                product.oldPrice,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.brownColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniProductRow extends StatelessWidget {
  const _MiniProductRow({required this.products});
  final List<_MiniProduct> products;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: products.map((item) {
        return Expanded(child: _MiniProductCard(product: item));
      }).toList(),
    );
  }
}

class _LowestPriceSection extends StatelessWidget {
  const _LowestPriceSection();

  @override
  Widget build(BuildContext context) {
    final products = _demoProducts;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                ImageAssetPath.dropIcon,
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Lowest Price Across Surat',
                  style: TextStyle(
                    color: AppColors.brownColor,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 22,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.brownColor,
                  size: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _MiniProductRow(products: products),
          SizedBox(height: 2.h),
          Center(
            child: Text(
              'See All Products >>',
              style: TextStyle(
                color: AppColors.brownColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<_MiniProduct> _demoProducts = [
  _MiniProduct(
    title: 'Cashew Nuts',
    size: '1kg',
    price: '₹ 350',
    oldPrice: '₹ 380',
    off: '26% Off',
  ),
  _MiniProduct(
    title: 'Masala Oats',
    size: '500g',
    price: '₹ 145',
    oldPrice: '₹ 180',
    off: '20% Off',
  ),
  _MiniProduct(
    title: 'Cocoa Powder',
    size: '500g',
    price: '₹ 170',
    oldPrice: '₹ 200',
    off: '15% Off',
  ),
  _MiniProduct(
    title: 'Amul Cheese',
    size: '200g',
    price: '₹ 100',
    oldPrice: '₹ 120',
    off: '15% Off',
  ),
];
