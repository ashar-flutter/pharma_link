import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showApplyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,

    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                onPress(
                  ontap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    radius: 1.7.h,
                    backgroundColor: const Color.fromARGB(57, 255, 255, 255),
                    child: Image.asset("assets/images/as37.png", height: 2.5.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),

              width: 90.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Apply for Staff Pharmacist",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xff1E1E1E),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Text(
                      "Pharmacy Name Here",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color.fromARGB(93, 30, 30, 30),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Spacer(),
                        _infoChip("Part time", 3.h, 18.w),
                        SizedBox(width: 2.w),
                        _infoChip("25 h", 2.5.h, 13.w),
                        SizedBox(width: 2.w),
                        _infoChip("CDI", 2.5.h, 18.w),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    Row(
                      children: [
                        Text(
                          "Message to pharmacy",
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xff1E1E1E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    Container(
                      height: 16.h,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            maxLines: null,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write here",
                              counterText: "",
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.sp,
                              color: const Color(0xff1E1E1E),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Text(
                              "0/500",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Center(
                      child: Container(
                        height: 5.3.h,
                        width: 45.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Apply Now",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 15.4.sp,
                            fontWeight: FontWeight.bold,
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
    },
  );
}

Widget _infoChip(String text, double height, double width) {
  return Container(
    alignment: Alignment.center,
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: MyColors.primary.withOpacity(0.12),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        color: MyColors.primary,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
