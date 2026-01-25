import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/auth/signup_user_page.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool rememberMe = false;
  String? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,

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
                              "Forgot Password",
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
                              "Enter email where we send reset password link",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(104, 30, 30, 30),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Center(
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 10.h,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          text_widget(
                            "Email Address",
                            color: Colors.black,
                            fontSize: 13.4.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 0.8.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Write your email".tr,

                            fillColor: Color(0xffF8F8F8),

                            radius: 16,
                            padd: 16,

                            prefixIcon: "assets/icons/s2.png",

                            bColor: Colors.transparent,
                          ),
                          SizedBox(height: 4.h),
                          gradientButton(
                            "Send",
                            width: Get.width,
                            ontap: () async {},
                            height: 5.5,
                            isColor: true,
                            font: 16,
                            clr: MyColors.primary,
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
                      Get.back();
                    },
                    child: Image.asset("assets/images/as24.png", height: 4.h),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
