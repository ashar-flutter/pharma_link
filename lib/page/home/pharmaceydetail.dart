import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/popup.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/job_controller.dart';
import '../../models/job_model.dart';
import '../../models/user_model.dart';

class PharmaceyDetail extends StatefulWidget {
  final JobModel job;

  const PharmaceyDetail({super.key, required this.job});

  @override
  State<PharmaceyDetail> createState() => _PharmaceyDetailState();
}

class _PharmaceyDetailState extends State<PharmaceyDetail> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();
  final JobController jobController = Get.find<JobController>();
  UserModel? vendorData;
  bool isLoading = true;

  final List<String> jobTypes = [
    "All Jobs",
    "CDI",
    "CDD",
    "Freelance",
    "Internship",
  ];

  @override
  void initState() {
    super.initState();
    loadVendorData();
  }

  Future<void> loadVendorData() async {
    setState(() => isLoading = true);
    vendorData = await jobController.getVendorData(widget.job.vendorId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(MyColors.primary),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Loading...",
                style: GoogleFonts.plusJakartaSans(
                  color: Color(0xff1E1E1E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<JobModel> vendorJobs = jobController.getJobsForVendor(
      widget.job.vendorId,
    );

    List<JobModel> filteredJobs = selectedIndex == 0
        ? vendorJobs
        : jobController.getJobsByType(
            jobTypes[selectedIndex],
            widget.job.vendorId,
          );

    List<String> pharmacyImages = vendorData?.images.isNotEmpty == true
        ? vendorData!.images
        : widget.job.vendorImage.isNotEmpty
        ? [widget.job.vendorImage]
        : [];

    bool hasImages = pharmacyImages.isNotEmpty;
    bool multipleImages = pharmacyImages.length > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 30.h,
                    child: hasImages
                        ? PageView.builder(
                            controller: _pageController,
                            itemCount: pharmacyImages.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: pharmacyImages[index],
                                  width: 100.w,
                                  height: 30.h,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    width: 100.w,
                                    height: 30.h,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[200],
                                        width: 100.w,
                                        height: 30.h,
                                      ),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                          ),
                  ),
                  if (hasImages && multipleImages)
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: pharmacyImages.length,
                        effect: ScrollingDotsEffect(
                          activeDotColor: Color(0xff10B66D),
                          dotColor: Colors.white,
                          dotHeight: 6,
                          dotWidth: 6,
                          fixedCenter: true,
                        ),
                      ),
                    ),
                ],
              ),
              Positioned.fill(
                left: 5.w,
                right: 5.w,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        onPress(
                          ontap: () => Get.back(),
                          child: Image.asset(
                            "assets/images/back.png",
                            height: 4.h,
                          ),
                        ),
                        Spacer(),
                        onPress(
                          ontap: () {
                            Get.find<JobController>().toggleJobSaveStatus(widget.job);
                          },
                          child: CircleAvatar(
                            radius: 2.h,
                            backgroundColor: Color(0xffFFFFFF),
                            child: GetBuilder<JobController>(
                              builder: (controller) {
                                bool isSaved = controller.isJobCurrentlySaved(widget.job.id);
                                return Icon(
                                  isSaved ? Icons.favorite : Remix.heart_line,
                                  color: isSaved ? Color(0xff10B66D): MyColors.primary,
                                );
                              },
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
          SizedBox(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    vendorData?.firstName ?? widget.job.vendorName,
                    style: GoogleFonts.plusJakartaSans(
                      color: Color(0xff1E1E1E),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${vendorData?.address ?? widget.job.vendorAddress} - ${vendorData?.city ?? widget.job.vendorCity}",
                    style: GoogleFonts.plusJakartaSans(
                      color: Color.fromARGB(79, 30, 30, 30),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (vendorData?.owners.isNotEmpty == true) ...[
                    SizedBox(height: 4.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 2.h,
                      alignment: WrapAlignment.center,
                      children: vendorData!.owners.map((owner) {
                        return Container(
                          height: 13.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6.h,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child:
                                    (owner['image'] as String?)?.isNotEmpty ==
                                        true
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                          imageUrl: owner['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${owner['name'] ?? ''} ${owner['sureName'] ?? ''}",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color(0xff1E1E1E),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        Divider(),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Image.asset("assets/images/as36.png", height: 3.h),
                            SizedBox(width: 2.w),
                            Text(
                              "Hours:",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xff1E1E1E),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.job.hoursPerWeek.isNotEmpty
                                    ? "${widget.job.hoursPerWeek} hours/week"
                                    : "",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color.fromARGB(97, 30, 30, 30),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/as38.png", height: 3.h),
                            SizedBox(width: 2.w),
                            Text(
                              "Services:",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xff1E1E1E),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                vendorData?.services.isNotEmpty == true
                                    ? vendorData!.services.join(" - ")
                                    : "",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color.fromARGB(97, 30, 30, 30),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 2.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Available Jobs",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(jobTypes.length, (index) {
                              final bool isSelected = selectedIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () =>
                                      setState(() => selectedIndex = index),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    alignment: Alignment.center,
                                    height: 3.5.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(0xff10B66D)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? Color(0xff10B66D)
                                            : Color.fromARGB(112, 30, 30, 30),
                                      ),
                                    ),
                                    child: Text(
                                      jobTypes[index],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Color.fromARGB(98, 30, 30, 30),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        GetBuilder<JobController>(
                          builder: (controller) {
                            if (filteredJobs.isEmpty) return SizedBox();

                            return Column(
                              children: filteredJobs.map((job) {
                                bool hasApplied = controller.hasUserApplied(
                                  job.id,
                                );

                                return Container(
                                  margin: EdgeInsets.only(bottom: 2.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 22,
                                  ),
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF6F6F6),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              job.title,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: Color(0xff1E1E1E),
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          onPress(
                                            ontap: hasApplied
                                                ? null
                                                : () => showApplyDialog(
                                                    context,
                                                    job,
                                                  ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 3.h,
                                              width: 23.w,
                                              decoration: BoxDecoration(
                                                color: hasApplied
                                                    ? Colors.grey
                                                    : Color(0xff10B66D),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: Text(
                                                hasApplied
                                                    ? "Applied"
                                                    : "Apply",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        children: [
                                          if (job.hoursPerWeek.isNotEmpty)
                                            Container(
                                              alignment: Alignment.center,
                                              height: 2.5.h,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                  67,
                                                  16,
                                                  182,
                                                  110,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: Text(
                                                "${job.hoursPerWeek} h",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: Color(0xff10B66D),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          if (job.hoursPerWeek.isNotEmpty)
                                            SizedBox(width: 1.w),
                                          if (job.contractType.isNotEmpty)
                                            Container(
                                              alignment: Alignment.center,
                                              height: 2.5.h,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                  67,
                                                  16,
                                                  182,
                                                  110,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: Text(
                                                job.contractType,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: Color(0xff10B66D),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          if (job.contractType.isNotEmpty)
                                            SizedBox(width: 1.w),
                                          Container(
                                            alignment: Alignment.center,
                                            height: 2.5.h,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                67,
                                                16,
                                                182,
                                                110,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Text(
                                              "Job",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
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
                                        job.roleDescription,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Color.fromARGB(94, 30, 30, 30),
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
