import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/auth/select_role_page.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key});

  @override
  State<BoardingPage> createState() => _BoardingPageState();
}

class _BoardingPageState extends State<BoardingPage> {
  int currentIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        // 👉 Left swipe
        if (details.primaryVelocity! < 0 && currentIndex < 1) {
          setState(() => currentIndex++);
          pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }

        // 👈 Right swipe
        if (details.primaryVelocity! > 0 && currentIndex > 0) {
          setState(() => currentIndex--);
          pageController.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );

              return FadeTransition(
                opacity: Tween<double>(begin: 0.7, end: 1.0).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.02, end: 1.0).animate(curved),
                  child: child,
                ),
              );
            },
            child: Image.asset(
              currentIndex == 0
                  ? 'assets/images/board.png'
                  : 'assets/images/b2.png',
              key: ValueKey(currentIndex),
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Spacer(),
                Stack(
                  children: [
                    Container(),
                    Center(
                      child: Image.asset(
                        "assets/icons/shape.png",
                        height: 38.h,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        child: Column(
                          children: [
                            Spacer(),
                            SizedBox(
                              height: 17.h,
                              width: 80.w,
                              child: PageView(
                                controller: pageController,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentIndex = value;
                                  });
                                },
                                children: [
                                  ...List.generate(2, (index) {
                                    return Column(
                                      children: [
                                        text_widget(
                                          "Hire or Get Hired\nwith Ease",
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 2.h),
                                        text_widget(
                                          "Pharmacies can post jobs in minutes, and\nprofessionals can apply instantly with a\nsingle tap.",
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(
                                            0xff1E1E1E,
                                          ).withOpacity(0.40),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.5.h),
                            Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: currentIndex.round().clamp(
                                  0,
                                  7 - 1,
                                ),
                                count: 2,
                                effect: WormEffect(
                                  activeDotColor: MyColors.primary,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  dotColor: MyColors.primary.withOpacity(0.6),
                                  spacing: 6,
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: onPress(
                          ontap: () {
                            Get.to(SelectRolePage());
                          },
                          child: CircleAvatar(
                            radius: 3.5.h,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 3.2.h,
                              color: MyColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
