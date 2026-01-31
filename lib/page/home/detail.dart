import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/controller/job_controller.dart';
import 'package:linkpharma/models/job_model.dart';
import 'package:linkpharma/page/home/pharmaceydetail.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/user_model.dart';

class DetailPage extends StatefulWidget {
  final JobModel job;

  const DetailPage({super.key, required this.job});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _pageController = PageController();
  final JobController jobController = Get.find<JobController>();
  List<String> pharmacyImages = [];
  bool isLoading = true;
  Map<String, dynamic>? applicationData;
  bool canWithdraw = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      UserModel? vendorData = await jobController.getVendorData(widget.job.vendorId);
      if (vendorData.images.isNotEmpty == true) {
        pharmacyImages = vendorData.images;
      } else if (widget.job.vendorImage.isNotEmpty) {
        pharmacyImages = [widget.job.vendorImage];
      }

      applicationData = jobController.getApplicationForJob(widget.job.id);
      canWithdraw = jobController.canWithdrawApplication(widget.job.id);
    } catch (e) {
      if (kDebugMode) print("Error loading detail data: $e");
    }

    setState(() => isLoading = false);
  }

  void _showWithdrawDialog() {
    if (!canWithdraw) return;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to withdraw your application?",
                style: GoogleFonts.plusJakartaSans(
                  color: Color(0xff1E1E1E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: onPress(
                      ontap: () => Get.back(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 4.5.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xff10B66D)),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xff10B66D),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: onPress(
                      ontap: () {
                        Get.back();
                        if (applicationData != null && applicationData!['id'] != null) {
                          jobController.withdrawApplication(
                            applicationData!['id'],
                            widget.job.id,
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 4.5.h,
                        decoration: BoxDecoration(
                          color: Color(0xff10B66D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Withdraw",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getApplicationStatusText(String status) {
    switch (status) {
      case 'pending': return 'Under Review';
      case 'withdrawn': return 'Withdrawn';
      case 'rejected': return 'Rejected';
      case 'accepted': return 'Accepted';
      case 'interview': return 'Interview Scheduled';
      default: return 'Pending';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Color(0xffFFA500);
      case 'withdrawn': return Colors.grey;
      case 'rejected': return Color(0xffFF0000);
      case 'accepted': return Color(0xff10B66D);
      case 'interview': return Color(0xff2196F3);
      default: return Color(0xffFFA500);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xff10B66D),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    String pharmacyName = widget.job.vendorName;
    String pharmacyAddress = widget.job.vendorAddress.isNotEmpty
        ? "${widget.job.vendorAddress} - ${widget.job.vendorCity}"
        : widget.job.vendorCity;

    bool hasImages = pharmacyImages.isNotEmpty;
    bool multipleImages = pharmacyImages.length > 1;

    DateTime? appliedDate;
    String appliedDateStr = "";
    String appliedTimeStr = "";
    String appliedMessage = "";
    String applicationStatus = "pending";
    String statusText = "Under Review";
    Color statusColor = Color(0xffFFA500);

    if (applicationData != null) {
      appliedDate = DateTime.parse(applicationData!['appliedAt']);
      appliedDateStr = "${appliedDate.day} ${_getMonthName(appliedDate.month)} ${appliedDate.year}";
      appliedTimeStr = "${appliedDate.hour.toString().padLeft(2, '0')}:${appliedDate.minute.toString().padLeft(2, '0')}";
      appliedMessage = applicationData!['message'] ?? "";
      applicationStatus = applicationData!['status'] ?? "pending";
      statusText = _getApplicationStatusText(applicationStatus);
      statusColor = _getStatusColor(applicationStatus);
    }

    return Scaffold(
      backgroundColor: Color(0xff10B66D),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xff10B66D)),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
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
                      "Details",
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 25.5.h,
                          child: hasImages
                              ? PageView.builder(
                            controller: _pageController,
                            itemCount: pharmacyImages.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: pharmacyImages[index],
                                  width: 100.w,
                                  height: 25.5.h,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    width: 100.w,
                                    height: 25.5.h,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[200],
                                    width: 100.w,
                                    height: 25.5.h,
                                  ),
                                ),
                              );
                            },
                          )
                              : Container(
                            height: 25.5.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
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
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pharmacyName,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xff1E1E1E),
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    pharmacyAddress,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color.fromARGB(91, 30, 30, 30),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              onPress(
                                ontap: () => Get.to(PharmaceyDetail(job: widget.job)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 3.h,
                                  width: 25.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xff10B66D),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    "More Detail",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Divider(),
                          SizedBox(height: 1.h),
                          Text(
                            "Job Details",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.all(22),
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Color(0xffF6F6F6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.job.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xff1E1E1E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    if (widget.job.hoursPerWeek.isNotEmpty)
                                      _buildBadge("${widget.job.hoursPerWeek} h"),
                                    if (widget.job.hoursPerWeek.isNotEmpty) SizedBox(width: 2.w),
                                    if (widget.job.contractType.isNotEmpty)
                                      _buildBadge(widget.job.contractType),
                                    if (widget.job.contractType.isNotEmpty) SizedBox(width: 2.w),
                                    _buildBadge(
                                      widget.job.hoursPerWeek.isNotEmpty &&
                                          int.tryParse(widget.job.hoursPerWeek) != null
                                          ? int.parse(widget.job.hoursPerWeek) < 30
                                          ? "Part time"
                                          : "Full time"
                                          : "Full time",
                                      width: 20.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  widget.job.roleDescription,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color.fromARGB(94, 30, 30, 30),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Divider(),
                          SizedBox(height: 1.h),
                          Text(
                            "Applied Details",
                            style: GoogleFonts.plusJakartaSans(
                              color: Color(0xff1E1E1E),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          if (applicationData != null) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "$appliedDateStr | $appliedTimeStr",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Color(0xff10B66D),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 2.5.h,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: statusColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              appliedMessage,
                              style: GoogleFonts.plusJakartaSans(
                                color: Color.fromARGB(94, 30, 30, 30),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          SizedBox(height: 3.h),
                          onPress(
                            ontap: canWithdraw ? _showWithdrawDialog : null,
                            child: Container(
                              alignment: Alignment.center,
                              height: 5.5.h,
                              width: 88.w,
                              decoration: BoxDecoration(
                                color: canWithdraw ? Color(0xff10B66D) : Colors.grey,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                canWithdraw ? "Withdraw Application" : statusText,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, {double? width}) {
    return Container(
      alignment: Alignment.center,
      height: 2.5.h,
      width: width ?? 13.w,
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