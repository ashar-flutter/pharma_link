import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePicPage extends StatefulWidget {
  const ProfilePicPage({super.key});

  @override
  State<ProfilePicPage> createState() => _ProfilePicPageState();
}

class _ProfilePicPageState extends State<ProfilePicPage> {
  bool rememberMe = false;
  String? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
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
                  height: 90.h,
                  width: Get.width,
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
                            "Profile Picture",
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
                            "Upload picture for your profile",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color.fromARGB(104, 30, 30, 30),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Center(
                          child: Image.asset(
                            "assets/images/logo.png",

                            height: 12.h,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Center(
                          child: Image.asset(
                            "assets/icons/pp.png",
                            height: 15.h,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        gradientButton(
                          "Save",
                          width: Get.width,
                          ontap: () async {
                            // userType == 1
                            //     ? Get.offAll(UserDrawer())
                            //     : Get.offAll(PharmacyAdd(isEdit: false));
                          },
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
