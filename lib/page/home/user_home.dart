import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/bottom_nav.dart';
import 'package:linkpharma/page/home/user_drawer.dart';
import 'package:linkpharma/page/home/filter_page.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/page/home/search_page.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/job_controller.dart';
import '../../models/job_model.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Map<String, bool> expandedCities = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<JobController>().loadSavedJobs();
      Get.find<JobController>().loadJobs();
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Get.find<JobController>().loadMoreJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        onPress(
                          ontap: () {
                            Get.find<UserDrawerController>().toggleDrawer();
                          },
                          child: Image.asset(
                            "assets/images/as25.png",
                            height: 4.h,
                          ),
                        ),
                        Spacer(),
                        onPress(
                          ontap: () {
                            Get.to(NotificationPage());
                          },
                          child: Image.asset(
                            "assets/images/as15.png",
                            height: 2.7.h,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        onPress(
                          ontap: () {
                            Get.find<NavControllerD>().selectedIndex = 3;
                            Get.find<NavControllerD>().update();
                          },
                          child: currentUser.image.isNotEmpty
                              ? CircleAvatar(
                            radius: 2.h,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: currentUser.image,
                                height: 4.h,
                                width: 4.h,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircleAvatar(
                                      radius: 2.h,
                                      backgroundColor: Colors.white,
                                    ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                      radius: 2.h,
                                      backgroundColor: Colors.white,
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
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: onPress(
                            ontap: () {
                              Get.to(SearchPage());
                            },
                            child: Container(
                              height: 5.h,
                              width: 70.w,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(50, 255, 255, 255),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 14.sp,
                                ),
                                cursorColor: Color(0xffFFFFFF),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  hintText: "Search text here...",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: Color(0xffFFFFFF),
                                  ),
                                  enabled: false,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 2.w),
                                    child: Image.asset(
                                      "assets/images/as74.png",
                                      height: 2.h,
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints(
                                    minHeight: 2.h,
                                    minWidth: 2.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        onPress(
                          ontap: () {
                            Get.to(FilterPage());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 5.h,
                            width: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Color(0xffFFFFFF),
                            ),
                            child: Image.asset(
                              "assets/images/as18.png",
                              height: 1.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: GetBuilder<JobController>(
                    builder: (controller) {
                      if (controller.allJobs.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<String> cities = controller.getCitiesWithJobs();

                      if (cities.isEmpty && !controller.isLoadingMore) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No jobs available at the moment",
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xff1E1E1E),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              if (controller.hasMoreJobs)
                                CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 4.h),
                            ...cities.map((city) {
                              List<JobModel> cityJobs = controller.getJobsByCity(city);

                              if (cityJobs.isEmpty) return SizedBox();

                              bool isExpanded = expandedCities[city] ?? false;
                              List<JobModel> jobsToShow =
                              isExpanded || cityJobs.length <= 3
                                  ? cityJobs
                                  : cityJobs.sublist(0, 3);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 3.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            city,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xff1E1E1E),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          if (cityJobs.length > 3)
                                            onPress(
                                              ontap: () {
                                                setState(() {
                                                  expandedCities[city] = !isExpanded;
                                                });
                                              },
                                              child: Text(
                                                isExpanded ? "Show Less" : "See All",
                                                style: GoogleFonts.plusJakartaSans(
                                                  decoration: TextDecoration.underline,
                                                  color: const Color(0xff10B66D),
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: jobsToShow.map((job) {
                                          return onPress(
                                            ontap: () {
                                              Get.to(PharmaceyDetail(job: job));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 18,
                                                right: jobsToShow.indexOf(job) == jobsToShow.length - 1 ? 18 : 0,
                                              ),
                                              child: Container(
                                                width: 40.w,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffF6F6F6),
                                                  borderRadius: BorderRadius.circular(18),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius.vertical(
                                                        top: Radius.circular(18),
                                                      ),
                                                      child: Container(
                                                        width: 40.w,
                                                        height: 14.h,
                                                        color: Colors.grey[200],
                                                        child: job.vendorImage.isNotEmpty
                                                            ? CachedNetworkImage(
                                                          imageUrl: job.vendorImage,
                                                          width: 40.w,
                                                          height: 14.h,
                                                          fit: BoxFit.cover,
                                                        )
                                                            : null,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6,
                                                      ),
                                                      child: Text(
                                                        job.vendorName,
                                                        style: GoogleFonts.plusJakartaSans(
                                                          color: const Color(0xff1E1E1E),
                                                          fontSize: 14.5.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                      ),
                                                      child: Text(
                                                        "${job.title} - ${job.contractType}",
                                                        style: GoogleFonts.plusJakartaSans(
                                                          color: const Color.fromARGB(110, 30, 30, 30),
                                                          fontSize: 13.sp,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 1.h),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            if (controller.hasMoreJobs)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: controller.isLoadingMore
                                      ? CircularProgressIndicator()
                                      : Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Loading more jobs...",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xff1E1E1E),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(height: 4.h),
                          ],
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
    );
  }
}