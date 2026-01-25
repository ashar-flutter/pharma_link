import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddNewJob extends StatefulWidget {
  const AddNewJob({super.key});

  @override
  State<AddNewJob> createState() => AddNewJobState();
}

class AddNewJobState extends State<AddNewJob> {
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
                        "Add New Job",
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      text_widget(
                        "Job Title",
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
                      Row(
                        children: [
                          text_widget(
                            "Contract Type ",
                            color: Colors.black,
                            fontSize: 13.4.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          text_widget(
                            "*",
                            color: Colors.red,
                            fontSize: 13.4.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.8.h),
                      customDropDown(
                        ["Role1", "Role2", "Role3"],
                        "Select",
                        context,
                        selectedCountry,
                        (selected) {
                          setState(() => selectedCountry = selected);
                        },
                      ),
                      SizedBox(height: 2.h),

                      text_widget(
                        "Coefficient ",
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
                        "Start Date",
                        color: Colors.black,
                        fontSize: 13.4.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 0.8.h),

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
                      SizedBox(height: 2.h),

                      text_widget(
                        "Role Description",
                        color: Colors.black,
                        fontSize: 13.4.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 0.8.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write here".tr,

                        fillColor: Color(0xffF8F8F8),

                        radius: 16,
                        line: 5,
                        padd: 16,

                        bColor: Colors.transparent,
                      ),

                      SizedBox(height: 2.h),

                      text_widget(
                        "Number of Hours/week",
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

                      SizedBox(height: 6.h),
                      gradientButton(
                        "Published",
                        width: Get.width,
                        ontap: () async {},
                        height: 5.5,
                        isColor: true,
                        font: 16,
                        clr: MyColors.primary,
                      ),
                      SizedBox(height: 2.h),
                      gradientButton(
                        "On Hold",
                        width: Get.width,
                        ontap: () async {},
                        height: 5.5,
                        isColor: false,
                        txtColor: MyColors.primary,
                        font: 16,
                        clr: MyColors.white,
                      ),
                      SizedBox(height: 12.h),
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
