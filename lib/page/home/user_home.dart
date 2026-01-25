import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/bottom_nav.dart';
import 'package:linkpharma/page/home/user_drawer.dart';
import 'package:linkpharma/page/home/filter_page.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/page/home/search_page.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        onPress(
                          ontap: () {
                            Get.find<UserDrawerController>().toggleDrawer();
                          },
                          child: Image.asset(
                            "assets/images/as25.png",
                            height: 4.h,
                          ),
                        ),
                        Spacer(),
                        onPress(
                          ontap: () {
                            Get.to(NotificationPage());
                          },
                          child: Image.asset(
                            "assets/images/as15.png",
                            height: 2.7.h,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        onPress(
                          ontap: () {
                            Get.find<NavControllerD>().selectedIndex = 3;
                            Get.find<NavControllerD>().update();
                          },
                          child: Image.asset(
                            "assets/images/as11.png",
                            height: 4.h,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: onPress(
                            ontap: () {
                              Get.to(SearchPage());
                            },
                            child: Container(
                              height: 5.h,
                              width: 70.w,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(50, 255, 255, 255),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 14.sp,
                                ),
                                cursorColor: Color(0xffFFFFFF),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintText: "Search text here...",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: Color(0xffFFFFFF),
                                  ),
                                  enabled: false,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 2.w),
                                    child: Image.asset(
                                      "assets/images/as74.png",
                                      height: 2.h,
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                    minHeight: 2.h,
                                    minWidth: 2.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        onPress(
                          ontap: () {
                            Get.to(FilterPage());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 5.h,
                            width: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Color(0xffFFFFFF),
                            ),
                            child: Image.asset(
                              "assets/images/as18.png",
                              height: 1.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Toulouse",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xff1E1E1E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "See All",
                                  style: GoogleFonts.plusJakartaSans(
                                    decoration: TextDecoration.underline,
                                    color: const Color(0xff10B66D),
                                    decorationColor: MyColors.primary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(3, (index) {
                                final bool isLast = index == 2;

                                return onPress(
                                  ontap: () {
                                    Get.to(PharmaceyDetail());
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 18,
                                      right: isLast
                                          ? 18
                                          : 0, // ✅ right padding only on last item
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF6F6F6),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(18),
                                                ),
                                            child: Image.asset(
                                              "assets/images/as52.png",
                                              width: 40.w,
                                              height: 14.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              "Pharmacie du Centre",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color(
                                                      0xff1E1E1E,
                                                    ),
                                                    fontSize: 14.5.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              "Pharmacist-Full Time,\nInternship, Assistant",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color.fromARGB(
                                                      110,
                                                      30,
                                                      30,
                                                      30,
                                                    ),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Blagnac",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xff1E1E1E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "See All",
                                  style: GoogleFonts.plusJakartaSans(
                                    decoration: TextDecoration.underline,
                                    color: const Color(0xff10B66D),
                                    decorationColor: MyColors.primary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(3, (index) {
                                final bool isLast = index == 2;

                                return onPress(
                                  ontap: () {
                                    Get.to(PharmaceyDetail());
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 18,
                                      right: isLast
                                          ? 18
                                          : 0, // ✅ right padding only on last item
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF6F6F6),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(18),
                                                ),
                                            child: Image.asset(
                                              "assets/images/as52.png",
                                              width: 40.w,
                                              height: 14.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              "Pharmacie du Centre",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color(
                                                      0xff1E1E1E,
                                                    ),
                                                    fontSize: 14.5.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              "Pharmacist-Full Time,\nInternship, Assistant",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color.fromARGB(
                                                      110,
                                                      30,
                                                      30,
                                                      30,
                                                    ),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          SizedBox(height: 3.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Colomiers",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xff1E1E1E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "See All",
                                  style: GoogleFonts.plusJakartaSans(
                                    decoration: TextDecoration.underline,
                                    color: const Color(0xff10B66D),
                                    decorationColor: MyColors.primary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(3, (index) {
                                final bool isLast = index == 2;

                                return onPress(
                                  ontap: () {
                                    Get.to(PharmaceyDetail());
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 18,
                                      right: isLast
                                          ? 18
                                          : 0, // ✅ right padding only on last item
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF6F6F6),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(18),
                                                ),
                                            child: Image.asset(
                                              "assets/images/as52.png",
                                              width: 40.w,
                                              height: 14.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              "Pharmacie du Centre",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color(
                                                      0xff1E1E1E,
                                                    ),
                                                    fontSize: 14.5.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              "Pharmacist-Full Time,\nInternship, Assistant",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: const Color.fromARGB(
                                                      110,
                                                      30,
                                                      30,
                                                      30,
                                                    ),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
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
