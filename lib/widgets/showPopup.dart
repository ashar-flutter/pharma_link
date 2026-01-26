import 'package:flutter/material.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showPopup(
  BuildContext context,
  String title,
  String description,
  String leftButtonText,
  String rightButtonText,
  Function leftFunction,
  Function rightFunction,
) {
  Color primaryColor = MyColors.primary;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[50],
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              text_widget(
                title,
                fontWeight: FontWeight.w600,
                fontSize: 18.5.sp,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: text_widget(
                  description,
                  fontWeight: FontWeight.w300,
                  textAlign: TextAlign.center,
                  fontSize: 15.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 4.h,
                        child: onPress(
                          ontap: () {
                            leftFunction();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: primaryColor),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 3.w, right: 3.w),
                                child: text_widget(
                                  leftButtonText,
                                  maxline: 1,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: SizedBox(
                        height: 4.h,
                        child: onPress(
                          ontap: () {
                            rightFunction();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: primaryColor),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 3.w, right: 3.w),
                                child: text_widget(
                                  rightButtonText,
                                  maxline: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
