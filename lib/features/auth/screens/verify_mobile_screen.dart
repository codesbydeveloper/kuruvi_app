import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/utils/logger.dart';
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
  TextEditingController textEditingController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isShowResend = true;

  StreamController<ErrorAnimationType>? errorController;

  int timerValue = 60;
  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
  }

  stopTimer() {
    periodicTimer!.cancel();
    setState(() {
      isShowResend = true;
    });
  }

  startTimer() {
    setState(() {
      timerValue = 60;
      isShowResend = false;
    });

    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerValue == 1) {
          stopTimer();
        } else {
          timerValue--;
        }
      });
      // Update user about remaining time
    });
  }

  String myOtp = "";
  bool isLoading = false;

  Future<void> verifyOtp() async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      widget.phoneNumber,
      _otpController.text
    );

    if (success) {
      NavigationService().clearAndPush(DashboardScreen());
    } else {
      AppLogger.error(authProvider.errorMessage ?? "Invalid OTP");
    }
  }

  Future<void> _resendOtp(String phoneNumber) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.sendOtp(phoneNumber);

    if (success) {
      AppLogger.success("OTP resent successfully");
    } else {
      AppLogger.error("Failed to resend OTP");
    }
  }

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.w, top: 1.5.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => NavigationService().goBack(),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.blackTextColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              // ── All main content strictly centered ───────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Lock icon ──────────────────────────
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.maroonColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_open_outlined,
                        color: AppColors.maroonColor,
                        size: 32,
                      ),
                    ),

                    SizedBox(height: 2.5.h),

                    // ── Title ──────────────────────────────
                    Text(
                      "Verify your number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackTextColor,
                        letterSpacing: -0.3,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // ── Subtitle ───────────────────────────
                    Text(
                      "Enter the 4-digit code sent to",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textMutedColor,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      "+91 ${widget.phoneNumber}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ── OTP boxes ──────────────────────────
                    Form(
                      key: formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        controller: _otpController,
                        errorAnimationController: errorController,
                        keyboardType: TextInputType.number,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 54,
                          fieldWidth: 54,
                          inactiveFillColor: Colors.white,
                          inactiveColor: Colors.transparent,
                          selectedFillColor: Colors.white,
                          selectedColor: AppColors.maroonColor,
                          activeFillColor: Colors.white,
                          activeColor: AppColors.maroonColor,
                          borderWidth: 1.5,
                        ),
                        cursorColor: AppColors.maroonColor,
                        validator: (v) {
                          if (v == null || v.length < 4) {
                            return "Please enter a valid 4-digit OTP";
                          }
                          return null;
                        },
                        errorTextSpace: 28,
                        onChanged: (_) => setState(() {}),
                        onCompleted: (_) {},
                        beforeTextPaste: (_) => true,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // ── Verify & Proceed button ────────────
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _otpController,
                      builder: (context, value, _) {
                        final bool isFilled = value.text.length == 4;
                        return SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: (isLoading || !isFilled)
                                ? null
                                : () {
                              if (formKey.currentState!.validate()) {
                                verifyOtp();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              isFilled ? AppColors.maroonColor : Colors.grey,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey,
                              disabledForegroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Verify & Proceed",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 14.sp),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    // ── Resend row ─────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code?  ",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMutedColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: isShowResend
                              ? () {
                            _resendOtp(widget.phoneNumber);
                            _startTimer();
                          }
                              : null,
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: isShowResend
                                  ? AppColors.maroonColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Countdown ──────────────────────────
                    if (!isShowResend) ...[
                      SizedBox(height: 1.2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time_outlined,
                              size: 13.sp, color: AppColors.textMutedColor),
                          const SizedBox(width: 4),
                          Text(
                            "Resend in ${_formatTimer(timerValue)}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textMutedColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final languageNotifier = context.watch<LanguageNotifier>();
  //   var height = MediaQuery.of(context).size.height;
  //   var width = MediaQuery.of(context).size.width;
  //   return Container(
  //     color: ThemeClass.whiteColor,
  //     // color: ThemeClass.safeareBackGround,
  //     child: SafeArea(
  //       child: Scaffold(
  //         body: Container(
  //           color: ThemeClass.whiteColor,
  //           height: height,
  //           width: width,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 SizedBox(
  //                   height: height * 0.03.h,
  //                   child: AppbarWithLogo(
  //                     onbackPress: () {
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(height: 3.h),
  //                 _buildView(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Container _buildView() {
  //   final languageNotifier = context.watch<LanguageNotifier>();
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 5.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(height: 2.h),
  //         Text(
  //           languageNotifier.localizedStrings['enterOtpText'] ?? '',
  //           style: ThemeClass.largeLargeTextStyle.copyWith(
  //             fontWeight: FontWeight.w500,
  //           ),
  //           /*style: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontSize: 17,
  //               color: ThemeClass.blackColor),*/
  //         ),
  //         SizedBox(height: 2.h),
  //         Align(
  //           alignment: Alignment.center,
  //           child: Text.rich(
  //             TextSpan(
  //               text:
  //                   languageNotifier.localizedStrings['sendToCodeMobileText'] ??
  //                   ' ',
  //               style: ThemeClass.smallTextStyle.copyWith(
  //                 fontWeight: FontWeight.normal,
  //                 color: ThemeClass.greyDarkColor,
  //                 fontSize: 10.sp,
  //               ),
  //               /*style:
  //                     TextStyle(fontSize: 12, color: ThemeClass.greyDarkColor),*/
  //               children: <InlineSpan>[
  //                 TextSpan(
  //                   text: " +91 ${widget.phoneNumber}",
  //                   style: ThemeClass.smallTextStyle.copyWith(
  //                     fontWeight: FontWeight.w500,
  //                     // color: ThemeClass.greyDarkColor,
  //                     fontSize: 10.sp,
  //                   ),
  //                   /*    style: TextStyle(
  //                         fontSize: 13,
  //                         color: ThemeClass.blackColor,
  //                         fontWeight: FontWeight.w500),*/
  //                 ),
  //               ],
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         SizedBox(height: 7.h),
  //         SizedBox(
  //           width: MediaQuery.of(context).size.width / 0.3.w,
  //           child: _buildOtpTextBox(),
  //         ),
  //         SizedBox(height: 3.h),
  //         ButtonWidget(
  //           textColor: ThemeClass.brownColor,
  //           title: languageNotifier.localizedStrings['verifyText'] ?? '',
  //           color: ThemeClass.mainColor,
  //           isLoading: isLoading,
  //           callBack: () {
  //             if (formKey.currentState!.validate()) {
  //               verifyOtp();
  //             }
  //           },
  //         ),
  //         SizedBox(height: 4.h),
  //         SizedBox(height: 100),
  //       ],
  //     ),
  //   );
  // }
  //
  // _buildOtpTextBox() {// Assuming widget.myOtp is of type int
  //   return Form(
  //     key: formKey,
  //     child: PinCodeTextField(
  //       // backgroundColor: ThemeClass.mainColor,
  //       appContext: context,
  //       pastedTextStyle: TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       length: 4,
  //       blinkWhenObscuring: true,
  //       animationType: AnimationType.fade,
  //       validator: (v) {
  //         if (v!.length < 4) {
  //           return GlobalVariableForShowMessage.pleasEenterVaildOTP;
  //         } else {
  //           return null;
  //         }
  //       },
  //       errorTextSpace: 3.h,
  //       textStyle: TextStyle(
  //         fontSize: 20.sp,
  //         color: ThemeClass.blackColor,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       pinTheme: PinTheme(
  //         borderRadius: BorderRadius.circular(5),
  //         shape: PinCodeFieldShape.box,
  //         fieldHeight: 60,
  //         fieldWidth: 50,
  //         selectedFillColor: ThemeClass.whiteColor,
  //         inactiveFillColor: ThemeClass.whiteColor,
  //         activeFillColor: ThemeClass.whiteColor,
  //         activeColor: ThemeClass.mainColor,
  //         inactiveColor: ThemeClass.mainColor,
  //         selectedColor: ThemeClass.mainColor,
  //       ),
  //       cursorColor: ThemeClass.blueColor,
  //       animationDuration: Duration(milliseconds: 300),
  //       enableActiveFill: true,
  //       errorAnimationController: errorController,
  //       controller: _otpController,
  //       keyboardType: TextInputType.number,
  //       onCompleted: (v) {
  //         print("Completed");
  //       },
  //       onChanged: (value) {},
  //       beforeTextPaste: (text) {
  //         print("Allowing to paste $text");
  //         return true;
  //       },
  //       enabled: true, // Set to false to make it non-editable
  //     ),
  //   );
  // }
}
