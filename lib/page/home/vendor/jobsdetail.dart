import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/controller/job_controller.dart';
import 'package:linkpharma/page/home/vendor/vendor_profile_view.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../chat/chat_page.dart';

class VendorJobsDetailPage extends StatefulWidget {
  final String jobId;

  const VendorJobsDetailPage({super.key, required this.jobId});

  @override
  State<VendorJobsDetailPage> createState() => _VendorJobsDetailPageState();
}

class _VendorJobsDetailPageState extends State<VendorJobsDetailPage> {
  @override
  void initState() {
    super.initState();
    Get.find<JobController>().loadVendorJob(widget.jobId);
  }

  @override
  void dispose() {
    final controller = Get.find<JobController>();
    controller.vendorJob = null;
    controller.vendorApplications.clear();
    controller.vendorSearchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff10B66D),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff10B66D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      onPress(
                        ontap: () => Get.back(),
                        child: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                      ),
                      Spacer(),
                      text_widget(
                        "Job Details",
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                      Spacer(),
                      SizedBox(width: 3.5.h),
                    ],
                  ),
                ),
              ),
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
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 22,
                          ),
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: GetBuilder<JobController>(
                            id: 'job_data',
                            builder: (controller) {
                              final currentJob = controller.vendorJob;
                              if (currentJob == null) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          currentJob.title,
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Color(0xff1E1E1E),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 3.h,
                                        width: 23.w,
                                        decoration: BoxDecoration(
                                          color: currentJob.isActive
                                              ? Color(0xff10B66D)
                                              : Color(0xff1E1E1E),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: Text(
                                          currentJob.isActive
                                              ? "Active"
                                              : "Inactive",
                                          style: GoogleFonts.plusJakartaSans(
                                            color: Color(0xffFFFFFF),
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
                                      if (currentJob.hoursPerWeek.isNotEmpty)
                                        Container(
                                          alignment: Alignment.center,
                                          height: 2.5.h,
                                          width: 13.w,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              67,
                                              16,
                                              182,
                                              110,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          child: Text(
                                            "${currentJob.hoursPerWeek} h",
                                            style: GoogleFonts.plusJakartaSans(
                                              color: Color(0xff10B66D),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      if (currentJob.hoursPerWeek.isNotEmpty)
                                        SizedBox(width: 1.w),
                                      if (currentJob.contractType.isNotEmpty)
                                        Container(
                                          alignment: Alignment.center,
                                          height: 2.5.h,
                                          width: 13.w,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              67,
                                              16,
                                              182,
                                              110,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          child: Text(
                                            currentJob.contractType,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: Color(0xff10B66D),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    currentJob.roleDescription,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color.fromARGB(94, 30, 30, 30),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 3.h),

                        GetBuilder<JobController>(
                          id: 'job_toggle',
                          builder: (controller) {
                            final currentJob = controller.vendorJob;
                            if (currentJob == null) return SizedBox();
                            return onPress(
                              ontap: () => controller.toggleVendorJob(),
                              child: Container(
                                alignment: Alignment.center,
                                height: 5.5.h,
                                width: 88.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff10B66D),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  currentJob.isActive
                                      ? "Deactivate Job"
                                      : "Activate Job",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 1.h),
                        Divider(),
                        SizedBox(height: 2.h),

                        GetBuilder<JobController>(
                          id: 'candidates_data',
                          builder: (controller) {
                            final currentCandidates = controller
                                .searchVendorCandidates(
                                  controller.vendorSearchController.text,
                                );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Candidates",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xff1E1E1E),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 1.h),

                                Container(
                                  height: 6.h,
                                  width: 90.w,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF6F6F6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/as73.png",
                                        height: 2.5.h,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller.vendorSearchController,
                                          onChanged: (value) => controller
                                              .update(['candidates_data']),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Search candidates...",
                                            hintStyle:
                                                GoogleFonts.plusJakartaSans(
                                                  color: Colors.grey,
                                                  fontSize: 14.sp,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                if (currentCandidates.isEmpty)
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                      ),
                                      child: Text(
                                        controller
                                                .vendorSearchController
                                                .text
                                                .isEmpty
                                            ? "No applications yet"
                                            : "No candidates found",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.grey,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Column(
                                    children: currentCandidates.map((app) {
                                      final user = app['user'];
                                      final data = app['appData'];

                                      return Container(
                                        height: 24.h,
                                        width: 88.w,
                                        margin: EdgeInsets.only(bottom: 2.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.5.w,
                                          vertical: 1.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(
                                              102,
                                              30,
                                              30,
                                              30,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                onPress(
                                                  ontap: () => Get.to(
                                                    () => VendorProfileView(user: user),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 2.5.h,
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    backgroundImage:
                                                        user.image.isNotEmpty
                                                        ? CachedNetworkImageProvider(
                                                            user.image,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                                SizedBox(width: 3.w),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${user.firstName} ${user.lastName}",
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            color: Color(
                                                              0xff1E1E1E,
                                                            ),
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    Text(
                                                      "${user.experience} Years Experience",
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            color:
                                                                Color.fromARGB(
                                                                  97,
                                                                  30,
                                                                  30,
                                                                  30,
                                                                ),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              data['message'] ?? "No message",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: Color.fromARGB(
                                                      97,
                                                      30,
                                                      30,
                                                      30,
                                                    ),
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(height: 2.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                onPress(
                                                  ontap: () => controller
                                                      .openVendorCV(user.cv),
                                                  child: Container(
                                                    height: 3.6.h,
                                                    width: 25.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1E1E1E),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            22,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "Download CV",
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            color: Color(
                                                              0xffFFFFFF,
                                                            ),
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4.w),
                                                onPress(
                                                  ontap: () => Get.to(() => ChatScreenView(
                                                    receiverId: user.id,
                                                    receiverName: "${user.firstName} ${user.lastName}",
                                                    receiverImage: user.image,
                                                    receiverRole: "Pharmacist",
                                                  )),
                                                  child: Container(
                                                    height: 3.6.h,
                                                    width: 25.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff10B66D),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            22,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "Chat",
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            color: Color(
                                                              0xffFFFFFF,
                                                            ),
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
