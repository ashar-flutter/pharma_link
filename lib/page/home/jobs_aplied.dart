import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/controller/job_controller.dart';
import 'package:linkpharma/page/home/detail.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JobsAppliedPage extends StatefulWidget {
  const JobsAppliedPage({super.key});

  @override
  State<JobsAppliedPage> createState() => JobsAppliedPageState();
}

class JobsAppliedPageState extends State<JobsAppliedPage> {
  final JobController jobController = Get.find<JobController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobController.loadAppliedJobs();
    });
  }

  String _getMonthName(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColors.primary,
          body: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      onPress(
                        ontap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                      ),
                      Spacer(),
                      text_widget(
                        "Applied Jobs",
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                      Spacer(),
                      Image.asset(
                        "assets/images/back.png",
                        height: 3.5.h,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: controller.isLoadingAppliedJobs
                      ? Center(
                          child: CircularProgressIndicator(
                            color: MyColors.primary,
                          ),
                        )
                      : controller.appliedJobs.isEmpty
                      ? Center(
                          child: Text(
                            "No applications yet",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.all(0),
                          itemCount: controller.appliedJobs.length,
                          separatorBuilder: (_, _) => SizedBox(height: 2.h),
                          itemBuilder: (BuildContext context, index) {
                            final applicationData =
                                controller.appliedJobs[index];
                            final application = applicationData['application'];
                            final job = applicationData['job'];

                            final appliedDate = DateTime.parse(
                              application['appliedAt'],
                            );
                            final dateStr =
                                "${appliedDate.day} ${_getMonthName(appliedDate.month)} ${appliedDate.year}";
                            final timeStr =
                                "${appliedDate.hour.toString().padLeft(2, '0')}:${appliedDate.minute.toString().padLeft(2, '0')}";

                            return onPress(
                              ontap: () {
                                Get.to(DetailPage(job: job, jobId: application['jobId']));                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 16.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 13.h,
                                      width: 13.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.grey[200],
                                      ),
                                        child: job.vendorImage.isNotEmpty
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            imageUrl: job.vendorImage,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                        )
                                            : null,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 9,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              job.vendorName,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: Color(0xff10B66D),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            Text(
                                              "$dateStr | $timeStr",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: Color.fromARGB(
                                                      93,
                                                      30,
                                                      30,
                                                      30,
                                                    ),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                            SizedBox(height: 1.h),
                                            Text(
                                              job.title,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: Color(0xff1E1E1E),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            SizedBox(height: 1.h),
                                            Row(
                                              children: [
                                                _jobInfoChip(
                                                  "${job.hoursPerWeek} h",
                                                ),
                                                SizedBox(width: 5),
                                                _jobInfoChip(job.contractType),
                                                SizedBox(width: 5),
                                                _jobInfoChip(
                                                  job.hoursPerWeek.isNotEmpty &&
                                                          int.tryParse(
                                                                job.hoursPerWeek,
                                                              ) !=
                                                              null
                                                      ? int.parse(
                                                                  job.hoursPerWeek,
                                                                ) <
                                                                30
                                                            ? "Part time"
                                                            : "Full time"
                                                      : "Full time",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
        );
      },
    );
  }

  Widget _jobInfoChip(String text) {
    return Container(
      alignment: Alignment.center,
      height: 2.3.h,
      padding: EdgeInsets.symmetric(horizontal: 8),
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
