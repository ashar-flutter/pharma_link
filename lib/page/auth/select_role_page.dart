import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/page/auth/login_page.dart';
import 'package:linkpharma/widgets/Language_selector.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Spacer(),
                        LanguageDropdown(bColors: Colors.white),
                        SizedBox(width: 4.w),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Select Role",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Please select your role for registration",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color.fromARGB(104, 30, 30, 30),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Image.asset("assets/images/logo.png", height: 12.h),
                    SizedBox(height: 3.h),
                    Column(
                      children: [
                        RoleSelectCard(
                          index: 0,
                          selectedIndex: currentUser.userType,
                          title: "I am a Pharmacist/Student/Assistant",
                          subtitle:
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          leftIcon: "assets/images/as40.png",
                          onTap: () {
                            setState(() {
                              currentUser.userType = 0;
                            });
                            Future.delayed(Duration(milliseconds: 300), () {
                              Get.to(LoginPage());
                            });
                          },
                        ),
                        SizedBox(height: 2.h),
                        RoleSelectCard(
                          index: 1,
                          selectedIndex: currentUser.userType,
                          title: "I am Pharmacy Owner",
                          subtitle:
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          leftIcon: "assets/images/as50.png",
                          onTap: () {
                            setState(() {
                              currentUser.userType = 1;
                            });
                            Future.delayed(Duration(milliseconds: 300), () {
                              Get.to(LoginPage());
                            });
                          },
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
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

class RoleSelectCard extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String title;
  final String subtitle;
  final String leftIcon;
  final VoidCallback onTap;

  const RoleSelectCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.title,
    required this.subtitle,
    required this.leftIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 91.w,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff10B66D) : const Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  leftIcon,
                  height: 3.h,
                  color: isSelected
                      ? Colors.white
                      : !isSelected && selectedIndex != 2
                      ? null
                      : MyColors.primary,
                ),
                const Spacer(),
                Image.asset(
                  isSelected
                      ? "assets/images/as26.png"
                      : "assets/images/as27.png",
                  height: 3.h,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? Colors.white : const Color(0xff1E1E1E),
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected
                    ? Colors.white.withOpacity(0.85)
                    : const Color.fromARGB(120, 30, 30, 30),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
