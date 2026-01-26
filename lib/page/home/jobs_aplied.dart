import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/page/home/detail.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JobsAppliedPage extends StatefulWidget {
  const JobsAppliedPage({super.key});

  @override
  State<JobsAppliedPage> createState() => JobsAppliedPageState();
}

class JobsAppliedPageState extends State<JobsAppliedPage> {
  final List<Job> jobList = [
    Job(
      pharmacyName: "Pharmacie du Centre",
      dateTime: "23 Jun 2025 | 05:00 AM",
      position: "Staff Pharmacist",
      hours: "25 h",
      contractType: "CDI",
      workType: "Part time",
      image: "assets/images/as51.png",
    ),
    Job(
      pharmacyName: "Pharmacie Centrale",
      dateTime: "24 Jun 2025 | 06:00 AM",
      position: "Assistant Pharmacist",
      hours: "30 h",
      contractType: "CDI",
      workType: "Full time",
      image: "assets/images/as51.png",
    ),
    Job(
      pharmacyName: "Pharmacie du Centre",
      dateTime: "23 Jun 2025 | 05:00 AM",
      position: "Staff Pharmacist",
      hours: "25 h",
      contractType: "CDI",
      workType: "Part time",
      image: "assets/images/as51.png",
    ),
    Job(
      pharmacyName: "Pharmacie Centrale",
      dateTime: "24 Jun 2025 | 06:00 AM",
      position: "Assistant Pharmacist",
      hours: "30 h",
      contractType: "CDI",
      workType: "Full time",
      image: "assets/images/as51.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.primary,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Row(
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
              child: ListView.separated(
                padding: EdgeInsets.all(0),
                itemCount: jobList.length,
                separatorBuilder: (_, __) => SizedBox(height: 2.h),
                itemBuilder: (BuildContext context, index) {
                  final job = jobList[index];

                  return onPress(
                    ontap: () {
                      Get.to(DetailPage());
                    },
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
                          Image.asset(job.image, height: 13.h),
                          SizedBox(width: 4.w),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 1,
                              vertical: 9,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.pharmacyName,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xff10B66D),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  job.dateTime,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color.fromARGB(93, 30, 30, 30),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  job.position,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Color(0xff1E1E1E),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    _jobInfoChip(job.hours),
                                    SizedBox(width: 5),
                                    _jobInfoChip(job.contractType),
                                    SizedBox(width: 5),
                                    _jobInfoChip(job.workType),
                                  ],
                                ),
                              ],
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

class Job {
  final String pharmacyName;
  final String dateTime;
  final String position;
  final String hours;
  final String contractType;
  final String workType;
  final String image;

  Job({
    required this.pharmacyName,
    required this.dateTime,
    required this.position,
    required this.hours,
    required this.contractType,
    required this.workType,
    required this.image,
  });
}
