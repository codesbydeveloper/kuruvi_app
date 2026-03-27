import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuruvikal/core/constants/app_colors.dart';
import 'package:kuruvikal/core/services/navigation_service.dart';
import 'package:kuruvikal/core/utils/logger.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          child: Form(
            key: _formKey,
            autovalidateMode: isFirstSubmit
                ? AutovalidateMode.disabled
                : AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackTextColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Enter your mobile number to continue your\npremium shopping experience.",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.textMutedColor,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                      SizedBox(height: 1.2.h),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.maroonColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                border: Border(
                                  right: BorderSide(
                                    color: AppColors.maroonColor.withOpacity(
                                      0.1,
                                    ),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                "+91",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.maroonColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: "98765 43210",
                                  hintStyle: TextStyle(
                                    color: AppColors.textMutedColor.withOpacity(
                                      0.6,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 1.8.h,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.phone_outlined,
                                    color: AppColors.textMutedColor,
                                    size: 18.sp,
                                  ),
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
                      ),

                      SizedBox(height: 3.h),

                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _phoneController,
                        builder: (context, value, _) {
                          final bool hasInput = value.text.isNotEmpty;
                          return SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: ElevatedButton(
                              onPressed: (isLoading || !hasInput)
                                  ? null
                                  : () async {
                                      setState(() => isFirstSubmit = false);

                                      if (_formKey.currentState!.validate()) {
                                        final authProvider =
                                            Provider.of<AuthProvider>(
                                              context,
                                              listen: false,
                                            );

                                        final success = await authProvider
                                            .sendOtp(_phoneController.text);

                                        if (success) {
                                          NavigationService().push(
                                            VerifyMobileScreen(
                                              phoneNumber: _phoneController.text,
                                            ),
                                          );
                                        } else {
                                          AppLogger.error(
                                            authProvider.errorMessage ??
                                                "Failed to send OTP",
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                // maroon when filled, grey when empty
                                backgroundColor: hasInput
                                    ? AppColors.maroonColor
                                    : const Color(0xFFAAAAAA),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(
                                  0xFFAAAAAA,
                                ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Continue",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 16.sp),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Center(
                      child: Text(
                        "Having trouble?",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textMutedColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: 15.sp,
                              color: AppColors.blackTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Get Support",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMutedColor,
                          ),
                          children: [
                            const TextSpan(
                              text: "By continuing, you agree to Kuruvi's\n",
                            ),
                            TextSpan(
                              text: "Terms of Service",
                              style: TextStyle(
                                color: AppColors.blackTextColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: " & "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                color: AppColors.blackTextColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   var height = MediaQuery.of(context).size.height;
  //   var width = MediaQuery.of(context).size.width;
  //   final languageNotifier = context.watch<LanguageNotifier>();
  //   return Container(
  //     color: ThemeClass.safeareBackGround,
  //     child: SafeArea(
  //       child: Scaffold(
  //         body: Container(
  //           color: ThemeClass.whiteColor,
  //           height: height,
  //           width: width,
  //           child: SingleChildScrollView(
  //             physics: BouncingScrollPhysics(),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 _buildHeaderImage(height),
  //                 SizedBox(height: 10),
  //                 _buildView(),
  //                 SizedBox(height: height * 0.1),
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
  //
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     child: Form(
  //       key: _formKey,
  //       autovalidateMode:
  //           !isFirstSubmit
  //               ? AutovalidateMode.always
  //               : AutovalidateMode.disabled,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           SizedBox(height: 2.h),
  //           Container(
  //             height: 5.h,
  //             alignment: Alignment.center,
  //             child: Image.asset(ImageAssetPath.imageLogoKuruvi),
  //           ),
  //           SizedBox(height: 2.h),
  //           Center(
  //             child: Text("Login With OTP", style: ThemeClass.mediumTextStyle),
  //           ),
  //           SizedBox(height: 20),
  //           TextFiledWithoutIconWidget(
  //             backColor: ThemeClass.whiteColor,
  //             cursorColor: ThemeClass.mainColor,
  //             hinttext: "Enter Mobile Number",
  //             controllers: _emailController,
  //             isNumber: true,
  //             validator: (value) {
  //               if (value!.isEmpty) {
  //                 return "${languageNotifier.localizedStrings['errorText']!}  ${languageNotifier.localizedStrings['phoneNumberText']!}";
  //               } else if (value.length != 10) {
  //                 return languageNotifier
  //                     .localizedStrings['invalidPhoneNumberText']!;
  //               }
  //               return null;
  //             },
  //             lableText:
  //                 languageNotifier.localizedStrings['enterPhoneNumberText']!,
  //           ),
  //           SizedBox(height: 3.h),
  //           ButtonWidget(
  //             //height: 40,
  //             height: 5.h,
  //             radius: 13.sp,
  //             shadow: false,
  //             padding: EdgeInsets.all(8.sp),
  //             width: MediaQuery.of(context).size.width,
  //             color: ThemeClass.mainColor,
  //             textColor: ThemeClass.brownColor,
  //             isLoading: isLoading,
  //             title: languageNotifier.localizedStrings['loginText']!,
  //             callBack: () {
  //               setState(() {
  //                 isFirstSubmit = false;
  //               });
  //
  //               if (_formKey.currentState!.validate()) {
  //                 setState(() {
  //                   _sendOtp(_emailController.text.toString());
  //                 });
  //               }
  //             },
  //           ),
  //
  //           SizedBox(height: 2.h),
  //           Row(
  //             children: [
  //               Expanded(child: Divider(color: Colors.grey)),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Text(
  //                   "OR",
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(child: Divider(color: Colors.grey)),
  //             ],
  //           ),
  //           SizedBox(height: 2.h),
  //
  //           ButtonWidget(
  //             //height: 40,
  //             height: 5.h,
  //             radius: 13.sp,
  //             shadow: false,
  //             padding: EdgeInsets.all(8.sp),
  //             width: MediaQuery.of(context).size.width,
  //             color: ThemeClass.mainColor,
  //             textColor: ThemeClass.brownColor,
  //             title: "Login with Password",
  //             callBack: () {
  //               PersistentNavBarNavigator.pushNewScreen(
  //                 context,
  //                 screen: LoginScreen(),
  //               );
  //             },
  //           ),
  //           SizedBox(height: 2.h),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 1.8.h),
  //             //  padding: const EdgeInsets.symmetric(horizontal: 14.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   languageNotifier.localizedStrings['notAccountText']!,
  //                   style: ThemeClass.smallTextStyle.copyWith(
  //                     color: ThemeClass.greyColor,
  //                     fontWeight: FontWeight.normal,
  //                     fontSize: 10.sp,
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pushNamed(context, Routes.registerScreen);
  //                   },
  //                   child: Text(
  //                     " ${languageNotifier.localizedStrings['singUpText'] ?? ""}",
  //                     style: ThemeClass.smallTextStyle.copyWith(
  //                       color: ThemeClass.greenColor,
  //                       fontWeight: FontWeight.normal,
  //                       fontSize: 10.sp,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             //height: 30,
  //             height: 4.h,
  //           ),
  //           /*   Center(
  //             child: Text(
  //               "By continuing, you agree to the Terms of service & Privacy policy",
  //               textAlign: TextAlign.center,
  //               style: ThemeClass.smallTextStyle.copyWith(
  //                   color: ThemeClass.greyColor,
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 10.sp),
  //             ),
  //           ),*/
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // final TextEditingController _emailController = TextEditingController();
  // _buildHeaderImage(double height) {
  //   return Stack(
  //     children: [
  //       Container(
  //         height: height / 0.35.h,
  //         width: MediaQuery.of(context).size.width,
  //         decoration: BoxDecoration(
  //           color: ThemeClass.mainColor,
  //           borderRadius: BorderRadius.only(
  //             bottomLeft: Radius.circular(15.w),
  //             bottomRight: Radius.circular(15.w),
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         left: -20.sp,
  //         bottom: 0.sp,
  //         right: -20.sp,
  //         top: -20.sp,
  //         child: Image.asset(ImageAssetPath.loginGroceryLogo),
  //         /* child: Image.asset('assets/images/login_grocery.png'),*/
  //       ),
  //     ],
  //   );
  // }
}
