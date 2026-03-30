import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildUserInfo(),
                    const SizedBox(height: 20),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildMenuList(),
                    const SizedBox(height: 24),
                    _buildPastOrders(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            color: AppColors.blackTextColor,
            onPressed: () {
              NavigationService().goBack();
            }),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.greenColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Help',
                  style: TextStyle(
                    color: AppColors.greenColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.more_vert, color: Colors.black54, size: 22),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SONALI MAURYA',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackTextColor,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Mahindra Colony, Near Police Station, Dindoli, Surat 394210',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.blackTextColor,
            height: 1.4,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '+91 1234567890',
          style: TextStyle(fontSize: 14.sp, color: AppColors.blackTextColor),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(icon: Icons.location_on_outlined, label: 'Saved\nAddress'),
      _QuickAction(icon: Icons.credit_card_outlined, label: 'Payment\nModes'),
      _QuickAction(icon: Icons.refresh, label: 'My\nRefunds'),
      _QuickAction(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Kuruvi\nMoney',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((a) => _buildActionItem(a)).toList(),
      ),
    );
  }

  Widget _buildActionItem(_QuickAction action) {
    return Container(
      width: 21.w,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(action.icon, color: AppColors.brownColor, size: 22),
          SizedBox(height: 2.h),
          Text(
            action.label,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.blackTextColor,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    final items = [
      _MenuItem(icon: Icons.person_outline, label: 'Account Statements'),
      _MenuItem(icon: Icons.emoji_events_outlined, label: 'Corporate Rewards'),
      _MenuItem(icon: Icons.school_outlined, label: 'Student Rewards'),
      _MenuItem(icon: Icons.bookmark_outline, label: 'My Whistlist'),
      _MenuItem(
        icon: Icons.workspace_premium_outlined,
        label: 'Partner Rewards',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGreyLightColor2),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderGreyLightColor2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, color: Colors.black54, size: 19),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black38,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.borderGreyLightColor2,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPastOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAST ORDERS',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackTextColor,
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              Image.asset(ImageAssetPath.cartIcon,),
              const SizedBox(height: 14),
              Text(
                'No Kuruvi Order Yet!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'From groceries to everyday essentials–all in one place!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.blackTextColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  const _QuickAction({required this.icon, required this.label});
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
