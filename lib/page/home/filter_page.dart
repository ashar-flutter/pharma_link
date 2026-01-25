import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  bool b1 = false;
  bool b2 = false;
  bool b3 = false;
  bool b4 = false;

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
                        "Filters",
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    text_widget("Location", fontSize: 15.sp),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Select".tr,

                      fillColor: Color(0xffF6F6F6),

                      radius: 16,
                      enable: false,
                      padd: 16,

                      suffixIcon: "assets/icons/loc.png",

                      bColor: Colors.transparent,
                    ),

                    SizedBox(height: 2.h),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text_widget("Job Type", fontSize: 15.6.sp),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text_widget(
                                  "Full Time",
                                  color: Color(0xff1E1E1E).withOpacity(0.40),
                                  fontSize: 14.sp,
                                ),
                                FlutterSwitch(
                                  height: 3.3.h,
                                  width: 15.w,
                                  inactiveSwitchBorder: BoxBorder.all(
                                    color: Colors.black12,
                                  ),

                                  toggleColor: MyColors.primary,
                                  inactiveToggleColor: Color(
                                    0xff1E1E1E,
                                  ).withOpacity(0.40),

                                  activeColor: Colors.white,
                                  activeToggleColor: MyColors.primary,
                                  inactiveColor: Colors.white,
                                  toggleBorder: Border.all(
                                    color: MyColors.white,
                                  ),
                                  value: b1,
                                  onToggle: (val) {
                                    setState(() {
                                      b1 = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 0.4.h),
                            Divider(
                              color: Color(0xff1E1E1E).withOpacity(0.40),
                              thickness: 0.2,
                            ),
                            SizedBox(height: 0.4.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text_widget(
                                  "Part Time",
                                  color: Color(0xff1E1E1E).withOpacity(0.40),
                                  fontSize: 14.sp,
                                ),
                                FlutterSwitch(
                                  height: 3.3.h,
                                  width: 15.w,
                                  inactiveSwitchBorder: BoxBorder.all(
                                    color: Colors.black12,
                                  ),

                                  toggleColor: MyColors.primary,
                                  inactiveToggleColor: Color(
                                    0xff1E1E1E,
                                  ).withOpacity(0.40),

                                  activeColor: Colors.white,
                                  activeToggleColor: MyColors.primary,
                                  inactiveColor: Colors.white,
                                  toggleBorder: Border.all(
                                    color: MyColors.white,
                                  ),
                                  value: b1,
                                  onToggle: (val) {
                                    setState(() {
                                      b1 = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 0.4.h),
                            Divider(
                              color: Color(0xff1E1E1E).withOpacity(0.40),
                              thickness: 0.2,
                            ),
                            SizedBox(height: 0.4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text_widget(
                                  "Replacement",
                                  color: Color(0xff1E1E1E).withOpacity(0.40),
                                  fontSize: 14.sp,
                                ),
                                FlutterSwitch(
                                  height: 3.3.h,
                                  width: 15.w,
                                  inactiveSwitchBorder: BoxBorder.all(
                                    color: Colors.black12,
                                  ),

                                  toggleColor: MyColors.primary,
                                  inactiveToggleColor: Color(
                                    0xff1E1E1E,
                                  ).withOpacity(0.40),

                                  activeColor: Colors.white,
                                  activeToggleColor: MyColors.primary,
                                  inactiveColor: Colors.white,
                                  toggleBorder: Border.all(
                                    color: MyColors.white,
                                  ),
                                  value: b1,
                                  onToggle: (val) {
                                    setState(() {
                                      b1 = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 0.4.h),
                            Divider(
                              color: Color(0xff1E1E1E).withOpacity(0.40),
                              thickness: 0.2,
                            ),
                            SizedBox(height: 0.4.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text_widget(
                                  "Internship",
                                  color: Color(0xff1E1E1E).withOpacity(0.40),
                                  fontSize: 14.sp,
                                ),
                                FlutterSwitch(
                                  height: 3.3.h,
                                  width: 15.w,
                                  inactiveSwitchBorder: BoxBorder.all(
                                    color: Colors.black12,
                                  ),

                                  toggleColor: MyColors.primary,
                                  inactiveToggleColor: Color(
                                    0xff1E1E1E,
                                  ).withOpacity(0.40),

                                  activeColor: Colors.white,
                                  activeToggleColor: MyColors.primary,
                                  inactiveColor: Colors.white,
                                  toggleBorder: Border.all(
                                    color: MyColors.white,
                                  ),
                                  value: b1,
                                  onToggle: (val) {
                                    setState(() {
                                      b1 = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    text_widget("Period From", fontSize: 15.sp),
                    SizedBox(height: 1.h),
                    onPress(
                      ontap: () => selectDate(context),

                      child: textFieldWithPrefixSuffuxIconAndHintText(
                        "Select".tr,

                        fillColor: Color(0xffF6F6F6),

                        radius: 16,
                        enable: false,
                        padd: 16,

                        suffixIcon: "assets/icons/date.png",

                        bColor: Colors.transparent,
                      ),
                    ),
                    Spacer(),

                    gradientButton(
                      "Apply",
                      width: 80.w,
                      ontap: () async {},
                      height: 5.5,
                      isColor: true,

                      font: 16,
                      clr: MyColors.primary,
                    ),
                    SizedBox(height: 1.h),
                    gradientButton(
                      "Clear",
                      width: 80.w,
                      ontap: () async {},
                      height: 5.5,
                      txtColor: MyColors.primary,
                      isColor: false,

                      font: 16,
                      clr: MyColors.white,
                    ),
                    SizedBox(height: 3.h),
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
