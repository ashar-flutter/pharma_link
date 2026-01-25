import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget text_widget(
  String text, {
  fontSize,
  color,
  fontWeight,
  decoration,
  textAlign,
  letterSpacing,
  decorationColor,
  TextDirection txtDirection = TextDirection.ltr,
  decorationWidth,
  height,
  maxline,
  bool isShadow = false,
  bool isItalic = false,
}) {
  return Text(
    text,
    maxLines: maxline,
    textAlign: textAlign,
    textDirection: txtDirection,
    style: GoogleFonts.plusJakartaSans(
      // height: appLanguage == 'ar' ? 2 : height,
      color: color ?? Colors.black,
      fontSize: fontSize ?? 17.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: decorationColor ?? Colors.transparent,
      decorationThickness: decorationWidth ?? 1.0,
      letterSpacing: letterSpacing,
      shadows: isShadow
          ? [
              const Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ]
          : null,
    ),
  );
}
