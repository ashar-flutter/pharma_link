import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/chat/inbox_page.dart';
import 'package:linkpharma/page/home/user_home.dart';
import 'package:linkpharma/page/home/jobs_aplied.dart';
import 'package:linkpharma/page/home/profile_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomNavUser extends StatelessWidget {
  const BottomNavUser({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavControllerD>(
      init: NavControllerD(),
      builder: (con) => Scaffold(
        backgroundColor: Colors.white,

        body: IndexedStack(index: con.selectedIndex, children: con.pages),

        bottomNavigationBar: con.isVisible
            ? Container(
                height: 10.h,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 40,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _navItem(
                      index: 0,
                      icon: "assets/icons/n1.png",
                      label: "Home",
                      con: con,
                    ),
                    _navItem(
                      index: 1,
                      icon: "assets/icons/n2.png",
                      label: "Inbox",
                      con: con,
                    ),
                    _navItem(
                      index: 2,
                      icon: "assets/icons/n3.png",
                      label: "Applied Jobs",
                      con: con,
                    ),
                    _navItem(
                      index: 3,
                      icon: "assets/icons/n4.png",
                      label: "Profile",
                      con: con,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}

Widget _navItem({
  required int index,
  required String icon,
  required String label,
  required NavControllerD con,
}) {
  final bool isSelected = con.selectedIndex == index;

  return InkWell(
    borderRadius: BorderRadius.circular(30),
    onTap: () => con.onItemTapped(index),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 5.h,
          height: 5.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? MyColors.primary : Colors.transparent,
          ),
          child: Center(
            child: Image.asset(
              icon,
              height: 2.3.h,
              color: isSelected
                  ? Colors.white
                  : const Color(0xff1E1E1E).withOpacity(0.40),
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isSelected
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    label.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: MyColors.primary,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    ),
  );
}

class NavControllerD extends GetxController {
  int selectedIndex = 0;
  bool isVisible = true;

  final List<Widget> pages = [
    UserHomePage(),
    InboxPage1(),
    JobsAppliedPage(),
    ProfilePage1(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    update();
  }
}
