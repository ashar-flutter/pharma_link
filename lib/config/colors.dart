import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyColors {
  static Color white = Colors.white;
  static Color primary = Color(0xff10B66D);
  static Color primary1 = Color(0xff10B66D);
  static Color primary2 = Color(0XFF6eaf25);

  static Color black = Color(0xff3C3C3C);
  static Color cyan = Color(0xff6CE5E7);
  static Color background = Color(0xffF9F9F9);
  static Color grey = Color(0xff262626);
  static Color txtclr1 = Color(0xffC65200);
  static Color txtclr2 = Color(0xff929292);
  static Color navColor = Color(0xffFA9A55).withOpacity(0.15);
}

List<String> generateArray(String name, [bool subSearch = false]) {
  name = name.toLowerCase();
  List<String> list = [];
  for (int i = 0; i < name.length; i++) {
    list.add(name.substring(0, i + 1));
  }
  if (subSearch) {
    for (String test in name.split(' ')) {
      for (int i = 0; i < test.length; i++) {
        list.add(test.substring(0, i + 1));
      }
    }
  }
  return list;
}

Widget customDropDown(
  List<String> items,
  String title,
  BuildContext context,
  String? selectedValue,
  ValueChanged<String?> onChanged, {
  double? textHeight,
  double radius = 18,
}) {
  double height = textHeight ?? 6.h;

  return Container(
    height: height,
    width: 100.w,
    decoration: BoxDecoration(
      color: const Color(0xffF8F8F8),
      borderRadius: BorderRadius.circular(radius),
    ),
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // remove splash
        highlightColor: Colors.transparent, // remove highlight
        hoverColor: Colors.transparent, // remove hover
        // selectedRowColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          isExpanded: true,
          value: selectedValue,
          menuMaxHeight: items.length > 8 ? 40.h : null,
          hint: Align(
            alignment: Alignment.centerLeft,
            child: text_widget(
              title,
              color: Colors.black54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          selectedItemBuilder: (context) {
            // This controls how the selected value looks in the button itself
            return items.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black, // normal black when selected
                    fontSize: 14.sp,
                  ),
                ),
              );
            }).toList();
          },
          items: items.map((item) {
            bool isSelected = item == selectedValue;
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item,
                    style: GoogleFonts.plusJakartaSans(
                      color: isSelected ? MyColors.primary : Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check, color: MyColors.primary, size: 16.sp),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(radius),
          icon: Icon(Remix.arrow_down_s_line, size: 2.5.h),
        ),
      ),
    ),
  );
}

void showAnimatedDeleteAccountDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "DeleteAccount",
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeInOut.transform(animation.value) - 1.0;

      return Transform.scale(
        scale: animation.value,
        child: Opacity(
          opacity: animation.value,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Animated Icon
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xff10B66D).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Color(0xff10B66D),
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Title
                  Text(
                    "Delete Account?",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Description
                  Text(
                    "This action cannot be undone. All your data will be permanently removed.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xff10B66D)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xff10B66D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // 👉 delete account logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff10B66D),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Delete",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
