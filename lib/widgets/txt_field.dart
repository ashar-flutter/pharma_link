import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/supportFunctions.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

Widget textFieldWithPrefixSuffuxIconAndHintText(
  String hintText, {
  dynamic suffixIcon,
  dynamic prefixIcon,
  TextEditingController? controller,
  int line = 1,
  bool enable = true,
  bool isEmail = false,
  double? radius,
  double? padd,
  Function? ontap,
  Function? ontapPrefix,
  TextInputAction inputAction = TextInputAction.next,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  Function? ontapSuffix,
  bool obsecure = false,
}) {
  bool obsecureVisible = obsecure;
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return TextField(
        maxLines: line,
        textInputAction: inputAction,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: (value) {
          if (ontap != null) {
            ontap();
          }
        },
        enabled: enable,
        obscureText: obsecureVisible,
        controller: controller,
        style: GoogleFonts.plusJakartaSans(fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),

          suffixIconConstraints: BoxConstraints(),
          suffixIcon:
              suffixIcon is String &&
                  !suffixIcon.isLocalPath &&
                  !suffixIcon.isOnlinePath
              ? Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: onPress(
                    ontap: () {
                      if (ontapSuffix != null) {
                        ontapSuffix();
                      }
                    },
                    child: text_widget(
                      suffixIcon,
                      fontSize: 14.6.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : suffixIcon is String && suffixIcon.isLocalPath
              ? Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: onPress(
                    ontap: () {
                      if (ontapSuffix != null) {
                        ontapSuffix();
                      }
                    },
                    child: Image.asset(suffixIcon, height: 2.3.h),
                  ),
                )
              : suffixIcon is String && suffixIcon.isOnlinePath
              ? Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: onPress(
                    ontap: () {
                      if (ontapSuffix != null) {
                        ontapSuffix();
                      }
                    },
                    child: Image.network(suffixIcon, height: 2.3.h),
                  ),
                )
              : suffixIcon is IconData || obsecure
              ? Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: onPress(
                    ontap: () {
                      if (obsecure) {
                        setState(() {
                          obsecureVisible = !obsecureVisible;
                        });
                      } else {
                        if (ontapSuffix != null) {
                          ontapSuffix();
                        }
                      }
                    },
                    child: Icon(
                      suffixIcon ??
                          (obsecureVisible
                              ? Icons.visibility_off
                              : Icons.remove_red_eye),
                      color: Colors.black45,
                    ),
                  ),
                )
              : const SizedBox(),
          prefixIconConstraints: BoxConstraints(
            minWidth: prefixIcon != null ? 12.w : 5.w,
          ),

          prefixIcon:
              prefixIcon is String &&
                  !prefixIcon.isLocalPath &&
                  !prefixIcon.isOnlinePath
              ? onPress(
                  ontap: () {
                    if (ontapPrefix != null) {
                      ontapPrefix();
                    }
                  },
                  child: text_widget(
                    prefixIcon,
                    fontSize: 14.6.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : prefixIcon is String && prefixIcon.isLocalPath
              ? onPress(
                  ontap: () {
                    if (ontapPrefix != null) {
                      ontapPrefix();
                    }
                  },
                  child: Image.asset(prefixIcon, height: 2.3.h),
                )
              : prefixIcon is String && prefixIcon.isOnlinePath
              ? onPress(
                  ontap: () {
                    if (ontapPrefix != null) {
                      ontapPrefix();
                    }
                  },
                  child: Image.network(prefixIcon, height: 2.3.h),
                )
              : prefixIcon is IconData
              ? onPress(
                  ontap: () {
                    if (ontapPrefix != null) {
                      ontapPrefix();
                    }
                  },
                  child: Icon(prefixIcon, color: Colors.black45),
                )
              : const SizedBox(),
          filled: true,
          fillColor: Color(0xffF7F7F7),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 16),
            borderSide: BorderSide(color: Colors.transparent, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 16),
            borderSide: BorderSide(color: Colors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 16),
            borderSide: BorderSide(color: MyColors.primary, width: 1.5),
          ),
        ),
      );
    },
  );
}
