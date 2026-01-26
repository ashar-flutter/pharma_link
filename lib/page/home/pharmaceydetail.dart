import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/popup.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PharmaceyDetail extends StatefulWidget {
  const PharmaceyDetail({super.key});

  @override
  State<PharmaceyDetail> createState() => _PharmaceyDetailState();
}

class _PharmaceyDetailState extends State<PharmaceyDetail> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<String> jobTypes = [
    "All Jobs",
    "Full Time",
    "Part Time",
    "Replacement",
    "Internship",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 30.h,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.asset(
                            "assets/images/as58.png",
                            width: 100.w,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.5.h),
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 4,
                      effect: ScrollingDotsEffect(
                        activeDotColor: Color(0xff10B66D),
                        dotColor: Colors.white,
                        dotHeight: 6,
                        dotWidth: 6,
                        fixedCenter: true,
                      ),
                    ),
                  ),
                ],
              ),

              Positioned.fill(
                left: 5.w,
                right: 5.w,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                        CircleAvatar(
                          radius: 2.h,
                          backgroundColor: Color(0xffFFFFFF),
                          child: Icon(
                            Remix.heart_line,
                            color: MyColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pharmacy Name Here",
                    style: GoogleFonts.plusJakartaSans(
                      color: Color(0xff1E1E1E),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "46 Avenue de Lascrosse, 31000 - Toulouse",
                    style: GoogleFonts.plusJakartaSans(
                      color: Color.fromARGB(79, 30, 30, 30),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 13.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                      SizedBox(width: 2.w),
                      Container(
                        height: 13.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        Divider(),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Image.asset("assets/images/as36.png", height: 3.h),
                            SizedBox(width: 2.w),
                            Text(
                              "Hours:",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xff1E1E1E),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              " Monday-Friday 8:30-19:00",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(97, 30, 30, 30),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Image.asset("assets/images/as38.png", height: 3.h),
                            SizedBox(width: 2.w),
                            Text(
                              "Services:",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xff1E1E1E),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              " Compounding - Covid testing ...",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(97, 30, 30, 30),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Divider(),
                        SizedBox(height: 2.h),
                        Align(
                          alignment: AlignmentGeometry.topLeft,
                          child: Text(
                            "Available Jobs",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(jobTypes.length, (index) {
                              final bool isSelected = selectedIndex == index;

                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    alignment: Alignment.center,
                                    height: 3.5.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: index == 4 ? 20 : 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xff10B66D)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xff10B66D)
                                            : const Color.fromARGB(
                                                112,
                                                30,
                                                30,
                                                30,
                                              ),
                                      ),
                                    ),
                                    child: Text(
                                      jobTypes[index],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                98,
                                                30,
                                                30,
                                                30,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 22,
                          ),
                          height: 20.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(18),
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
                                  onPress(
                                    ontap: () {
                                      showApplyDialog(context);
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
                                        "Apply",
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 22,
                          ),
                          height: 20.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(18),
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
                                  onPress(
                                    ontap: () {
                                      showApplyDialog(context);
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
                                        "Apply",
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                      ],
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
