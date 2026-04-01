import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:sizer/sizer.dart';

// ── Order Summary Screen ─────────────────────────────────────────────────────
class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  bool _useGst = false;
  String _selectedQty = '1';
  bool _feesExpanded = false;
  bool _discountsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          // ── Scrollable body ──
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildAppBar(context)),
                SliverToBoxAdapter(child: _divider()),
                SliverToBoxAdapter(child: _buildDeliverTo()),
                SliverToBoxAdapter(child: _divider()),
                SliverToBoxAdapter(child: _buildProductItem()),
                SliverToBoxAdapter(child: _buildExpressDelivery()),
                SliverToBoxAdapter(child: _buildGstCheckbox()),
                SliverToBoxAdapter(child: _divider()),
                SliverToBoxAdapter(child: _buildOpenBoxBanner()),
                SliverToBoxAdapter(child: _divider()),
                SliverToBoxAdapter(child: _buildPricingSection()),
                SliverToBoxAdapter(child: _buildSavingsBanner()),
                SliverToBoxAdapter(child: _buildSecureBadge()),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // ── Bottom Bar ──
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back, size: 22, color: AppColors.blackTextColor),
          ),
          const SizedBox(width: 14),
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Deliver To ────────────────────────────────────────────────────────────
  Widget _buildDeliverTo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Deliver to:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brownColor,
                ),
              ),
              const Spacer(),
              // CHANGE button
              SizedBox(
                height: 4.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    foregroundColor: AppColors.whiteColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                
                  ),
                  child: Text(
                    'CHANGE',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'SONALI MAURYA',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'HOME',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Mahindra Colony, Near Police Station, Dindoli, Surat 394210',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.greyTextColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '+91 1234567890',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.greyTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Product Item ──────────────────────────────────────────────────────────
  Widget _buildProductItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image placeholder
              Image.asset(
                ImageAssetPath.home2,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anokhi Jivraj Chai Patti',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '1 kg',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Stars + rating
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 15,
                            color: i < 5
                                ? const Color(0xFF00A275)
                                : AppColors.greyLightColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenColor,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '(1,31,450)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.greyTextColor2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Discount + prices
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          size: 13,
                          color: AppColors.greenColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '12%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹106',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.greyTextColor2,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹ 160',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Protected promise fee
                    Row(
                      children: [
                        Text(
                          '+₹15 Protected Promise Fee',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.greyTextColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.info_outline,
                          size: 13,
                          color: AppColors.greyTextColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Qty dropdown
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ['1', '2', '3', '4', '5']
                      .map(
                        (q) => ListTile(
                          title: Text('Qty: $q'),
                          onTap: () {
                            setState(() => _selectedQty = q);
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyLightColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Qty: $_selectedQty',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: AppColors.greyTextColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Express Delivery ──────────────────────────────────────────────────────
  Widget _buildExpressDelivery() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.delivery_dining, size: 20, color: AppColors.greenColor),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'EXPRESS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackTextColor,
                  ),
                ),
                TextSpan(
                  text: ' Delivery in 2 days, Fri',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.greyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── GST Checkbox ──────────────────────────────────────────────────────────
  Widget _buildGstCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: _useGst,
            onChanged: (v) => setState(() => _useGst = v ?? false),
            activeColor: AppColors.greenColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            side: BorderSide(color: AppColors.greyLightColor, width: 1.5),
          ),
          const Text(
            'Use GST Invoice',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Open Box Banner ───────────────────────────────────────────────────────
  Widget _buildOpenBoxBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Gift/box icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('📦', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Rest assured with open box delivery',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Delivery agent will open the package so you can check for the correct product, damage or missing items. Share OTP to accept the delivery.',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Why?',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.greenColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pricing Section ───────────────────────────────────────────────────────
  Widget _buildPricingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // MRP
          _priceRow(
            label: 'MRP',
            value: '186',
            isTotal: false,
          ),
          const SizedBox(height: 14),
          // Fees (expandable)
          _expandableRow(
            label: 'Fees',
            value: '86',
            expanded: _feesExpanded,
            onTap: () => setState(() => _feesExpanded = !_feesExpanded),
          ),
          if (_feesExpanded) ...[
            const SizedBox(height: 8),
            _subRow('Delivery Fee', '₹71'),
            const SizedBox(height: 4),
            _subRow('Protected Promise Fee', '₹15'),
          ],
          const SizedBox(height: 14),
          // Discounts (expandable)
          _expandableRow(
            label: 'Discounts',
            value: '₹20',
            expanded: _discountsExpanded,
            onTap: () =>
                setState(() => _discountsExpanded = !_discountsExpanded),
          ),
          if (_discountsExpanded) ...[
            const SizedBox(height: 8),
            _subRow('Product Discount', '-₹20'),
          ],
          const SizedBox(height: 20),
          Divider(color: AppColors.greyLightColor, height: 1),
          const SizedBox(height: 14),
          // Total Amount
          Row(
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackTextColor,
                ),
              ),
              const Spacer(),
              const Text(
                '₹60',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _priceRow({
    required String label,
    required String value,
    required bool isTotal,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.blackTextColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.blackTextColor,
          ),
        ),
      ],
    );
  }

  Widget _expandableRow({
    required String label,
    required String value,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.blackTextColor,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 18,
            color: AppColors.blackTextColor,
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _subRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.greyTextColor),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 13, color: AppColors.greyTextColor),
          ),
        ],
      ),
    );
  }

  // ── Savings Banner ────────────────────────────────────────────────────────
  Widget _buildSavingsBanner() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE8F7F1),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          "You'll save ₹20 on this order!",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.greenColor,
          ),
        ),
      ),
    );
  }

  // ── Secure Badge ──────────────────────────────────────────────────────────
  Widget _buildSecureBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF8B1A1A),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.lock, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Safe And Secure Payments. Easy Returns.\n100% Authentic Products.',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Price column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹ 186',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyTextColor2,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.greyTextColor2,
                ),
              ),
              Text(
                '₹ 160',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.greenColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Place Order button
          SizedBox(
            height: 4.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Place the Order',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────
  Widget _divider() =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(color: AppColors.greyLightColor, height: 1, thickness: 1),
      );
}