import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.primary,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      onPress(
                        ontap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                      ),
                      Spacer(),
                      text_widget(
                        "Change Password",
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/images/back.png",
                        height: 3.5.h,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    text_widget(
                      "Old Password",
                      color: Colors.black,
                      fontSize: 13.4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 0.8.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write your password".tr,

                      prefixIcon: "assets/icons/s3.png",

                      obsecure: true,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "New Password",
                      color: Colors.black,
                      fontSize: 13.4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 0.8.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write your password".tr,

                      prefixIcon: "assets/icons/s3.png",

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

                      prefixIcon: "assets/icons/s3.png",

                      obsecure: true,
                    ),
                    SizedBox(height: 14.h),
                    gradientButton(
                      "Save",
                      width: Get.width,
                      ontap: () async {},
                      height: 5.5,
                      isColor: true,
                      font: 16,
                      clr: MyColors.primary,
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
}
