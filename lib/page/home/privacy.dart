import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                        "Privacy Policy",
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
                  vertical: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's \nstandard dummy text ever since the 1500s, when an unknown \nprinter took a galley of type and scrambled it to make a type \nspecimen book. It has survived not only five centuries",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff0F0F0F),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's \nstandard dummy text ever since the 1500s, when an unknown \nprinter took a galley of type and scrambled it to make a type \nspecimen book. It has survived not only five centuries",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff0F0F0F),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          " Lorem Ipsum is simply dummy text of the printing and typesetting \nindustry.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(107, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "2.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          " Lorem Ipsum is simply dummy text of the printing and typesetting \nindustry.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(99, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "3.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          " Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's \nstandard dummy text ever since",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(111, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "4.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's \nstandard dummy.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(103, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "5.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          " Lorem Ipsum is simply dummy text of the printing and typesetting \nindustry.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(111, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "6.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          " Lorem Ipsum is simply dummy text of the printing and typesetting \nindustry.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(113, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "7.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's \nstandard dummy text ever since",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(104, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "8.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the industry's \nstandard dummy.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(103, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "9.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          " Lorem Ipsum is simply dummy text of the printing and typesetting \nindustry.",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color.fromARGB(100, 30, 30, 30),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
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
