import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/ontap.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

Widget gradientButton(
  String title, {
  bool isColor = false,
  bool isGrediant = false,

  Color clr = Colors.white,
  Function? ontap,
  Color txtColor = Colors.white,
  bColor,
  bWidth,
  bool add = true,
  radius,
  weight,

  bool icon = false,
  double font = 0,
  double height = 0,
  double width = 0,
}) {
  return onPress(
    ontap: () {
      if (ontap != null) {
        ontap();
      }
    },
    child: Container(
      width: width.w,
      height: height == 0 ? 6.3.h : height.h,
      decoration: BoxDecoration(
        gradient: isGrediant
            ? LinearGradient(
                colors: [MyColors.primary, MyColors.primary2],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isColor || !isGrediant ? clr : Colors.transparent,
        borderRadius: radius ?? BorderRadius.circular(12),
        border: isColor
            ? null
            : Border.all(color: bColor ?? MyColors.primary, width: bWidth ?? 1),
        boxShadow: [],
      ),

      child: icon
          ? Row(
              children: [
                Spacer(),
                add
                    ? Image.asset("assets/icons/add.png", height: 2.4.h)
                    : Image.asset("assets/step/cart.gif", height: 8.h),
                SizedBox(width: 3.w),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontSize: font == 0 ? 17.sp : font.sp,
                    fontWeight: weight ?? FontWeight.w600,
                    color: txtColor,
                  ),
                ),
                Spacer(),
              ],
            )
          : Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: font == 0 ? 17.sp : font.sp,
                  fontWeight: FontWeight.w600,
                  color: txtColor,
                ),
              ),
            ),
    ),
  );
}
