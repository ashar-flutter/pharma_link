import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/controller/user_profile_controller.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/image_widget.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserEditprofile extends StatefulWidget {
  const UserEditprofile({super.key});

  @override
  State<UserEditprofile> createState() => UserEditprofileState();
}

class UserEditprofileState extends State<UserEditprofile> {
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, child) {
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
    return GetBuilder<UserProfileController>(
      init: UserProfileController(),
      builder: (con) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.primary,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15.h,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: onPress(
                              ontap: () => con.selectImage(context),
                              child: Center(
                                child: con.profileImage != null
                                    ? imageWidget(
                                        image: con.profileImage!.path,
                                        borderRadius: 100,
                                        width: 15.h,
                                        height: 15.h,
                                      )
                                    : currentUser.image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: currentUser.image,
                                          width: 15.h,
                                          height: 15.h,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                "assets/icons/pp.png",
                                                fit: BoxFit.fill,
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                "assets/icons/pp.png",
                                                fit: BoxFit.fill,
                                              ),
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/icons/pp.png",
                                        fit: BoxFit.fill,
                                      ),
                              ),
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
                            prefixIcon: "assets/images/user.png",
                            controller: con.firstNameController,
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
                            prefixIcon: "assets/images/user.png",
                            controller: con.lastNameController,
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
                            prefixIcon: "assets/icons/s2.png",
                            controller: con.emailController,
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
                            controller: con.cityController,
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
                            [
                              "Part Time",
                              "Full Time",
                              "Replacement",
                              "Internship",
                              "Owner",
                              "Doctor",
                              "Pharmacist",
                            ],
                            "Role",
                            context,
                            con.selectedCountry,
                            (selected) {
                              con.selectedCountry = selected;
                              con.update();
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
                            controller: con.experienceController,
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
                            line: 5,
                            controller: con.descriptionController,
                          ),
                          SizedBox(height: 3.h),
                          Center(
                            child: onPress(
                              ontap: () => con.selectCV(context),
                              child: con.cvFile != null
                                  ? imageWidget(
                                      image: con.cvFile!.path,
                                      height: 10.h,
                                      borderRadius: 16,
                                      width: 100.h,
                                    )
                                  : currentUser.cv.isNotEmpty
                                  ? Column(
                                      children: [
                                        Image.asset("assets/icons/upl.png"),
                                        SizedBox(height: 1.h),
                                        text_widget(
                                          "CV already uploaded",
                                          fontSize: 14.sp,
                                          color: MyColors.primary,
                                        ),
                                      ],
                                    )
                                  : Image.asset("assets/icons/upl.png"),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          gradientButton(
                            "Download CV",
                            width: Get.width,
                            ontap: () => con.downloadCV(),
                            height: 5.5,
                            isColor: false,
                            txtColor: MyColors.primary,
                            font: 16,
                            clr: MyColors.white,
                          ),
                          SizedBox(height: 2.h),
                          gradientButton(
                            "Save",
                            width: Get.width,
                            ontap: () => con.updateProfile(context),
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
      ),
    );
  }
}
