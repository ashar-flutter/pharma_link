import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/page/auth/login_page.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/page/home/bottom_nav.dart';
import 'package:linkpharma/page/home/contact.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/privacy.dart';
import 'package:linkpharma/page/home/savedpage.dart';
import 'package:linkpharma/services/auth_services.dart';
import 'package:linkpharma/widgets/txt_widget.dart';

import 'package:remixicon/remixicon.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

List<String> titles = [
  "Home",
  "Saved Jobs",
  "Notifications",
  "Privacy Policy",
  "Contact Us",
];

List images = [
  "assets/icons/d1.png",
  "assets/icons/d2.png",
  "assets/icons/d3.png",
  "assets/icons/d4.png",
  "assets/icons/d5.png",
];

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDrawerController>(
      init: UserDrawerController(),
      builder: (UserDrawerController con) => GestureDetector(
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
                      Directionality(
                        textDirection: currentUser.language == 'en'
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                        child: ZoomDrawer(
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
                              return BottomNavUser();
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
                                                Get.find<UserDrawerController>()
                                                    .closeDrawer(),
                                            child: Image.asset(
                                              "assets/images/as24.png",
                                              height: 4.4.h,
                                            ),
                                          ),
                                        ),

                                        // SizedBox(height: 1.h),
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
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                      "assets/images/as6.png",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2.h),
                                              text_widget(
                                                "Hey, 👋".tr,
                                                color: MyColors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(height: 1.h),
                                              text_widget(
                                                "Alisson becker".tr,
                                                color: MyColors.white,
                                                fontWeight: FontWeight.w600,
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
                                            // show dialog to logout
                                            Get.find<UserDrawerController>()
                                                .closeDrawer();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Logout"),
                                                  content: const Text(
                                                    "Are you sure you want to logout?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await AuthServices.I
                                                            .logOut();
                                                        Get.offAll(
                                                          SelectRolePage(),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Logout",
                                                      ),
                                                    ),
                                                  ],
                                                );
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
                                                0.10,
                                              ),
                                            ),
                                            child: text_widget(
                                              "Sign Out".tr,
                                              color: MyColors.white,
                                              fontSize: 14.4.sp,
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
    return GetBuilder<UserDrawerController>(
      init: UserDrawerController(),
      builder: (UserDrawerController con) => Scaffold(
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
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                con.closeDrawer();
                                if (index == 0) {
                                  con.closeDrawer();
                                }

                                if (index == 1) {
                                  Get.to(SavedPage());
                                  con.closeDrawer();
                                }
                                if (index == 2) {
                                  Get.to(NotificationPage());
                                  con.closeDrawer();
                                }

                                if (index == 3) {
                                  Get.to(PrivacyPage());
                                  con.closeDrawer();
                                }
                                if (index == 4) {
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
                                      currentUser.language == 'en'
                                          ? Image.asset(
                                              images[index],
                                              height: 2.h,
                                              color: index == 0
                                                  ? MyColors.primary
                                                  : Colors.white,
                                            )
                                          : SizedBox(),
                                      currentUser.language == 'en'
                                          ? SizedBox(width: 3.w)
                                          : SizedBox(),
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
                                      currentUser.language != 'en'
                                          ? SizedBox(width: 3.w)
                                          : SizedBox(),
                                      currentUser.language != 'en'
                                          ? Image.asset(
                                              images[index],
                                              height: 2.h,
                                              color: MyColors.primary,
                                            )
                                          : SizedBox(),
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

class UserDrawerController extends GetxController {
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
