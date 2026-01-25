import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LanguageDropdown extends StatefulWidget {
  final Color bColors;

  const LanguageDropdown({super.key, required this.bColors});
  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  late Map<String, String> selectedLanguage;
  final List<Map<String, String>> languages = [
    {"name": "English", "flag": "assets/icons/uk.jpeg", 'code': 'en'},
    {"name": "French", "flag": "assets/icons/fr.jpeg", 'code': 'fr'},
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = languages
        .where((e) => e["code"] == currentUser.language)
        .first;
  }

  void _updateLanguage(LanguageController controller) {
    controller.language = selectedLanguage["name"]!;
    Get.updateLocale(
      Locale(selectedLanguage["code"]!, selectedLanguage["code"]!),
    );
    currentUser.language = selectedLanguage["code"]!;
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    bool isDropdownOpen = false;
    return GetBuilder<LanguageController>(
      init: LanguageController(),
      builder: (LanguageController con) {
        return Theme(
          data: ThemeData(canvasColor: Colors.white),
          child: Container(
            height: 3.5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(40),
            ),
            child: StatefulBuilder(
              builder: (context, setDropdownState) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton2<Map<String, String>>(
                    value: selectedLanguage,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.only(right: 10),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        isDropdownOpen
                            ? Remix.arrow_up_s_line
                            : Remix.arrow_down_s_line,
                        color: Colors.black,
                        size: 1.5.h,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      offset: const Offset(0, -3),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(16),
                        thickness: WidgetStateProperty.all(4),
                        thumbColor: WidgetStateProperty.all(
                          Colors.grey.shade400,
                        ),
                      ),
                    ),
                    onMenuStateChange: (isOpen) {
                      setDropdownState(() {
                        isDropdownOpen = isOpen;
                      });
                    },
                    onChanged: (Map<String, String>? newValue) {
                      if (newValue == null) return;
                      setState(() {
                        selectedLanguage = newValue;
                      });
                      _updateLanguage(con);
                    },
                    items: languages.map<DropdownMenuItem<Map<String, String>>>(
                      (lang) {
                        return DropdownMenuItem<Map<String, String>>(
                          value: lang,
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(lang["flag"]!),
                                radius: 1.h,
                              ),
                              SizedBox(width: 2.w),
                              text_widget(
                                lang["name"]!,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class LanguageController extends GetxController {
  String language = "";
}
