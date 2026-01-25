import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/user_drawer.dart';
import 'package:linkpharma/page/home/filter_page.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/page/home/search_page.dart';
import 'package:linkpharma/page/home/vendor/add-new_job.dart';
import 'package:linkpharma/page/home/vendor/jobsdetail.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VendorJobLists extends StatefulWidget {
  const VendorJobLists({super.key});

  @override
  State<VendorJobLists> createState() => _VendorJobListsState();
}

class _VendorJobListsState extends State<VendorJobLists> {
  int selectedFilter = 0;

  final List<String> filters = ["All Position", "Active", "Inactive"];

  final List<JobModel> allJobs = [
    JobModel(
      title: "Staff Pharmacist",
      isActive: true,
      hours: "25 h",
      contract: "CDI",
      type: "Part time",
      description:
          "We are looking for a dynamic pharmacist with skills in dermocosmetic and vaccination...",
    ),
    JobModel(
      title: "Staff Pharmacist",
      isActive: false,
      hours: "25 h",
      contract: "CDI",
      type: "Part time",
      description:
          "We are looking for a dynamic pharmacist with skills in dermocosmetic and vaccination...",
    ),
  ];

  List<JobModel> get filteredJobs {
    if (selectedFilter == 1) {
      return allJobs.where((e) => e.isActive).toList();
    } else if (selectedFilter == 2) {
      return allJobs.where((e) => !e.isActive).toList();
    }
    return allJobs;
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: SafeArea(
        bottom: false,
        child: Container(
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
                            Get.find<VendorDrawerController>().toggleDrawer();
                          },
                          child: Image.asset(
                            "assets/images/as25.png",
                            height: 4.5.h,
                          ),
                        ),
                        SizedBox(width: 3.w),

                        Image.asset(
                          "assets/images/as15.png",
                          height: 3.h,
                          color: Colors.transparent,
                        ),
                        Spacer(),
                        text_widget(
                          "All Jobs",
                          color: Colors.white,
                          fontSize: 21.sp,
                        ),
                        Spacer(),

                        onPress(
                          ontap: () {
                            Get.to(NotificationPage());
                          },
                          child: Image.asset(
                            "assets/images/as15.png",
                            height: 3.h,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Image.asset("assets/images/as11.png", height: 4.h),
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(filters.length, (index) {
                              final isSelected = selectedFilter == index;

                              return Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFilter = index;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 3.7.h,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(0xff1E1E1E)
                                          : Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      filters[index],
                                      style: GoogleFonts.plusJakartaSans(
                                        color: isSelected
                                            ? Colors.white
                                            : Color.fromARGB(112, 30, 30, 30),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: 3.h),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              return JobCard(job: filteredJobs[index]);
                            },
                          ),

                          // SizedBox(height: 2.h),
                          Center(
                            child: SizedBox(
                              width: 88.w,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff10B66D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Get.to(AddNewJob());
                                },
                                child: Text(
                                  "Add New Job",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}

class JobModel {
  final String title;
  final bool isActive;
  final String hours;
  final String contract;
  final String type;
  final String description;

  JobModel({
    required this.title,
    required this.isActive,
    required this.hours,
    required this.contract,
    required this.type,
    required this.description,
  });
}

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return onPress(
      ontap: () {
        Get.to(VendorJobsDetailPage());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 3.h),
        padding: EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Color(0xffF6F6F6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  job.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  height: 3.h,
                  width: 23.w,
                  decoration: BoxDecoration(
                    color: job.isActive ? Color(0xff10B66D) : Color(0xff1E1E1E),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    job.isActive ? "Active" : "Inactive",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            Row(
              children: [
                _tag(job.hours),
                SizedBox(width: 1.w),
                _tag(job.contract),
                SizedBox(width: 1.w),
                _tag(job.type),
              ],
            ),

            SizedBox(height: 1.h),

            Text(
              job.description,
              style: GoogleFonts.plusJakartaSans(
                color: Color.fromARGB(94, 30, 30, 30),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      alignment: Alignment.center,
      height: 2.5.h,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color.fromARGB(67, 16, 182, 110),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: Color(0xff10B66D),
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
