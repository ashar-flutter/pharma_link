import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/config/supportFunctions.dart';
import 'package:linkpharma/controller/auth_controller.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/services/auth_services.dart';
import 'package:linkpharma/services/firestorage_services.dart';
import 'package:linkpharma/services/loadingService.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/image_widget.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/showPopup.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PharmacyAdd extends StatelessWidget {
  final bool isEdit;
  const PharmacyAdd({super.key, this.isEdit = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.white,
      body: onPress(
        ontap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<AuthController>(
          builder: (con) {
            return Stack(
              children: [
                if (!isEdit)
                  Image.asset(
                    "assets/images/bbg.png",
                    width: Get.width,
                    height: Get.height,
                    fit: BoxFit.cover,
                  ),
                Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          children: [
                            text_widget(
                              isEdit ? "Edit Details" : "Pharmacy Details",
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
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
                          controller: con.scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: con.selectIndex == 0
                                ? page1(con)
                                : con.selectIndex == 1
                                ? page2(context, con)
                                : page3(context, con),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  left: 4.w,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: onPress(
                        ontap: () {
                          if (currentUser.id.isEmpty) {
                            if (con.selectIndex == 0) {
                              Get.back();
                            } else {
                              con.selectIndex--;
                            }
                            con.update();
                          } else {
                            showPopup(
                              context,
                              "Logout",
                              "Are you sure you want to logout and leave the user profile?",
                              "Cancel",
                              "Logout",
                              () => Get.back(),
                              () async {
                                await AuthServices.I.logOut();
                                Get.offAll(SelectRolePage());
                              },
                            );
                          }
                        },
                        child: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column page1(AuthController con) {
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
          controller: con.firstNameController,
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
          controller: con.addressController,
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
          controller: con.zipCodeController,
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
          controller: con.cityController,
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
          controller: con.countryController,
        ),
        SizedBox(height: 2.h),
        text_widget(
          "SIRET",
          color: Colors.black,
          fontSize: 13.4.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 0.8.h),
        textFieldWithPrefixSuffuxIconAndHintText(
          "Write your SIRET".tr,
          controller: con.siretController,
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
          enable: currentUser.id == "",
          controller: con.emailController,
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
          controller: con.passwordController,
          inputAction: TextInputAction.done,
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
          "Write your password again".tr,
          controller: con.reEnterPasswordController,
          inputAction: TextInputAction.done,
          obsecure: true,
        ),
        SizedBox(height: 3.h),
        gradientButton(
          "Next",
          width: Get.width,
          ontap: () => con.page1(),
          height: 5.5,
          isColor: true,
          font: 16,
          clr: MyColors.primary,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Column page2(BuildContext context, AuthController con) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1.h),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 20,
          spacing: 20,
          children: con.images.asMap().entries.map((entry) {
            int index = entry.key;
            dynamic item = entry.value;
            if (item['type'] == 'add') {
              return GestureDetector(
                onTap: () async {
                  File? file = await SupportFunctions.I.getImage(
                    context: context,
                  );
                  if (file != null) {
                    con.images.add({'path': file.path, 'type': 'image'});
                  }
                  con.update();
                },
                child: Container(
                  height: 12.4.h,
                  width: 12.4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 28, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 12.4.h,
                    width: 12.4.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(item['path']),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: GestureDetector(
                      onTap: () {
                        if (con.images[index]['type'] == 'image') {
                          con.images.removeAt(index);
                          con.update();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 3),
                          ],
                        ),
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }
          }).toList(),
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
          line: 4,
          inputAction: TextInputAction.done,
          controller: con.descriptionController,
        ),
        SizedBox(height: 1.h),
        Divider(thickness: 0.3),
        SizedBox(height: 1.h),
        Row(
          children: [
            text_widget(
              "Services",
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            Spacer(),
            onPress(
              ontap: () {
                TextEditingController singleServiceController =
                    TextEditingController();
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        text_widget(
                          "Add Service",
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            SizedBox(width: 3.w),
                            Expanded(
                              child: textFieldWithPrefixSuffuxIconAndHintText(
                                "Write here".tr,
                                controller: singleServiceController,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            gradientButton(
                              "Add",
                              width: 3.w,
                              ontap: () {
                                if (singleServiceController.text != "") {
                                  con.services.add(
                                    singleServiceController.text,
                                  );
                                  singleServiceController.clear();
                                  con.update();
                                  Get.back();
                                }
                              },
                              height: 5.5,
                              isColor: true,
                              font: 16,
                              clr: MyColors.primary,
                            ),
                            SizedBox(width: 3.w),
                          ],
                        ),
                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
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
            ),
          ],
        ),
        if (con.services.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Column(
            children: con.services.map((service) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: textFieldWithPrefixSuffuxIconAndHintText(
                        "Service Name".tr,
                        enable: false,
                        controller: TextEditingController(text: service),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    InkWell(
                      onTap: () {
                        con.services.removeAt(con.services.indexOf(service));
                        con.update();
                      },
                      child: Image.asset("assets/icons/del.png", height: 4.h),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ] else ...[
          SizedBox(height: 1.h),
        ],

        Divider(thickness: 0.3),
        SizedBox(height: 2.h),
        Wokring(),
        SizedBox(height: 3.h),
        gradientButton(
          "Next",
          width: Get.width,
          ontap: () => con.page2(context),
          height: 5.5,
          isColor: true,
          font: 16,
          clr: MyColors.primary,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Column page3(BuildContext context, AuthController con) {
    TextEditingController nameController = TextEditingController();
    TextEditingController sureNameController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text_widget(
          "Add New Owner",
          color: Colors.black,
          fontSize: 15.6.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 2.h),
        Container(
          height: 15.h,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: onPress(
            ontap: () async {
              con.profileImage = await SupportFunctions.I.getImage(
                context: context,
                isCircleCrop: true,
              );
              con.update();
            },
            child: Center(
              child: con.profileImage != null
                  ? imageWidget(
                      image: con.profileImage!.path,
                      borderRadius: 100,
                      width: 15.h,
                      height: 15.h,
                    )
                  : Image.asset("assets/icons/pp.png", fit: BoxFit.fill),
            ),
          ),
        ),
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
          controller: nameController,
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
          controller: sureNameController,
        ),
        SizedBox(height: 2.h),
        gradientButton(
          "Add Owner",
          width: Get.width,
          ontap: () async {
            if (con.profileImage == null) {
              EasyLoading.showInfo("Please select an image");
              return;
            }
            if (nameController.text.isEmpty ||
                sureNameController.text.isEmpty) {
              EasyLoading.showInfo("Please fill all fields");
              return;
            }
            LoadingService.I.show(context);
            String url = await FirestorageServices.I.uploadImage(
              con.profileImage!,
              "owners",
            );
            con.owners.add({
              "name": nameController.text,
              "sureName": sureNameController.text,
              "image": url,
            });
            LoadingService.I.dismiss();
            nameController.clear();
            sureNameController.clear();
            con.profileImage = null;
            con.update();
          },
          height: 5.5,
          isColor: false,
          font: 16,
          txtColor: MyColors.primary,
          clr: MyColors.white,
        ),
        SizedBox(height: 1.h),
        Divider(thickness: 0.3),
        SizedBox(height: 1.h),
        text_widget("Owners Details", fontSize: 15.sp),
        SizedBox(height: 1.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: con.owners.length,
          itemBuilder: (context, index) {
            final owner = con.owners[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        con.owners.removeAt(index);
                        con.update();
                      },
                      child: Image.asset("assets/icons/del.png", height: 18),
                    ),
                  ),
                  Spacer(),
                  Image.network(owner['image'], height: 70, fit: BoxFit.cover),
                  Spacer(),
                  Text(
                    '${owner['name']} ${owner['sureName']}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xff1E1E1E),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 3.h),
        gradientButton(
          "Save",
          width: Get.width,
          ontap: () => con.page3(context),
          height: 5.5,
          isColor: true,
          font: 16,
          clr: MyColors.primary,
        ),
        SizedBox(height: 3.h),
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
    return buildOpeningHoursSection(context);
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
      builder: (BuildContext context, child) {
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

  Widget buildOpeningHoursSection(BuildContext context) {
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
          fontSize: 15.sp,
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
                  _buildDayRow(context, dayNames[index], index),
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
  Widget _buildDayRow(BuildContext context, String day, int index) {
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
                  child: Text(
                    "-",
                    style: GoogleFonts.plusJakartaSans(color: Colors.black),
                  ),
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
