import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/constants/asset_path.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/utils/app_snackbar.dart';
import 'package:kuruvikal/features/auth/providers/auth_provider.dart';
import 'package:kuruvikal/features/dashboard/screens/dahsboard_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VerifyMobileScreen extends StatefulWidget {
  VerifyMobileScreen({
    super.key,
    required this.phoneNumber,
    this.myOtp,
    this.isfromResetPass = false,
  });
  final String phoneNumber;
  String? myOtp;
  final bool isfromResetPass;

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isShowResend = true;
  bool isLoading = false;
  int timerValue = 60;
  Timer? periodicTimer;
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
  }

  void _startTimer() {
    periodicTimer?.cancel();
    setState(() {
      timerValue = 60;
      isShowResend = false;
    });
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerValue <= 1) {
          timer.cancel();
          isShowResend = true;
        } else {
          timerValue--;
        }
      });
    });
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> verifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => isLoading = true);
    final success = await authProvider.login(
      widget.phoneNumber,
      _otpController.text,
    );
    if (mounted) {
      setState(() => isLoading = false);
    }
    if (success) {
      NavigationService().clearAndPush(DashboardScreen());
    }
  }

  Future<void> _resendOtp(String phoneNumber) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtp(phoneNumber);
    if (success) {
      AppSnackBar.showSuccess('OTP resent successfully');
    } else {
      AppSnackBar.showError('Failed to resend OTP');
    }
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    errorController?.close();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _VerifyOtpCard(
            phoneNumber: widget.phoneNumber,
            otpController: _otpController,
            formKey: formKey,
            isLoading: isLoading,
            isShowResend: isShowResend,
            timerValue: timerValue,
            onVerify: verifyOtp,
            onResend: () {
              _resendOtp(widget.phoneNumber);
              _startTimer();
            },
            formatTimer: _formatTimer,
          ),
        ),
      ),
    );
  }
}

class VerifyOtpSheet extends StatefulWidget {
  const VerifyOtpSheet({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  State<VerifyOtpSheet> createState() => _VerifyOtpSheetState();
}

class _VerifyOtpSheetState extends State<VerifyOtpSheet> {
  final TextEditingController _otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isShowResend = true;
  bool isLoading = false;
  int timerValue = 60;
  Timer? periodicTimer;
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
  }

  void _startTimer() {
    periodicTimer?.cancel();
    setState(() {
      timerValue = 60;
      isShowResend = false;
    });
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerValue <= 1) {
          timer.cancel();
          isShowResend = true;
        } else {
          timerValue--;
        }
      });
    });
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _verifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => isLoading = true);
    final success = await authProvider.login(
      widget.phoneNumber,
      _otpController.text,
    );
    if (mounted) {
      setState(() => isLoading = false);
    }
    if (success) {
      if (mounted) Navigator.of(context).pop();
      NavigationService().clearAndPush(DashboardScreen());
    }
  }

  Future<void> _resendOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtp(widget.phoneNumber);
    if (success) {
      AppSnackBar.showSuccess('OTP resent successfully');
    } else {
      AppSnackBar.showError('Failed to resend OTP');
    }
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    errorController?.close();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _VerifyOtpCard(
      phoneNumber: widget.phoneNumber,
      otpController: _otpController,
      formKey: formKey,
      isLoading: isLoading,
      isShowResend: isShowResend,
      timerValue: timerValue,
      onVerify: _verifyOtp,
      onResend: () {
        _resendOtp();
        _startTimer();
      },
      formatTimer: _formatTimer,
    );
  }
}

class _VerifyOtpCard extends StatelessWidget {
  const _VerifyOtpCard({
    required this.phoneNumber,
    required this.otpController,
    required this.formKey,
    required this.isLoading,
    required this.isShowResend,
    required this.timerValue,
    required this.onVerify,
    required this.onResend,
    required this.formatTimer,
  });

  final String phoneNumber;
  final TextEditingController otpController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final bool isShowResend;
  final int timerValue;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final String Function(int) formatTimer;

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
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ImageAssetPath.otpVerifyIcon, height: 12.h),
              SizedBox(height: 2.h),
              Text(
                'Account Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackTextColor,
                ),
              ),
              SizedBox(height: 0.6.h),
              Text(
                'Enter your validity code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMutedColor,
                ),
              ),
              SizedBox(height: 3.h),
              Form(
                key: formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 56,
                    fieldWidth: 56,
                    inactiveFillColor: const Color(0xFFFFF5F5),
                    inactiveColor: AppColors.greyLightColor,
                    selectedFillColor: const Color(0xFFFFF5F5),
                    selectedColor: AppColors.greyLightColor,
                    activeFillColor: const Color(0xFFFFF5F5),
                    activeColor: AppColors.greyLightColor,
                    borderWidth: 1.5,
                  ),
                  cursorColor: AppColors.greenColor,
                  validator: (v) {
                    if (v == null || v.length < 4) {
                      return 'Please enter a valid 4-digit OTP';
                    }
                    return null;
                  },
                  errorTextSpace: 28,
                  beforeTextPaste: (_) => true,
                  onChanged: (_) {},
                  onCompleted: (_) {},
                ),
              ),
              SizedBox(height: 2.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: otpController,
                builder: (context, value, _) {
                  final bool isFilled = value.text.length == 4;
                  return SizedBox(
                    width: double.infinity,
                    height: 5.8.h,
                    child: ElevatedButton(
                      onPressed: (isLoading || !isFilled)
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                onVerify();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFilled ? AppColors.greenColor : Colors.grey,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                              'Verify Code',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 2.5.h),
              GestureDetector(
                onTap: isShowResend ? onResend : null,
                child: Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isShowResend ? AppColors.textMutedColor : Colors.grey,
                  ),
                ),
              ),
              if (!isShowResend) ...[
                SizedBox(height: 1.2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 13.sp,
                      color: AppColors.textMutedColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Resend in ${formatTimer(timerValue)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textMutedColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
