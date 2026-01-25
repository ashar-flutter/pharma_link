import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PharmacyDetails extends StatefulWidget {
  final bool isEdit;
  const PharmacyDetails({super.key, this.isEdit = true});

  @override
  State<PharmacyDetails> createState() => PharmacyDetailsState();
}

class PharmacyDetailsState extends State<PharmacyDetails> {
  int Selectindex = 0;

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
                      widget.isEdit
                          ? onPress(
                              ontap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                "assets/images/as24.png",
                                height: 4.h,
                              ),
                            )
                          : Selectindex == 0
                          ? Image.asset("assets/images/as24.png", height: 4.h)
                          : onPress(
                              ontap: () {
                                if (Selectindex == 1) {
                                  setState(() {
                                    Selectindex = 0;
                                  });
                                } else if (Selectindex == 2) {
                                  setState(() {
                                    Selectindex = 1;
                                  });
                                }
                              },
                              child: Image.asset(
                                "assets/images/as24.png",
                                height: 4.h,
                              ),
                            ),
                      Spacer(),
                      text_widget(
                        widget.isEdit ? "Edit Details" : "Pharmacy Details",
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
                  child: Selectindex == 0
                      ? page1()
                      : Selectindex == 1
                      ? page2()
                      : page3(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column page1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),

        text_widget(
          "Pharmacy Name",
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
          "Address",
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
          "Postal Code",
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
          "City",
          color: Colors.black,
          fontSize: 13.4.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 0.8.h),
        textFieldWithPrefixSuffuxIconAndHintText(
          "Write here".tr,
          prefixIcon: "assets/icons/loc.png",
          fillColor: Color(0xffF8F8F8),
          radius: 16,
          padd: 16,

          bColor: Colors.transparent,
        ),
        SizedBox(height: 2.h),
        text_widget(
          "Country",
          color: Colors.black,
          fontSize: 13.4.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 0.8.h),
        textFieldWithPrefixSuffuxIconAndHintText(
          "Write here".tr,
          prefixIcon: "assets/icons/loc.png",
          fillColor: Color(0xffF8F8F8),
          radius: 16,
          padd: 16,

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
        SizedBox(height: 4.h),
        gradientButton(
          "Next",
          width: Get.width,
          ontap: () async {
            setState(() {
              Selectindex = 1;
            });
          },
          height: 5.5,
          isColor: true,
          font: 16,
          clr: MyColors.primary,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Column page2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 20,
          spacing: 20,
          children: [
            Image.asset("assets/icons/add.png", height: 12.4.h),
            Image.asset("assets/icons/iimg.png", height: 12.4.h),
            Image.asset("assets/icons/iimg.png", height: 12.4.h),
            Image.asset("assets/icons/iimg.png", height: 12.4.h),
            Image.asset("assets/icons/iimg.png", height: 12.4.h),
            Image.asset("assets/icons/iimg.png", height: 12.4.h),
          ],
        ),
        SizedBox(height: 2.h),
        text_widget(
          "Pharmacy description",
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
        SizedBox(height: 1.h),
        Divider(thickness: 0.3),
        SizedBox(height: 1.h),
        Row(
          children: [
            text_widget(
              "Services",
              color: Colors.black,
              fontSize: 15.5.sp,
              fontWeight: FontWeight.w500,
            ),
            Spacer(),
            Container(
              alignment: Alignment.center,
              height: 3.h,
              width: 23.w,
              decoration: BoxDecoration(
                color: Color(0xff10B66D),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                "Add More",
                style: GoogleFonts.plusJakartaSans(
                  color: Color(0xffFFFFFF),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        Row(
          children: [
            Expanded(
              child: textFieldWithPrefixSuffuxIconAndHintText(
                "Service Name".tr,

                fillColor: Color(0xffF8F8F8),

                radius: 16,
                padd: 16,

                bColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 3.w),
            Image.asset("assets/icons/del.png", height: 4.h),
          ],
        ),
        SizedBox(height: 2.h),

        Row(
          children: [
            Expanded(
              child: textFieldWithPrefixSuffuxIconAndHintText(
                "Service Name".tr,

                fillColor: Color(0xffF8F8F8),

                radius: 16,
                padd: 16,

                bColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 3.w),
            Image.asset("assets/icons/del.png", height: 4.h),
          ],
        ),
        SizedBox(height: 2.h),
        Divider(thickness: 0.3),
        SizedBox(height: 2.h),
        Wokring(),
        SizedBox(height: 4.h),
        gradientButton(
          "Next",
          width: Get.width,
          ontap: () async {
            setState(() {
              Selectindex = 2;
            });
          },
          height: 5.5,
          isColor: true,
          font: 16,
          clr: MyColors.primary,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Column page3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),

        text_widget(
          "Add New Owner",
          color: Colors.black,
          fontSize: 15.6.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 2.h),
        Center(child: Image.asset("assets/icons/pp.png", height: 13.h)),
        SizedBox(height: 2.h),

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
        SizedBox(height: 4.h),
        gradientButton(
          "Add Owner",
          width: Get.width,
          ontap: () async {},
          height: 5.5,
          isColor: false,
          font: 16,
          txtColor: MyColors.primary,
          clr: MyColors.white,
        ),
        SizedBox(height: 2.h),
        Divider(thickness: 0.3),
        SizedBox(height: 2.h),
        text_widget("Owners Details", fontSize: 18.sp),
        SizedBox(height: 2.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 15.h,
                width: 45.w,
                decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Image.asset("assets/icons/del.png", height: 2.5.h),
                        SizedBox(width: 2.w),
                      ],
                    ),
                    Image.asset("assets/images/as1.png", height: 6.h),
                    SizedBox(height: 5),
                    Text(
                      "Dr. Philippe Martin",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Container(
                height: 15.h,
                width: 45.w,
                decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Image.asset("assets/icons/del.png", height: 2.5.h),
                        SizedBox(width: 2.w),
                      ],
                    ),
                    Image.asset("assets/images/as1.png", height: 6.h),
                    SizedBox(height: 5),
                    Text(
                      "Dr. Philippe Martin",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),
        gradientButton(
          "Save",
          width: Get.width,
          ontap: () async {
            Get.offAll(VendorDrawer());
          },
          height: 5.5,
          isColor: true,
          font: 16,
          clr: MyColors.primary,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }
}

class WorkingTimeModel {
  String id;
  String name;
  double totalHours;
  // A list of 7 maps, one for each day of the week
  List<Map<String, dynamic>> days;

  WorkingTimeModel({
    this.id = "",
    this.name = "",
    this.totalHours = 0.0,
    List<Map<String, dynamic>>? days,
  }) : days = days ?? _defaultDays();

  // Helper to initialize 7 days with default values
  static List<Map<String, dynamic>> _defaultDays() {
    return List.generate(
      7,
      (index) => {
        "isOpen": index < 5, // Mon-Fri open by default
        "start": const TimeOfDay(hour: 9, minute: 0),
        "end": const TimeOfDay(hour: 17, minute: 0),
      },
    );
  }
}

class Wokring extends StatefulWidget {
  const Wokring({super.key});

  @override
  State<Wokring> createState() => WokringState();
}

class WokringState extends State<Wokring> {
  int Selectindex = 0;
  WorkingTimeModel workingTimeModel = WorkingTimeModel();
  double calculateTotalWeeklyHours() {
    double totalMinutes = 0;

    // Iterate through your model's days
    for (var day in workingTimeModel.days) {
      if (day["isOpen"] == true && day["start"] != null && day["end"] != null) {
        TimeOfDay start = day["start"];
        TimeOfDay end = day["end"];

        int startMinutes = start.hour * 60 + start.minute;
        int endMinutes = end.hour * 60 + end.minute;

        // Handle cases where end time is past midnight if necessary
        if (endMinutes > startMinutes) {
          totalMinutes += (endMinutes - startMinutes);
        }
      }
    }

    return totalMinutes / 60; // Convert to hours
  }

  @override
  Widget build(BuildContext context) {
    return buildOpeningHoursSection();
  }

  Future<void> _selectTime(
    BuildContext context,
    int dayIndex,
    bool isStartTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? workingTimeModel.days[dayIndex]["start"]
          : workingTimeModel.days[dayIndex]["end"],
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff10B66D),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xff10B66D),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          workingTimeModel.days[dayIndex]["start"] = picked;
        } else {
          workingTimeModel.days[dayIndex]["end"] = picked;
        }
      });
    }
  }

  Widget buildOpeningHoursSection() {
    List<String> dayNames = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text_widget(
          "Opening Days & Hours",
          color: Colors.black,
          fontSize: 13.4.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 1.5.h),

        // 3. Weekly Schedule List
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            children: List.generate(7, (index) {
              return Column(
                children: [
                  _buildDayRow(dayNames[index], index),
                  if (index < 6) _buildDivider(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // Helper widget for each day
  Widget _buildDayRow(String day, int index) {
    bool isOpen = workingTimeModel.days[index]["isOpen"];
    TimeOfDay start = workingTimeModel.days[index]["start"];
    TimeOfDay end = workingTimeModel.days[index]["end"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day Name
          Row(
            children: [
              FlutterSwitch(
                width: 40.0,
                height: 20.0,
                valueFontSize: 10.0,
                toggleSize: 15.0,
                value: isOpen,
                borderRadius: 30.0,
                padding: 2.0,
                activeColor: MyColors.primary,
                onToggle: (val) {
                  setState(() {
                    workingTimeModel.days[index]["isOpen"] = val;
                  });
                },
              ),
              SizedBox(width: 3.w),
              Text(
                day,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isOpen ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),

          // Time / Status
          if (!isOpen)
            Text(
              "Closed",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.redAccent,
              ),
            )
          else
            Row(
              children: [
                onPress(
                  ontap: () => _selectTime(context, index, true),
                  child: Text(
                    start.format(context),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: MyColors.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text("-", style: TextStyle(color: Colors.black)),
                ),
                onPress(
                  ontap: () => _selectTime(context, index, false),
                  child: Text(
                    end.format(context),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: MyColors.primary,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 4.w,
      endIndent: 4.w,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}
