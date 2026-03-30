import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/services/local_storage_service.dart';
import 'package:kuruvikal/core/services/location_service.dart';
import 'package:kuruvikal/core/services/store_api_service.dart';
import 'package:kuruvikal/core/utils/logger.dart';
import 'package:kuruvikal/features/category/screens/category_screen.dart';
import 'package:kuruvikal/features/home/screens/home_screen.dart';
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Default to CATEGORY
  final LocationService _locationService = LocationService();
  final StoreApiService _storeApiService = StoreApiService();
  final LocalStorageService _localStorageService = LocalStorageService();
  bool _isFetchingNearestStore = false;

  final _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    _CartPlaceholder(),
    _FavoritesPlaceholder(),
    _AccountPlaceholder(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchNearestStore);
  }

  Future<void> _fetchNearestStore() async {
    if (_isFetchingNearestStore) return;
    _isFetchingNearestStore = true;

    final position = await _locationService.getCurrentLocation();
    if (position == null) {
      AppLogger.warning('Location not available. Permission denied or service off.');
      _isFetchingNearestStore = false;
      return;
    }

    try {
      final response = await _storeApiService.getNearestStore(
        lat: position.latitude,
        lng: position.longitude,
      );
      AppLogger.success('Nearest store fetched successfully.');
      AppLogger.log('Nearest store response: $response');
      await _saveFirstStoreId(response);
    } catch (e) {
      AppLogger.error('Failed to fetch nearest store: $e');
    } finally {
      _isFetchingNearestStore = false;
    }
  }

  Future<void> _saveFirstStoreId(dynamic response) async {
    try {
      final data = response is Map ? response['data'] : null;
      final store = data is Map ? data['store'] : null;
      String? storeId;

      if (store is List && store.isNotEmpty) {
        final first = store.first;
        if (first is Map && first['_id'] is String) {
          storeId = first['_id'] as String;
        }
      } else if (store is Map && store['_id'] is String) {
        storeId = store['_id'] as String;
      }

      if (storeId != null && storeId.isNotEmpty) {
        await _localStorageService.saveNearestStoreId(storeId);
        AppLogger.success('Nearest store id saved: $storeId');
      }
    } catch (e) {
      AppLogger.error('Failed to save nearest store id: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer green container — provides the green rounded top + banner area
      decoration: BoxDecoration(
        color: AppColors.greenColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Banner strip ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'FREE DELIVERY ON ORDER ABOVE ₹99',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // ── White nav bar ─────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  _NavItem(
                    index: 0,
                    selectedIndex: selectedIndex,
                    label: 'HOME',
                    icon: Icons.home_outlined,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 1,
                    selectedIndex: selectedIndex,
                    label: 'CATEGORY',
                    icon: Icons.category_outlined,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 2,
                    selectedIndex: selectedIndex,
                    label: 'CART',
                    icon: Icons.shopping_bag_outlined,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 3,
                    selectedIndex: selectedIndex,
                    label: 'FAVORITES',
                    icon: Icons.favorite_border_outlined,
                    onTap: onTap,
                  ),
                  _NavItem(
                    index: 4,
                    selectedIndex: selectedIndex,
                    label: 'ACCOUNT',
                    icon: Icons.account_circle_outlined,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final int index;
  final int selectedIndex;
  final String label;
  final IconData icon;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    final Color color = isSelected
        ? AppColors.brownColor
        : AppColors.greenColor;

    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final labelFontSize =
        (11.sp * textScale).clamp(10.0, 16.0); // keep it readable everywhere
    final iconSize = (26 * textScale).clamp(24.0, 32.0);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: iconSize),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Placeholder screens ────────────────────────────────────────────────────

class _CartPlaceholder extends StatelessWidget {
  const _CartPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Cart'));
}

class _FavoritesPlaceholder extends StatelessWidget {
  const _FavoritesPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Favorites'));
}

class _AccountPlaceholder extends StatelessWidget {
  const _AccountPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Account'));
}
