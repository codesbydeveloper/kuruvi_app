import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kuruvikal/core/services/local_storage_service.dart';
import 'package:kuruvikal/core/services/location_service.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/features/location/screens/confirm_location_screen.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  LatLng? _currentLatLng;
  AddressInfo? _addressInfo;
  bool _isLoading = false;
  bool _isDragging = false;
  List<PlaceSuggestion> _suggestions = [];
  List<String> _recentSearches = [];
  bool _showRecent = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
    _loadRecentSearches();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initCurrentLocation() async {
    setState(() => _isLoading = true);
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() => _currentLatLng = latLng);
      _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      await _fetchAddress(latLng);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchAddress(LatLng latLng) async {
    setState(() => _isLoading = true);
    final info = await _locationService.fetchAddressFromLatLng(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
    setState(() {
      _addressInfo = info;
      _isLoading = false;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentLatLng = position.target;
      _isDragging = true;
    });
  }

  void _onCameraIdle() async {
    setState(() => _isDragging = false);
    final target = _currentLatLng;
    if (target != null) {
      await _fetchAddress(target);
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _loadRecentSearches() async {
    final list = await _localStorageService.getRecentSearches();
    if (!mounted) return;
    setState(() => _recentSearches = list);
  }

  void _onSearchFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      setState(() => _showRecent = false);
      return;
    }
    if (_searchController.text.trim().isEmpty) {
      setState(() => _showRecent = true);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final query = value.trim();
      if (query.isEmpty) {
        if (!mounted) return;
        setState(() {
          _suggestions = [];
          _showRecent = _recentSearches.isNotEmpty && _searchFocusNode.hasFocus;
        });
        return;
      }
      if (!mounted) return;
      setState(() => _showRecent = false);
      final results = await _locationService.fetchPlaceSuggestions(query);
      if (!mounted) return;
      setState(() => _suggestions = results);
    });
  }

  Future<void> _onSuggestionTap(PlaceSuggestion suggestion) async {
    FocusScope.of(context).unfocus();
    _searchController.text = suggestion.description;
    setState(() => _suggestions = []);
    await _localStorageService.addRecentSearch(suggestion.description);
    await _loadRecentSearches();

    final latLng = await _locationService.fetchLatLngFromPlaceId(
      suggestion.placeId,
    );
    if (latLng == null) return;
    _currentLatLng = latLng;
    await _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    await _fetchAddress(latLng);
  }

  void _onRecentTap(String text) {
    _searchController.text = text;
    _onSearchChanged(text);
  }

  // Use current location CTA removed per request.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Google Map ──────────────────────────────────────────────────
          if (_currentLatLng != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLatLng!,
                zoom: 16,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            )
          else
            const Center(child: CircularProgressIndicator()),

          // ── Center Pin ─────────────────────────────────────────────────
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(bottom: _isDragging ? 26 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.redColor.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Top Search Bar ─────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => NavigationService().goBack(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderGreyLightColor),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderGreyLightColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Search for the location...',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 2,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.search,
                                  color: AppColors.maroonColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        if (_suggestions.isNotEmpty)
                            Material(
                              elevation: 4,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 240,
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  itemCount: _suggestions.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = _suggestions[index];
                                    return ListTile(
                                      dense: true,
                                      title: Text(
                                        item.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      onTap: () => _onSuggestionTap(item),
                                    );
                                  },
                                ),
                              ),
                            ),
                        if (_showRecent && _recentSearches.isNotEmpty)
                          Material(
                            elevation: 4,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 220),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                itemCount: _recentSearches.length + 1,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'Recent searches',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    );
                                  }
                                  final text = _recentSearches[index - 1];
                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.history, size: 18),
                                    title: Text(
                                      text,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    onTap: () => _onRecentTap(text),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── My Location Button ─────────────────────────────────────────
          Positioned(
            right: 14,
            bottom: 210,
            child: GestureDetector(
              onTap: _initCurrentLocation,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.my_location,
                  color: AppColors.redColor,
                  size: 22,
                ),
              ),
            ),
          ),

          // ── Bottom Sheet ───────────────────────────────────────────────
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Order will be delivered here',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _isLoading ? _buildAddressShimmer() : _buildAddressRow(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isLoading ||
                              _addressInfo == null ||
                              (_addressInfo?.subtitle ?? '').isEmpty)
                          ? null
                          : () {
                              NavigationService().push(
                                ConfirmLocationScreen(
                                  addressInfo: _addressInfo,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm & Proceed',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, color: AppColors.redColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _addressInfo?.title ?? 'Your Location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _addressInfo?.subtitle ?? 'Fetching address...',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.black45,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressShimmer() {
    return Row(
      children: [
        Icon(Icons.location_on, color: AppColors.redColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: 160, height: 14),
              const SizedBox(height: 6),
              _shimmerBox(width: double.infinity, height: 12),
              const SizedBox(height: 4),
              _shimmerBox(width: 200, height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
