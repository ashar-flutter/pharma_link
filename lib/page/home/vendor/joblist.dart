import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/notification.dart';
import 'package:linkpharma/page/home/vendor/add-new_job.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../config/global.dart';
import '../../../controller/job_controller.dart';
import '../../../models/job_model.dart';
import 'jobsdetail.dart';

class VendorJobLists extends StatefulWidget {
  const VendorJobLists({super.key});

  @override
  State<VendorJobLists> createState() => _VendorJobListsState();
}

class _VendorJobListsState extends State<VendorJobLists> {
  int selectedFilter = 0;
  final List<String> filters = ["All Position", "Active", "Inactive"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUser.userType == 2) {
        Get.find<JobController>().loadVendorJobs();
      }
    });
  }

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
                        (currentUser.userType == 2 &&
                            currentUser.owners.isNotEmpty &&
                            currentUser.owners[0]['image'] != null &&
                            currentUser.owners[0]['image'].toString().isNotEmpty)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: currentUser.owners[0]['image'].toString(),
                            width: 4.h,
                            height: 4.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        )
                            : (currentUser.image.isNotEmpty)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: currentUser.image,
                            width: 4.h,
                            height: 4.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        )
                            : Container(
                          width: 4.h,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
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
                    builder: (jobController) {
                      if (currentUser.userType != 2) {
                        return Center(child: Text("Access denied"));
                      }

                      List<JobModel> filteredJobs = [];

                      List<JobModel> vendorJobs = jobController.allJobs
                          .where((job) => job.vendorId == currentUser.id)
                          .toList();

                      if (selectedFilter == 0) {
                        filteredJobs = vendorJobs;
                      } else if (selectedFilter == 1) {
                        filteredJobs = vendorJobs
                            .where((job) => job.isActive)
                            .toList();
                      } else if (selectedFilter == 2) {
                        filteredJobs = vendorJobs
                            .where((job) => !job.isActive)
                            .toList();
                      }

                      filteredJobs = filteredJobs
                          .where((job) => job.vendorId == currentUser.id)
                          .toList();

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(filters.length, (
                                  index,
                                ) {
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
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: Text(
                                          filters[index],
                                          style: GoogleFonts.plusJakartaSans(
                                            color: isSelected
                                                ? Colors.white
                                                : Color.fromARGB(
                                                    112,
                                                    30,
                                                    30,
                                                    30,
                                                  ),
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
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
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
                                  final job = filteredJobs[index];
                                  if (job.vendorId != currentUser.id) {
                                    return SizedBox();
                                  }
                                  return JobCard(job: job);
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
    if (currentUser.userType == 2 && job.vendorId != currentUser.id) {
      return SizedBox();
    }

    return onPress(
      ontap: () {
        Get.find<JobController>().clearVendorData();
        Get.to(() => VendorJobsDetailPage(jobId: job.id));
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
                    color: (job.isActive ?? true)
                        ? Color(0xff10B66D)
                        : Color(0xff1E1E1E),
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
