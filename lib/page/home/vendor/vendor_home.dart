import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/vendor/add_owner.dart';
import 'package:linkpharma/page/home/vendor/pharmacy_add.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/page/home/vendor/vendor_nav.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/user_model.dart';
import '../../../services/firestore_services.dart';

class VendorOwnerController extends GetxController {
  static VendorOwnerController get instance => Get.find();

  void addOwnerToList(Map<String, dynamic> owner) {
    currentUser.owners.add(owner);
    update();
  }

  void removeOwnerFromList(int index) {
    if (index < currentUser.owners.length) {
      currentUser.owners.removeAt(index);
      update();
    }
  }

  void refreshOwnersList(List<Map<String, dynamic>> owners) {
    currentUser.owners = owners;
    update();
  }
}

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int currentIndex = 0;
  PageController pageController = PageController();

  List<Map<String, dynamic>> getWeeklyScheduleData() {
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

  Widget _buildStatusBadge() {
    DateTime now = DateTime.now();
    bool isWeekday = now.weekday >= 1 && now.weekday <= 5;
    bool isWorkingHour =
        (now.hour > 8 || (now.hour == 8 && now.minute >= 30)) && now.hour < 19;
    bool isOpen = isWeekday && isWorkingHour;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
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

  Widget buildWeeklySchedule() {
    final weeklyData = getWeeklyScheduleData();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.05)),
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
  void initState() {
    super.initState();
    Get.put(VendorOwnerController(), permanent: true);
  }

  Future<void> _refreshOwnersFromFirestore() async {
    try {
      UserModel updatedUser = await FirestoreServices.I.getUser(currentUser.id);
      Get.find<VendorOwnerController>().refreshOwnersList(updatedUser.owners);
    } catch (e) {
      if (kDebugMode) {
        print("Error refreshing owners: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorOwnerController>(
      builder: (ownerController) {
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
                        child: Image.asset(
                          "assets/images/as25.png",
                          height: 4.5.h,
                        ),
                      ),
                      const Spacer(),
                      onPress(
                        ontap: () => Get.to(NotificationPage()),
                        child: Image.asset(
                          "assets/images/as15.png",
                          height: 2.5.h,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      // Line 69 ke paas UPDATE:
                      onPress(
                        ontap: () {
                          Get.find<NavControllerD1>().selectedIndex = 3;
                          Get.find<NavControllerD1>().update();
                        },
                        child:
                            (currentUser.image.isNotEmpty ||
                                (currentUser.owners.isNotEmpty &&
                                    currentUser.owners[0]['image'] != null &&
                                    currentUser.owners[0]['image']
                                        .toString()
                                        .isNotEmpty))
                            ? CircleAvatar(
                                radius: 2.h,
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: currentUser.image.isNotEmpty
                                        ? currentUser.image
                                        : currentUser.owners[0]['image'],
                                    height: 4.h,
                                    width: 4.h,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 4.h,
                                      height: 4.h,
                                      color: Colors.transparent,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          width: 4.h,
                                          height: 4.h,
                                          color: Colors.transparent,
                                        ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 2.h,
                                backgroundColor: Colors.white,
                              ),
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
                            SizedBox(
                              height: 25.h,
                              child: PageView.builder(
                                controller: pageController,
                                onPageChanged: (index) =>
                                    setState(() => currentIndex = index),
                                itemCount: currentUser.images.isNotEmpty
                                    ? currentUser.images.length
                                    : 0,
                                itemBuilder: (BuildContext context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: currentUser.images[index],
                                        width: Get.width,
                                        height: 25.h,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              width: Get.width,
                                              height: 25.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              width: Get.width,
                                              height: 25.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 1.5.h),
                            if (currentUser.images.isNotEmpty)
                              Center(
                                child: AnimatedSmoothIndicator(
                                  activeIndex: currentIndex,
                                  count: currentUser.images.length,
                                  effect: WormEffect(
                                    activeDotColor: MyColors.primary,
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    spacing: 6,
                                  ),
                                ),
                              ),
                            if (currentUser.images.isEmpty)
                              Container(
                                height: 25.h,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey[200],
                                ),
                                child: Center(
                                  child: Text(
                                    "No images added",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.grey[600],
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser.firstName.isNotEmpty
                                            ? currentUser.firstName
                                            : "",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xff1E1E1E),
                                          fontSize: 16.8.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        currentUser.address.isNotEmpty &&
                                                currentUser.city.isNotEmpty
                                            ? "${currentUser.address}${currentUser.zipCode.isNotEmpty ? ', ${currentUser.zipCode}' : ''} - ${currentUser.city}"
                                            : "",
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
                              currentUser.description.isNotEmpty
                                  ? currentUser.description
                                  : "",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color.fromARGB(79, 30, 30, 30),
                                fontSize: 13.5.sp,
                              ),
                            ),
                            SizedBox(height: 2.5.h),
                            if (currentUser.owners.isNotEmpty)
                              Column(
                                children: [
                                  Row(
                                    children: List.generate(
                                      currentUser.owners.length > 2
                                          ? 2
                                          : currentUser.owners.length,
                                      (index) => Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            right: index == 0 ? 2.w : 0,
                                          ),
                                          height: 15.h,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 8,
                                                        top: 4,
                                                      ),
                                                  child: onPress(
                                                    ontap: () {
                                                      ownerController
                                                          .removeOwnerFromList(
                                                            index,
                                                          );
                                                      FirestoreServices.I
                                                          .addUser(currentUser);
                                                    },
                                                    child: Image.asset(
                                                      "assets/icons/del.png",
                                                      height: 2.5.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              currentUser.owners[index]['image'] !=
                                                          null &&
                                                      currentUser
                                                          .owners[index]['image']
                                                          .toString()
                                                          .isNotEmpty
                                                  ? CircleAvatar(
                                                      radius: 3.h,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                        child: CachedNetworkImage(
                                                          imageUrl: currentUser
                                                              .owners[index]['image'],
                                                          width: 6.h,
                                                          height: 6.h,
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (
                                                                context,
                                                                url,
                                                              ) => Container(
                                                                width: 6.h,
                                                                height: 6.h,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                          errorWidget:
                                                              (
                                                                context,
                                                                url,
                                                                error,
                                                              ) => Container(
                                                                width: 6.h,
                                                                height: 6.h,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .grey[300],
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 6.h,
                                                      height: 6.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                              SizedBox(height: 5),
                                              Text(
                                                currentUser.owners[index]['name']
                                                                ?.toString()
                                                                .isNotEmpty ==
                                                            true &&
                                                        currentUser
                                                                .owners[index]['sureName']
                                                                ?.toString()
                                                                .isNotEmpty ==
                                                            true
                                                    ? "${currentUser.owners[index]['name']} ${currentUser.owners[index]['sureName']}"
                                                    : currentUser
                                                              .owners[index]['name']
                                                              ?.toString()
                                                              .isNotEmpty ==
                                                          true
                                                    ? currentUser
                                                          .owners[index]['name']
                                                          .toString()
                                                    : "",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: const Color(
                                                        0xff1E1E1E,
                                                      ),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (currentUser.owners.length > 2)
                                    SizedBox(height: 2.h),
                                  if (currentUser.owners.length > 2)
                                    Row(
                                      children: List.generate(
                                        currentUser.owners.length - 2,
                                        (index) => Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              right: index == 0 ? 2.w : 0,
                                            ),
                                            height: 15.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF6F6F6),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 8,
                                                          top: 4,
                                                        ),
                                                    child: onPress(
                                                      ontap: () {
                                                        ownerController
                                                            .removeOwnerFromList(
                                                              index + 2,
                                                            );
                                                        FirestoreServices.I
                                                            .addUser(
                                                              currentUser,
                                                            );
                                                      },
                                                      child: Image.asset(
                                                        "assets/icons/del.png",
                                                        height: 2.5.h,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                currentUser.owners[index +
                                                                2]['image'] !=
                                                            null &&
                                                        currentUser
                                                            .owners[index +
                                                                2]['image']
                                                            .toString()
                                                            .isNotEmpty
                                                    ? CircleAvatar(
                                                        radius: 3.h,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                100,
                                                              ),
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                currentUser
                                                                    .owners[index +
                                                                    2]['image'],
                                                            width: 6.h,
                                                            height: 6.h,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (
                                                                  context,
                                                                  url,
                                                                ) => Container(
                                                                  width: 6.h,
                                                                  height: 6.h,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .grey[300],
                                                                  ),
                                                                ),
                                                            errorWidget:
                                                                (
                                                                  context,
                                                                  url,
                                                                  error,
                                                                ) => Container(
                                                                  width: 6.h,
                                                                  height: 6.h,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .grey[300],
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 6.h,
                                                        height: 6.h,
                                                        decoration:
                                                            BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                      ),
                                                SizedBox(height: 5),
                                                Text(
                                                  currentUser
                                                              .owners[index +
                                                                  2]['name']
                                                              ?.toString()
                                                              .isNotEmpty ==
                                                          true
                                                      ? currentUser
                                                            .owners[index +
                                                                2]['name']
                                                            .toString()
                                                      : "",
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        color: const Color(
                                                          0xff1E1E1E,
                                                        ),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            SizedBox(height: 2.h),
                            Center(
                              child: onPress(
                                ontap: () async {
                                  await Get.to(() => AddOwner());
                                  _refreshOwnersFromFirestore();
                                },
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
                            if (currentUser.services.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    children: currentUser.services.map((
                                      service,
                                    ) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyColors.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: MyColors.primary.withValues(
                                              alpha: 0.5,
                                            ),
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
                                ],
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
      },
    );
  }
}
