import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/page/home/chat/chat_page.dart';
import 'package:linkpharma/page/home/vendor/vendor_profile_view.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VendorJobsDetailPage extends StatelessWidget {
  const VendorJobsDetailPage({super.key});

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      onPress(
                        ontap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                      ),
                      Spacer(),
                      text_widget(
                        "Job Details",
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
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  // vertical: 22,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 22,
                        ),
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Staff Pharmacist",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xff1E1E1E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                    "Active",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 2.5.h,
                                  width: 13.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(67, 16, 182, 110),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    "25 h",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xff10B66D),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Container(
                                  alignment: Alignment.center,
                                  height: 2.5.h,
                                  width: 13.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(67, 16, 182, 110),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    "CDI",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xff10B66D),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Container(
                                  alignment: Alignment.center,
                                  height: 2.5.h,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(67, 16, 182, 110),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    "Part time",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xff10B66D),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "We are looking for a dynamic pharmacist with skills in the \ndermocostetic and vaccination .We are looking for the \ndynamic pharmacist with skills in dermocostetic and \nvaccination ...",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(94, 30, 30, 30),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        alignment: Alignment.center,
                        height: 5.5.h,
                        width: 88.w,
                        decoration: BoxDecoration(
                          color: Color(0xff10B66D),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          "Inactive Job",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xffFFFFFF),
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Divider(),
                      SizedBox(height: 2.h),
                      Text(
                        "Candidates",
                        style: GoogleFonts.plusJakartaSans(
                          color: Color(0xff1E1E1E),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 6.h,
                        width: 90.w,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/as73.png",
                              height: 2.5.h,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write text here",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        height: 24.h,
                        width: 88.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.5.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(102, 30, 30, 30),
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                onPress(
                                  ontap: () {
                                    Get.to(VendorProfileView());
                                  },
                                  child: Image.asset(
                                    "assets/images/as12.png",
                                    height: 5.h,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Muhammad Salman",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Color(0xff1E1E1E),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "3 Years Experience",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Color.fromARGB(97, 30, 30, 30),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "We are looking for a dynamic pharmacist with skills in the \ndermocostetic and vaccination .We are looking for the \ndynamic pharmacist with skills in dermocostetic and \nvaccination ...",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(97, 30, 30, 30),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 3.6.h,
                                  width: 25.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xff1E1E1E),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Text(
                                    "Download CV",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                onPress(
                                  ontap: () {
                                    Get.to(ChatScreenView(isBot: false));
                                  },
                                  child: Container(
                                    height: 3.6.h,
                                    width: 25.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xff10B66D),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Text(
                                      "Chat",
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
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
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
