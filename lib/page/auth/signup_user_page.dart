import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/config/supportFunctions.dart';
import 'package:linkpharma/controller/auth_controller.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/services/auth_services.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/image_widget.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/showPopup.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignupUserPage extends StatelessWidget {
  const SignupUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return onPress(
      ontap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (con) => Stack(
            children: [
              Image.asset(
                "assets/images/bbg.png",
                width: Get.width,
                height: Get.height,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 88.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 3.h),
                          Center(
                            child: Text(
                              currentUser.id == ""
                                  ? "Register here"
                                  : "User Profile",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xff1E1E1E),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 3),
                          Center(
                            child: Text(
                              currentUser.id == ""
                                  ? "Enter details for registration"
                                  : "Enter details for profile update",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(104, 30, 30, 30),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: onPress(
                                      ontap: () async {
                                        con.profileImage =
                                            await SupportFunctions.I.getImage(
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
                                    prefixIcon: Icons.person_outlined,
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
                                    prefixIcon: Icons.person_outlined,
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
                                    prefixIcon: Icons.email_outlined,
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
                                    prefixIcon: Icons.lock_outline,
                                    obsecure: true,
                                    controller: con.passwordController,
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
                                    prefixIcon: Icons.lock_outline,
                                    obsecure: true,
                                    controller: con.reEnterPasswordController,
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
                                    prefixIcon: Icons.location_city_outlined,
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
                                    "Enter your country (e.g., France, Pakistan)".tr,
                                    prefixIcon: Icons.public_outlined,
                                    controller: con.userCountryController,
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
                                    ["Owner", "Doctor", "Pharmacist"],
                                    "Role",
                                    context,
                                    con.role,
                                    (selected) {
                                      con.role = selected;
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
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icons.work_outline,
                                    controller: con.experienceController,
                                  ),
                                  SizedBox(height: 2.h),
                                  text_widget(
                                    "RPPS",
                                    color: Colors.black,
                                    fontSize: 13.4.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 0.8.h),
                                  textFieldWithPrefixSuffuxIconAndHintText(
                                    "Write your RPPS".tr,
                                    prefixIcon: Icons.document_scanner_outlined,
                                    controller: con.rppsController,
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
                                  SizedBox(
                                    height: 10.h,
                                    child: Center(
                                      child: onPress(
                                        ontap: () async {
                                          con.cv = await SupportFunctions.I
                                              .getFile(context: context);
                                          con.update();
                                        },
                                        child: con.cv == null
                                            ? Image.asset(
                                                "assets/icons/upl.png",
                                                fit: BoxFit.fill,
                                              )
                                            : imageWidget(
                                                image: con.cv!.path,
                                                height: 10.h,
                                                borderRadius: 16,
                                                width: 100.h,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  gradientButton(
                                    currentUser.id == ""
                                        ? "Create Account"
                                        : "Update Profile",
                                    width: Get.width,
                                    ontap: () => con.signUpUserEmail(context),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                left: 4.w,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: onPress(
                      ontap: () {
                        if (currentUser.id.isEmpty) {
                          Get.back();
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
          ),
        ),
      ),
    );
  }
}
