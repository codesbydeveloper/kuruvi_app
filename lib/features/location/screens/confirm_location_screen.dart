import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/services/location_service.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';

enum _LocationType { house, office, other }

class ConfirmLocationScreen extends StatefulWidget {
  const ConfirmLocationScreen({super.key, this.addressInfo});
  final AddressInfo? addressInfo;

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  _LocationType _selectedType = _LocationType.other;

  final _buildingController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _stateCityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _instructionController = TextEditingController();

  // Receiver details
  final _receiverBuildingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _areaController.text = widget.addressInfo?.subtitle ?? '';
  }

  @override
  void dispose() {
    _buildingController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _stateCityController.dispose();
    _pincodeController.dispose();
    _instructionController.dispose();
    _receiverBuildingController.dispose();
    super.dispose();
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.blackTextColor,
          ),
        ),
      );

  InputDecoration _inputDec(
    String hint, {
    bool required = false,
    bool floating = false,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: floating ? null : hint,
      labelText: floating ? hint : null,
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.greyTextColor2),
      hintStyle: const TextStyle(fontSize: 14, color: AppColors.greyTextColor2),
      suffixIcon: suffix,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.borderGreyLightColor2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.borderGreyLightColor2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.borderGreyLightColor2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _typeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: _LocationType.values.map((t) {
          final selected = t == _selectedType;
          final label = t == _LocationType.house
              ? 'House'
              : t == _LocationType.office
                  ? 'Office'
                  : 'Other';
          final icon = t == _LocationType.house
              ? Icons.home_outlined
              : t == _LocationType.office
                  ? Icons.work_outline
                  : Icons.send_outlined;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 34,
                decoration: BoxDecoration(
                  color: selected ? AppColors.brownColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: selected ? Colors.white : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _areaRow() {
    final areaText =
        _areaController.text.trim().isEmpty ? 'Area / Locality' : _areaController.text.trim();
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderGreyLightColor2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Area / Locality',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.greyTextColor2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    areaText,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMutedColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => NavigationService().goBack(),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 72,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderGreyLightColor2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on, color: Colors.pinkAccent, size: 26),
                    SizedBox(height: 4),
                    Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiverCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGreyLightColor2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              const Text(
                'Building / Floor*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMutedColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _receiverBuildingController,
            decoration: _inputDec('Building / Floor*'),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _locationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGreyLightColor2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _typeSelector(),
          const SizedBox(height: 14),
          TextField(
            controller: _buildingController,
            decoration: _inputDec('Building / Floor *', required: true),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _streetController,
            decoration: _inputDec('Street Recommended'),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          _areaRow(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stateCityController,
                  decoration: _inputDec('State / City *', required: true),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _pincodeController,
                  decoration: _inputDec('Pincode'),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _instructionsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGreyLightColor2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _instructionController,
              decoration: const InputDecoration(
                hintText: 'Instruction to reach location',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyTextColor2,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.greenColor,
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 36),
            ),
            child: const Text(
              'Add',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    final title = widget.addressInfo?.title ?? 'Your Location';
    final subtitle = widget.addressInfo?.subtitle ?? '';
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: const BackButton(color: Colors.black87),
      titleSpacing: 0,
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMutedColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle.trim().isNotEmpty) ...[
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '| $subtitle',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child:
              Icon(Icons.notifications_outlined, color: AppColors.redColor, size: 24),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: Colors.grey[200]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Receiver Details'),
                  _receiverCard(),
                  const SizedBox(height: 20),
                  _sectionLabel('Location Details'),
                  _locationCard(),
                  const SizedBox(height: 20),
                  _sectionLabel('Delivery Instructions'),
                  _instructionsCard(),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.borderGreyLightColor2,
                  foregroundColor: AppColors.textMutedColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Save Address',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
