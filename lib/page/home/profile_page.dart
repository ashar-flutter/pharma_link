import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/page/home/change_location.dart';
import 'package:linkpharma/page/home/change_password.dart';
import 'package:linkpharma/page/home/user_editProfile.dart';
import 'package:linkpharma/page/home/vendor/edit_profile_vendor.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});

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
              child: text_widget(
                "Profile",
                color: Colors.white,
                fontSize: 21.sp,
              ),
            ),
          ),
          SizedBox(height: 2.h),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    height: 10.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Color(0xff10B66D),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/as6.png", height: 6.h),
                        SizedBox(width: 4.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daniel Russel",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xffFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "abc1231234@gmai.com",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xffFFFFFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        onPress(
                          ontap: () {
                            // userType != 1
                            //     ? Get.to(EditProfileVendor())
                            //     : Get.to(UserEditprofile());
                          },
                          child: Image.asset(
                            "assets/images/as44.png",
                            height: 3.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  onPress(
                    ontap: () {
                      Get.to(ChangePassword());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 33),
                      height: 6.h,
                      width: 85.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/as5.png', height: 2.3.h),
                          SizedBox(width: 3.w),
                          Text(
                            "Change Password",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  onPress(
                    ontap: () {
                      Get.to(ChangeLocation(back: true));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 33),
                      height: 6.h,
                      width: 85.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/as45.png', height: 2.3.h),
                          SizedBox(width: 3.w),
                          Text(
                            "Change Location",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  onPress(
                    ontap: () {
                      showAnimatedDeleteAccountDialog(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 33),
                      height: 6.h,
                      width: 85.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/as22.png', height: 2.3.h),
                          SizedBox(width: 3.w),
                          Text(
                            "Delete Account",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff10B66D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Get.offAll(SelectRolePage());
                      },
                      child: Text(
                        "Logout",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
