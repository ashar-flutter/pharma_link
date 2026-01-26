import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Ensure this is imported

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Controller to keep track of the PageView
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff10B66D),
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(color: Color(0xff10B66D)),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Row(
                  children: [
                    onPress(
                      ontap: () => Get.back(),
                      child: Image.asset(
                        "assets/images/back.png",
                        height: 3.5.h,
                      ),
                    ),
                    Spacer(),
                    text_widget(
                      "Details",
                      color: Colors.white,
                      fontSize: 21.sp,
                    ),
                    Spacer(),
                    // Transparent placeholder to keep title centered
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

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                // Added to prevent overflow on small screens
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- MULTIPLE IMAGES SECTION ---
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 25.5.h,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: 4, // Number of images
                            itemBuilder: (BuildContext context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: Image.asset(
                                  "assets/images/as58.png", // Using same static image
                                  width: 100.w,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        // --- SMALL IMAGE INDICATOR ---
                        Padding(
                          padding: EdgeInsets.only(bottom: 1.5.h),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: 4,
                            effect: ScrollingDotsEffect(
                              // Small, scrolling dot style
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

                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pharmacy Name Here",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xff1E1E1E),
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "46 Avenue de Lascrosse, 31000 - Toulouse",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color.fromARGB(91, 30, 30, 30),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              onPress(
                                ontap: () => Get.to(PharmaceyDetail()),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 3.h,
                                  width: 25.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xff10B66D),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    "More Detail",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Divider(),
                          SizedBox(height: 1.h),
                          Text(
                            "Job Details",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),

                          // Job Detail Card
                          Container(
                            padding: EdgeInsets.all(22),
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Staff Pharmacist",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xff1E1E1E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    _buildBadge("25 h"),
                                    SizedBox(width: 2.w),
                                    _buildBadge("CDI"),
                                    SizedBox(width: 2.w),
                                    _buildBadge("Part time", width: 20.w),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination...",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color.fromARGB(94, 30, 30, 30),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 1.h),
                          Divider(),
                          SizedBox(height: 1.h),

                          Text(
                            "Applied Details",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "23 Jun 2025 | 05:00 AM",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff10B66D),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination...",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color.fromARGB(94, 30, 30, 30),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.h),

                          // Action Button
                          onPress(
                            ontap: () {
                              // Withdraw logic
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 5.5.h,
                              width: 88.w,
                              decoration: BoxDecoration(
                                color: Color(0xff10B66D),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                "Withdraw Application",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h), // Bottom padding
                        ],
                      ),
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

  // Helper method for the status badges
  Widget _buildBadge(String text, {double? width}) {
    return Container(
      alignment: Alignment.center,
      height: 2.5.h,
      width: width ?? 13.w,
      decoration: BoxDecoration(
        color: Color.fromARGB(67, 16, 182, 110),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: Color(0xff10B66D),
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
