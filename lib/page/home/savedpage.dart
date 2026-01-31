import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/controller/job_controller.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<JobController>().loadSavedJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff10B66D),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xff10B66D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
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
                        "Saved",
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
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: GetBuilder<JobController>(
                builder: (controller) {
                  if (controller.isLoadingSavedJobs) {
                    return Center(
                      child: CircularProgressIndicator(color: MyColors.primary),
                    );
                  }

                  if (controller.savedJobs.isEmpty) {
                    return Center(
                      child: Text(
                        "No saved jobs",
                        style: GoogleFonts.plusJakartaSans(
                          color: Color(0xff1E1E1E),
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: controller.savedJobs.length,
                    padding: const EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (BuildContext context, index) {
                      final savedJobData = controller.savedJobs[index];
                      final job = savedJobData['job'];

                      String jobTypesText = job.contractType;
                      if (job.hoursPerWeek.isNotEmpty) {
                        jobTypesText += ", ${job.hoursPerWeek} h/week";
                      }

                      return onPress(
                        ontap: () {
                          Get.to(PharmaceyDetail(job: job));
                        },
                        child: Stack(
                          children: [
                            Container(
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
                                    child: job.vendorImage.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: job.vendorImage,
                                            width: double.infinity,
                                            height: 14.h,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  color: Colors.grey[200],
                                                  width: double.infinity,
                                                  height: 14.h,
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      width: double.infinity,
                                                      height: 14.h,
                                                    ),
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            width: double.infinity,
                                            height: 14.h,
                                            child: Icon(
                                              Icons.business,
                                              color: Colors.grey[400],
                                              size: 30,
                                            ),
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
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      "${job.title} - $jobTypesText",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color.fromARGB(
                                          110,
                                          30,
                                          30,
                                          30,
                                        ),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: onPress(
                                ontap: () {
                                  controller.toggleJobSaveStatus(job);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Color(0xff10B66D),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
