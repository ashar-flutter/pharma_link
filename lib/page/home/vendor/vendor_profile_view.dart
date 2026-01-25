import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/chat/chat_page.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VendorProfileView extends StatefulWidget {
  const VendorProfileView({super.key});

  @override
  State<VendorProfileView> createState() => VendorProfileViewState();
}

class VendorProfileViewState extends State<VendorProfileView> {
  String? selectedCountry;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff10B66D),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xff10B66D)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      debugPrint("Selected Date: $pickedDate");
    }
  }

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
                        "User Profile",
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/images/as24.png",
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/as9.png",
                          height: 17.h,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      Center(
                        child: text_widget(
                          "William Jack",
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Center(
                        child: text_widget(
                          "williamjack123@gmail.com",
                          fontSize: 14.sp,
                          color: Color(0xff1E1E1E).withOpacity(0.40),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    text_widget(
                                      "Pharmacist",
                                      fontSize: 15.sp,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                      "Role",
                                      fontSize: 13.4.sp,
                                      color: Color(
                                        0xff1E1E1E,
                                      ).withOpacity(0.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    text_widget(
                                      "2 Years",
                                      fontSize: 15.sp,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                      "Experience",
                                      fontSize: 13.4.sp,
                                      color: Color(
                                        0xff1E1E1E,
                                      ).withOpacity(0.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    text_widget(
                                      "New York",
                                      fontSize: 15.sp,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                      "City",
                                      fontSize: 13.4.sp,
                                      color: Color(
                                        0xff1E1E1E,
                                      ).withOpacity(0.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      text_widget(
                        "We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination .We are looking for the dynamic pharmacist with skills in dermocostetic and vaccination . We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination .We are looking for the dynamic pharmacist with skills in dermocostetic and vaccination .  We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination .We are looking for the dynamic pharmacist with skills in dermocostetic and vaccination . We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination .We are looking for the dynamic pharmacist with skills in dermocostetic and vaccination . ",
                        fontSize: 13.4.sp,
                        color: Color(0xff1E1E1E).withOpacity(0.40),
                      ),
                      SizedBox(height: 6.h),
                      gradientButton(
                        "Download CV",
                        width: Get.width,
                        ontap: () async {},

                        height: 5.5,
                        isColor: false,
                        txtColor: MyColors.primary,
                        font: 16,
                        clr: MyColors.white,
                      ),
                      SizedBox(height: 2.h),
                      gradientButton(
                        "Message",
                        width: Get.width,
                        ontap: () async {
                          Get.to(ChatScreenView(isBot: false));
                        },
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
          ),
        ],
      ),
    );
  }
}
