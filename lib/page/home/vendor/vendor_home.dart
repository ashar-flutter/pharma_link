import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/vendor/add_owner.dart';
import 'package:linkpharma/page/home/vendor/pharmacy_add.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/page/home/vendor/vendor_nav.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int currentIndex = 0;

  /// --- LOGIC: 7 DAYS DATA ---
  List<Map<String, dynamic>> getWeeklyStaticData() {
    return [
      {"day": "Monday", "start": "08:30", "end": "19:00", "isOpen": true},
      {"day": "Tuesday", "start": "08:30", "end": "19:00", "isOpen": true},
      {"day": "Wednesday", "start": "08:30", "end": "19:00", "isOpen": true},
      {"day": "Thursday", "start": "08:30", "end": "19:00", "isOpen": true},
      {"day": "Friday", "start": "08:30", "end": "19:00", "isOpen": true},
      {"day": "Saturday", "start": "Closed", "end": "", "isOpen": false},
      {"day": "Sunday", "start": "Closed", "end": "", "isOpen": false},
    ];
  }

  /// --- LOGIC: STATUS BADGE ---
  Widget _buildStatusBadge() {
    DateTime now = DateTime.now();
    bool isWeekday = now.weekday >= 1 && now.weekday <= 5;
    // Check if current time is between 08:30 and 19:00
    bool isWorkingHour =
        (now.hour > 8 || (now.hour == 8 && now.minute >= 30)) && now.hour < 19;
    bool isOpen = isWeekday && isWorkingHour;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOpen ? "OPEN NOW" : "CLOSED",
        style: GoogleFonts.plusJakartaSans(
          color: isOpen ? Colors.green : Colors.red,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// --- WIDGET: 7 DAY LIST ---
  Widget buildWeeklySchedule() {
    final weeklyData = getWeeklyStaticData();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: Column(
        children: weeklyData.map((data) {
          bool isOpen = data['isOpen'];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 0.8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['day'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isOpen ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  isOpen ? "${data['start']} - ${data['end']}" : "Closed",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isOpen ? MyColors.primary : Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  onPress(
                    ontap: () =>
                        Get.find<VendorDrawerController>().toggleDrawer(),
                    child: Image.asset("assets/images/as25.png", height: 4.5.h),
                  ),
                  const Spacer(),
                  onPress(
                    ontap: () => Get.to(NotificationPage()),
                    child: Image.asset("assets/images/as15.png", height: 2.5.h),
                  ),
                  SizedBox(width: 3.w),
                  onPress(
                    ontap: () {
                      Get.find<NavControllerD1>().selectedIndex = 3;
                      Get.find<NavControllerD1>().update();
                    },
                    child: Image.asset("assets/images/as11.png", height: 4.h),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- BANNER PAGEVIEW ---
                        SizedBox(
                          height: 25.h,
                          child: PageView.builder(
                            onPageChanged: (index) =>
                                setState(() => currentIndex = index),
                            itemCount: 5,
                            itemBuilder: (context, index) => Image.asset(
                              "assets/images/as52.png",
                              width: Get.width,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: currentIndex,
                            count: 5,
                            effect: WormEffect(
                              activeDotColor: MyColors.primary,
                              dotHeight: 8,
                              dotWidth: 8,
                              spacing: 6,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // --- PHARMACY INFO ---
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pharmacy Name Here",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xff1E1E1E),
                                      fontSize: 16.8.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "46 Avenue de Lascrosse, 31000 - Toulouse",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color.fromARGB(
                                        79,
                                        30,
                                        30,
                                        30,
                                      ),
                                      fontSize: 13.4.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPress(
                              ontap: () =>
                                  Get.to(PharmacyAdd(isEdit: true)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.primary,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  "Edit Details",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        Text(
                          "We are looking for a dynamic pharmacist with skills in the dermocostetic and vaccination.",
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color.fromARGB(79, 30, 30, 30),
                            fontSize: 13.5.sp,
                          ),
                        ),
                        SizedBox(height: 2.5.h),

                        // --- OWNERS LIST ---
                        Row(
                          children: List.generate(
                            2,
                            (index) => Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: index == 0 ? 2.w : 0,
                                ),
                                height: 15.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                          top: 4,
                                        ),
                                        child: Image.asset(
                                          "assets/icons/del.png",
                                          height: 2.5.h,
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/images/as1.png",
                                      height: 6.h,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Dr. Philippe Martin",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xff1E1E1E),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Center(
                          child: onPress(
                            ontap: () => Get.to(AddOwner()),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                "Add More Owners",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        const Divider(thickness: 0.4),
                        SizedBox(height: 2.h),

                        // --- HOURS & SCHEDULE SECTION ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/as36.png",
                                  height: 2.5.h,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  "Operating Hours",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xff1E1E1E),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            _buildStatusBadge(),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        buildWeeklySchedule(),

                        SizedBox(height: 3.h),

                        // --- SERVICES SECTION ---
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/as38.png",
                              height: 2.5.h,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              "Available Services",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xff1E1E1E),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children:
                              [
                                "Compounding",
                                "Covid Testing",
                                "Pharmacy",
                                "Vaccination",
                              ].map((service) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: MyColors.primary.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    service,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5.sp,
                                      color: MyColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
