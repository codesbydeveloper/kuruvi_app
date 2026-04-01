import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/features/auth/providers/auth_provider.dart';
import 'package:kuruvikal/features/auth/screens/verify_mobile_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginWithOTPScreen extends StatefulWidget {
  const LoginWithOTPScreen({super.key});

  @override
  State<LoginWithOTPScreen> createState() => _LoginWithOTPScreenState();
}

class _LoginWithOTPScreenState extends State<LoginWithOTPScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  final TextEditingController _phoneController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _LoginOtpCard(
            formKey: _formKey,
            phoneController: _phoneController,
            isFirstSubmit: isFirstSubmit,
            isLoading: isLoading,
            acceptedTerms: _acceptedTerms,
            onTermsChanged: (value) =>
                setState(() => _acceptedTerms = value ?? false),
            onSubmit: () async {
              setState(() => isFirstSubmit = false);
              if (_formKey.currentState!.validate()) {
                setState(() => isLoading = true);
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final success =
                    await authProvider.sendOtp(_phoneController.text);
                setState(() => isLoading = false);
                if (success) {
                  await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: VerifyOtpSheet(
                          phoneNumber: _phoneController.text,
                        ),
                      );
                    },
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoginOtpSheet extends StatefulWidget {
  const LoginOtpSheet({super.key});

  @override
  State<LoginOtpSheet> createState() => _LoginOtpSheetState();
}

class _LoginOtpSheetState extends State<LoginOtpSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isFirstSubmit = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _LoginOtpCard(
      formKey: _formKey,
      phoneController: _phoneController,
      isFirstSubmit: _isFirstSubmit,
      isLoading: _isLoading,
      acceptedTerms: _acceptedTerms,
      onTermsChanged: (value) =>
          setState(() => _acceptedTerms = value ?? false),
      onSubmit: () async {
        setState(() => _isFirstSubmit = false);
        if (_formKey.currentState!.validate()) {
          setState(() => _isLoading = true);
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final success = await authProvider.sendOtp(_phoneController.text);
          setState(() => _isLoading = false);
          if (success) {
            Navigator.of(context).pop();
            final rootContext = NavigationService().context;
            if (rootContext == null) return;
            await showModalBottomSheet<void>(
              context: rootContext,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: VerifyOtpSheet(
                    phoneNumber: _phoneController.text,
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}

class _LoginOtpCard extends StatelessWidget {
  const _LoginOtpCard({
    required this.formKey,
    required this.phoneController,
    required this.isFirstSubmit,
    required this.isLoading,
    required this.acceptedTerms,
    required this.onTermsChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final bool isFirstSubmit;
  final bool isLoading;
  final bool acceptedTerms;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Form(
            key: formKey,
            autovalidateMode: isFirstSubmit
                ? AutovalidateMode.disabled
                : AutovalidateMode.always,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  "Enter your phone number to proceed",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textMutedColor,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                ),
                SizedBox(height: 1.2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageAssetPath.indianIcon,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "+91",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 22,
                      color: AppColors.blackTextColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                        decoration: InputDecoration(
                          hintText: "Phone number",
                          hintStyle: TextStyle(
                            color: AppColors.textMutedColor.withOpacity(0.7),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter phone number";
                          } else if (value.length != 10) {
                            return "Enter a valid 10-digit number";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Divider(color: AppColors.greenColor, thickness: 1),
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: acceptedTerms,
                      onChanged: onTermsChanged,
                      activeColor: AppColors.greenColor,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.greyTextColor,
                          ),
                          children: [
                            const TextSpan(text: "By clicking, I accept the "),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: phoneController,
                  builder: (context, value, _) {
                    final bool hasInput = value.text.isNotEmpty;
                    final bool canSubmit = hasInput && acceptedTerms;
                    return SizedBox(
                      width: double.infinity,
                      height: 5.5.h,
                      child: ElevatedButton(
                        onPressed: (isLoading || !canSubmit) ? null : onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              canSubmit ? AppColors.greenColor : Colors.grey,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "CONTINUE",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
