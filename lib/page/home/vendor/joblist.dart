import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/vendor/add-new_job.dart';
import 'package:linkpharma/page/home/vendor/jobsdetail.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controller/job_controller.dart';

class VendorJobLists extends StatefulWidget {
  const VendorJobLists({super.key});

  @override
  State<VendorJobLists> createState() => _VendorJobListsState();
}

class _VendorJobListsState extends State<VendorJobLists> {
  int selectedFilter = 0;
  final List<String> filters = ["All Position", "Active", "Inactive"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.all(0),
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
                  child: GetBuilder<JobController>(
                    builder: (jobController) {
                      List filteredJobs = [];

                      if (selectedFilter == 0) {
                        filteredJobs = jobController.allJobs;
                      } else if (selectedFilter == 1) {
                        filteredJobs = jobController.activeJobs;
                      } else if (selectedFilter == 2) {
                        filteredJobs = jobController.inactiveJobs;
                      }

                      return SingleChildScrollView(
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
                              if (filteredJobs.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    child: Text(
                                      "No jobs found",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredJobs.length,
                                itemBuilder: (BuildContext context, index) {
                                  return JobCard(job: filteredJobs[index]);
                                },
                              ),
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
                                      style: GoogleFonts.plusJakartaSans(
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

class JobCard extends StatelessWidget {
  final dynamic job;

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
                Expanded(
                  child: Text(
                    job.title ?? "Job Title",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  alignment: Alignment.center,
                  height: 3.h,
                  width: 23.w,
                  decoration: BoxDecoration(
                    color: (job.isActive ?? true) ? Color(0xff10B66D) : Color(0xff1E1E1E),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    (job.isActive ?? true) ? "Active" : "Inactive",
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
                if (job.hoursPerWeek != null && job.hoursPerWeek!.isNotEmpty)
                  _tag("${job.hoursPerWeek} h"),
                if (job.hoursPerWeek != null && job.hoursPerWeek!.isNotEmpty)
                  SizedBox(width: 1.w),
                if (job.contractType != null && job.contractType!.isNotEmpty)
                  _tag(job.contractType),
                if (job.contractType != null && job.contractType!.isNotEmpty)
                  SizedBox(width: 1.w),
                _tag("Job"),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              job.roleDescription ?? "No description available",
              style: GoogleFonts.plusJakartaSans(
                color: Color.fromARGB(94, 30, 30, 30),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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