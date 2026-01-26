import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/config/supportFunctions.dart';
import 'package:linkpharma/controller/auth_controller.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/page/auth/forgot_password.dart';
import 'package:linkpharma/page/auth/signup_user_page.dart';
import 'package:linkpharma/page/home/vendor/pharmacy_add.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (con) => Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Image.asset(
                "assets/images/bbg.png",
                width: Get.width,
                height: Get.height,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 88.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),

                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3.h),
                            Center(
                              child: Text(
                                "Welcome Back!",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color(0xff1E1E1E),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Center(
                              child: Text(
                                "Let’s login for explore continues",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color.fromARGB(104, 30, 30, 30),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Center(
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 12.h,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            text_widget(
                              "Email Address",
                              color: Colors.black,
                              fontSize: 13.4.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 0.8.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Write your email".tr,
                              controller: con.emailController,
                              prefixIcon: Icons.email_outlined,
                            ),
                            SizedBox(height: 2.h),
                            text_widget(
                              "Password",
                              color: Colors.black,
                              fontSize: 13.4.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 0.8.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Write your password".tr,
                              controller: con.passwordController,
                              inputAction: TextInputAction.done,
                              prefixIcon: Icons.lock_outline_rounded,
                              obsecure: true,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                RoundCheckBox(
                                  uncheckedColor: Colors.transparent,
                                  size: 2.2.h,
                                  isChecked: con.rememberMe,
                                  checkedColor: Color(0xffF8BF0F),
                                  checkedWidget: Icon(
                                    Remix.check_fill,
                                    color: Colors.white,
                                    size: 1.4.h,
                                  ),
                                  onTap: (selected) {},
                                ),
                                SizedBox(width: 3.w),
                                onPress(
                                  ontap: () => con.rememberMe = !con.rememberMe,
                                  child: text_widget(
                                    "Remember me",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const Spacer(),
                                onPress(
                                  ontap: () {
                                    Get.to(ForgotPassword());
                                  },
                                  child: text_widget(
                                    "Forgot Password?",
                                    color: MyColors.primary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            gradientButton(
                              "Login",
                              width: Get.width,
                              ontap: () => con.loginWithEmail(context),
                              height: 5.5,
                              isColor: true,
                              font: 16,
                              clr: MyColors.primary,
                            ),
                            SizedBox(height: 3.h),
                            Center(
                              child: onPress(
                                ontap: () {
                                  currentUser.userType == 1
                                      ? Get.to(SignupUserPage())
                                      : Get.to(PharmacyAdd(isEdit: false));
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Don’t have an account, ',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.sp,
                                      color: MyColors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Create new Account?',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14.sp,
                                          color: MyColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Center(
                              child: Image.asset(
                                "assets/icons/or.png",
                                height: 2.h,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                Spacer(),
                                onPress(
                                  ontap: () {
                                    con.loginWithFacebook(context);
                                  },
                                  child: Image.asset(
                                    "assets/icons/facebook.png",
                                    height: 5.h,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                onPress(
                                  ontap: () {
                                    con.loginWithGoogle(context);
                                  },
                                  child: Image.asset(
                                    "assets/icons/google.png",
                                    height: 5.h,
                                  ),
                                ),
                                if (GetPlatform.isIOS) ...[
                                  SizedBox(width: 3.w),
                                  onPress(
                                    ontap: () {
                                      con.loginWithApple(context);
                                    },
                                    child: Image.asset(
                                      "assets/icons/apple.png",
                                      height: 5.h,
                                    ),
                                  ),
                                ],
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'By signing up you agree to our ',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13.4.sp,
                                    color: Color(0xff1E1E1E).withOpacity(0.4),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.4.sp,
                                        color: MyColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          SupportFunctions.I.launchLink(
                                            'https://example.com/terms',
                                          );
                                        },
                                    ),
                                    TextSpan(
                                      text: ' and ',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.4.sp,
                                        color: Color(
                                          0xff1E1E1E,
                                        ).withOpacity(0.4),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Conditions of Use',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.4.sp,
                                        color: MyColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          SupportFunctions.I.launchLink(
                                            'https://example.com/conditions',
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                left: 4.w,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: onPress(
                      ontap: () {
                        Get.offAll(SelectRolePage());
                      },
                      child: Image.asset(
                        "assets/images/back.png",
                        height: 3.5.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
