import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddOwner extends StatefulWidget {
  const AddOwner({super.key});

  @override
  State<AddOwner> createState() => AddOwnerState();
}

class AddOwnerState extends State<AddOwner> {
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
                          "assets/images/as24.png",
                          height: 4.h,
                        ),
                      ),
                      Spacer(),
                      text_widget(
                        "Add Owner",
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/images/as24.png",
                        height: 4.h,
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
                    Center(
                      child: Image.asset("assets/icons/pp.png", height: 13.h),
                    ),
                    SizedBox(height: 4.h),

                    text_widget(
                      "Name",
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

                      bColor: Colors.transparent,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "Surname",
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

                      bColor: Colors.transparent,
                    ),

                    SizedBox(height: 14.h),
                    gradientButton(
                      "Add",
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
