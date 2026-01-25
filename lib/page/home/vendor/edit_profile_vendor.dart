import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfileVendor extends StatefulWidget {
  const EditProfileVendor({super.key});

  @override
  State<EditProfileVendor> createState() => EditProfileVendorState();
}

class EditProfileVendorState extends State<EditProfileVendor> {
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                          "Edit Profile",
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
                            "assets/icons/pp.png",
                            height: 13.h,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        text_widget(
                          "First Name",
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

                        SizedBox(height: 12.h),
                        gradientButton(
                          "Save",
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
          ],
        ),
      ),
    );
  }
}
