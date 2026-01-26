import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff10B66D),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff10B66D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
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
                        "Contact Us",
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
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText("Write here".tr),
                    SizedBox(height: 2.h),
                    Text(
                      "Email",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText("Write here".tr),
                    SizedBox(height: 2.h),
                    Text(
                      "Subject",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText("Write here".tr),
                    SizedBox(height: 2.h),

                    Text(
                      "Description",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here".tr,

                      line: 5,
                    ),
                    SizedBox(height: 4.h),
                    gradientButton(
                      "Send",
                      width: Get.width,

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
        ],
      ),
    );
  }
}
