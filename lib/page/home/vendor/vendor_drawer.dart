import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/page/home/contact.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/privacy.dart';
import 'package:linkpharma/page/home/vendor/vendor_nav.dart';
import 'package:linkpharma/services/auth_services.dart';
import 'package:linkpharma/widgets/showPopup.dart';
import 'package:linkpharma/widgets/txt_widget.dart';

import 'package:remixicon/remixicon.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

List<String> titles = ["Home", "Notifications", "Privacy Policy", "Contact Us"];

List images = [
  "assets/icons/d1.png",

  "assets/icons/d3.png",
  "assets/icons/d4.png",
  "assets/icons/d5.png",
];

class VendorDrawer extends StatefulWidget {
  const VendorDrawer({super.key});

  @override
  State<VendorDrawer> createState() => _VendorDrawerState();
}

class _VendorDrawerState extends State<VendorDrawer> {
  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorDrawerController>(
      init: VendorDrawerController(),
      builder: (VendorDrawerController con) => GestureDetector(
        onTap: () {
          con.closeDrawer();
        },
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: MyColors.primary,
              body: Builder(
                builder: (context) {
                  return Stack(
                    children: [
                      ZoomDrawer(
                        disableDragGesture: true,
                        controller: con.zoomDrawerController,
                        menuScreen: DrawerScreen(
                          setIndex: (index) {
                            setState(() {
                              currentIndex = index;
                              con.open = false;
                            });
                          },
                        ),
                        mainScreen: Builder(
                          builder: (context) {
                            return BottomNavVendor();
                          },
                        ),
                        borderRadius: 30,

                        showShadow: true,
                        angle: -3,
                        slideWidth: 220,
                        shadowLayer1Color: Colors.transparent,
                        shadowLayer2Color: Colors.grey.shade100,

                        menuBackgroundColor: Colors.transparent,
                      ),
                      con.open
                          ? Positioned.fill(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () =>
                                                Get.find<
                                                      VendorDrawerController
                                                    >()
                                                    .closeDrawer(),
                                            child: CircleAvatar(
                                              radius: 2.5.h,
                                              backgroundColor: MyColors.white
                                                  .withOpacity(0.30),
                                              child: Container(
                                                width: 5.2.h,
                                                height: 5.2.h,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Remix.arrow_left_s_line,
                                                  size: 3.0.h,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 1.h),

                                        SizedBox(height: 3.h),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Remix.user_2_line,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2.h),
                                              text_widget(
                                                "Hey, 👋".tr,
                                                color: MyColors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(height: 1.h),
                                              text_widget(
                                                "John Doe".tr,
                                                color: MyColors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      con.open
                          ? Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: SafeArea(
                                  bottom: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Get.find<VendorDrawerController>()
                                                .closeDrawer();
                                            showPopup(
                                              context,
                                              "Logout",
                                              "Are you sure you want to logout?",
                                              "Cancel",
                                              "Logout",
                                              () => Get.back(),
                                              () async {
                                                await AuthServices.I.logOut();
                                                Get.offAll(SelectRolePage());
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 40.0,
                                              vertical: 8,
                                            ),
                                            margin: const EdgeInsets.all(18.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              color: MyColors.white.withOpacity(
                                                0.30,
                                              ),
                                            ),
                                            child: text_widget(
                                              "Sign Out".tr,
                                              color: MyColors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({super.key, required this.setIndex});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorDrawerController>(
      init: VendorDrawerController(),
      builder: (VendorDrawerController con) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 70.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 32.w,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 80),
                            itemCount: titles.length,
                            itemBuilder: (BuildContext context, index) =>
                                InkWell(
                                  onTap: () {
                                    con.closeDrawer();
                                    if (index == 0) {
                                      con.closeDrawer();
                                    }

                                    if (index == 1) {
                                      Get.to(NotificationPage());
                                      con.closeDrawer();
                                    }
                                    if (index == 2) {
                                      Get.to(PrivacyPage());
                                      con.closeDrawer();
                                    }

                                    if (index == 3) {
                                      Get.to(ContactPage());
                                      con.closeDrawer();
                                    }

                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: Container(
                                      height: 4.h,
                                      width: 35.w,
                                      decoration: BoxDecoration(
                                        color: index == 0
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 4.w),
                                          Image.asset(
                                            images[index],
                                            height: 2.h,
                                            color: index == 0
                                                ? MyColors.primary
                                                : Colors.white,
                                          ),

                                          SizedBox(width: 3.w),

                                          Text(
                                            titles[index].tr,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: index == 0
                                                  ? MyColors.primary
                                                  : Colors.white,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Image.asset(
                                            images[index],
                                            height: 2.h,
                                            color: MyColors.primary,
                                          ),
                                        ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VendorDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();
  bool open = false;
  void toggleDrawer() {
    print("Toggle drawer");
    Timer(const Duration(microseconds: 30), () {
      open = true;

      update();
    });
    zoomDrawerController.toggle?.call();
    update();
  }

  int active = 0;

  void closeDrawer() {
    print("Close drawer");
    Timer(const Duration(microseconds: 800), () {
      open = false;

      update();
    });
    zoomDrawerController.close?.call();
    update();
  }
}
