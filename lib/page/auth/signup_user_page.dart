import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/auth/profile_pic.dart';
import 'package:linkpharma/page/home/user_drawer.dart';
import 'package:linkpharma/page/home/vendor/pharmacy_add.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupUserPage extends StatefulWidget {
  const SignupUserPage({super.key});

  @override
  State<SignupUserPage> createState() => _SignupUserPageState();
}

class _SignupUserPageState extends State<SignupUserPage> {
  String? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Center(
                        child: Text(
                          "Register here",
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
                          "Enter details for registration",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(104, 30, 30, 30),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/icons/pp.png",
                                  height: 15.h,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              text_widget(
                                "First Name",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Write your name".tr,

                                fillColor: Color(0xffF8F8F8),

                                radius: 16,
                                padd: 16,

                                prefixIcon: "assets/images/user.png",
                                bColor: Colors.transparent,
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "Last Name",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Write your name".tr,
                                fillColor: Color(0xffF8F8F8),
                                radius: 16,
                                padd: 16,

                                prefixIcon: "assets/images/user.png",
                                bColor: Colors.transparent,
                              ),
                              SizedBox(height: 2.h),
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

                                fillColor: Color(0xffF8F8F8),

                                radius: 16,
                                padd: 16,

                                prefixIcon: "assets/icons/s3.png",

                                bColor: Colors.transparent,
                                obsecure: true,
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "Confirm Password",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Write your password".tr,
                                fillColor: Color(0xffF8F8F8),
                                radius: 16,
                                padd: 16,

                                prefixIcon: "assets/icons/s3.png",
                                bColor: Colors.transparent,
                                obsecure: true,
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "City",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Write your city".tr,

                                fillColor: Color(0xffF8F8F8),

                                radius: 16,
                                padd: 16,

                                bColor: Colors.transparent,
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "Role",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              customDropDown(
                                ["Role1", "Role2", "Role3"],
                                "Role",
                                context,
                                selectedCountry,
                                (selected) {
                                  setState(() => selectedCountry = selected);
                                },
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "Year Of Experience",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Write your experience".tr,

                                fillColor: Color(0xffF8F8F8),

                                radius: 16,
                                padd: 16,

                                bColor: Colors.transparent,
                              ),
                              SizedBox(height: 2.h),
                              text_widget(
                                "Description",
                                color: Colors.black,
                                fontSize: 13.4.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 0.8.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Write here".tr,

                                fillColor: Color(0xffF8F8F8),

                                radius: 16,
                                padd: 16,
                                line: 5,

                                bColor: Colors.transparent,
                              ),
                              SizedBox(height: 3.h),
                              Center(
                                child: Image.asset("assets/icons/upl.png"),
                              ),
                              SizedBox(height: 5.h),
                              gradientButton(
                                "Create Account",
                                width: Get.width,
                                ontap: () async {
                                  Get.offAll(UserDrawer());
                                },
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
                    ],
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
    );
  }
}
