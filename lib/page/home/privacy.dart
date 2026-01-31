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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "At LinkPharma, we are committed to protecting your privacy and personal data. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.",
                        style: GoogleFonts.plusJakartaSans(
                          color: Color(0xff0F0F0F),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Please read this privacy policy carefully. If you do not agree with the terms, please do not access the application. We reserve the right to make changes to this Privacy Policy at any time and for any reason.",
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
                          Expanded(
                            child: Text(
                              "Information We Collect: We collect personal information you voluntarily provide when registering, applying for jobs, or contacting us. This may include name, email, phone number, qualifications, and work experience.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(107, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "How We Use Your Information: To provide and maintain our service, notify you about job opportunities, process your applications, improve our app, and communicate important updates.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(99, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Data Sharing: We do not sell your personal data. We may share information with potential employers only when you apply for jobs, and with service providers who assist our operations under strict confidentiality agreements.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(111, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Data Security: We implement security measures to protect your personal information. However, no electronic transmission is 100% secure, and we cannot guarantee absolute security.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(103, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Your Rights: You may access, correct, or delete your personal information. You can opt-out of marketing communications and request data portability as per applicable laws.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(111, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Cookies and Tracking: We use cookies to enhance user experience, analyze app usage, and improve our services. You can control cookie preferences through your device settings.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(113, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Third-Party Links: Our app may contain links to third-party websites or services. We are not responsible for their privacy practices and encourage you to review their policies.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(104, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Children's Privacy: Our services are not intended for users under 18. We do not knowingly collect information from children. If we discover such data, we will delete it immediately.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(103, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
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
                          Expanded(
                            child: Text(
                              "Contact Us: For privacy-related questions, contact our Data Protection Officer at privacy@linkpharma.com or write to us at LinkPharma Headquarters, Digital Street, Tech City.",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(100, 30, 30, 30),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
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