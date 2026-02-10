import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/filter_controller.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showDropdown(FilterController controller) {
    _overlayEntry?.remove();

    List<String> cities = controller.getCitiesToShow();
    if (cities.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
        child: Container(
          color: Colors.black.withOpacity(0.1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 200),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: Get.width - 40,
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffE0E0E0)),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        String city = cities[index];
                        bool isDisabled = city == "No cities available";

                        return GestureDetector(
                          onTap: isDisabled
                              ? null
                              : () {
                                  controller.onCitySelected(city);
                                  _overlayEntry?.remove();
                                  _overlayEntry = null;
                                },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isDisabled
                                  ? Color(0xfff5f5f5)
                                  : Colors.white,
                              border: index > 0
                                  ? Border(
                                      top: BorderSide(
                                        color: Color(0xffE0E0E0),
                                        width: 0.5,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Text(
                              city,
                              style: GoogleFonts.plusJakartaSans(
                                color: isDisabled
                                    ? Color(0xff9E9E9E)
                                    : Colors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
      builder: (filterController) {
        return Scaffold(
          backgroundColor: MyColors.primary,
          body: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
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
                        "Filters",
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
              SizedBox(height: 2.h),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text_widget("Location", fontSize: 15.sp),
                          SizedBox(height: 0.8.h),
                          GestureDetector(
                            onTap: () {
                              _showDropdown(filterController);
                            },
                            child: Container(
                              height: 5.h,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0xffE0E0E0)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      filterController.selectedLocation ??
                                          "Select city",
                                      style: GoogleFonts.plusJakartaSans(
                                        color:
                                            filterController.selectedLocation !=
                                                null
                                            ? Colors.black
                                            : Color(0xff9E9E9E),
                                        fontSize: 14.sp,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/icons/loc.png",
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text_widget("Job Type", fontSize: 15.6.sp),
                                  SizedBox(height: 1.5.h),
                                  _buildJobTypeRow(
                                    "Full Time",
                                    filterController,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Divider(
                                    color: Color.fromRGBO(30, 30, 30, 40),
                                    thickness: 0.2,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  _buildJobTypeRow(
                                    "Part Time",
                                    filterController,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Divider(
                                    color: Color.fromRGBO(30, 30, 30, 40),
                                    thickness: 0.2,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  _buildJobTypeRow(
                                    "Replacement",
                                    filterController,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Divider(
                                    color: Color.fromRGBO(30, 30, 30, 40),
                                    thickness: 0.2,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  _buildJobTypeRow(
                                    "Internship",
                                    filterController,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          text_widget("Period From", fontSize: 15.sp),
                          SizedBox(height: 0.8.h),
                          GestureDetector(
                            onTap: () => _selectDate(context, filterController),
                            child: Container(
                              height: 5.h,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0xffE0E0E0)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      filterController.selectedStartDate != null
                                          ? "${filterController.selectedStartDate!.day}/${filterController.selectedStartDate!.month}/${filterController.selectedStartDate!.year}"
                                          : "Select date",
                                      style: GoogleFonts.plusJakartaSans(
                                        color:
                                            filterController
                                                    .selectedStartDate !=
                                                null
                                            ? Colors.black
                                            : Color(0xff9E9E9E),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/icons/date.png",
                                    height: 2.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          gradientButton(
                            "Apply",
                            width: 80.w,
                            ontap: () {
                              filterController.applyFilters();
                            },
                            height: 5.5,
                            isColor: true,
                            font: 16,
                            clr: MyColors.primary,
                          ),
                          SizedBox(height: 1.h),
                          gradientButton(
                            "Clear",
                            width: 80.w,
                            ontap: () {
                              filterController.clearFilters();
                              _overlayEntry?.remove();
                              _overlayEntry = null;
                            },
                            height: 5.5,
                            txtColor: MyColors.primary,
                            isColor: false,
                            font: 16,
                            clr: MyColors.white,
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
      },
    );
  }

  Widget _buildJobTypeRow(String type, FilterController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style: GoogleFonts.plusJakartaSans(
            color: Color.fromRGBO(30, 30, 30, 40),
            fontSize: 14.sp,
          ),
        ),
        FlutterSwitch(
          height: 3.3.h,
          width: 15.w,
          toggleColor: MyColors.primary,
          inactiveColor: Colors.white,
          activeColor: Colors.white,
          inactiveToggleColor: Color.fromRGBO(30, 30, 30, 40),
          activeToggleColor: MyColors.primary,
          value: controller.selectedJobTypes.contains(type),
          onToggle: (val) => controller.toggleJobType(type),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    FilterController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xff10B66D),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.setStartDate(picked);
    }
  }
}
