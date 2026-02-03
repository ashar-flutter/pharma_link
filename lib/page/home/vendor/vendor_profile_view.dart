import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/controller/job_controller.dart';
import 'package:linkpharma/page/home/chat/chat_page.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/user_model.dart';

class VendorProfileView extends StatefulWidget {
  final UserModel user;

  const VendorProfileView({super.key, required this.user});

  @override
  State<VendorProfileView> createState() => _VendorProfileViewState();
}

class _VendorProfileViewState extends State<VendorProfileView> {
  final JobController _controller = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.primary,
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
                        "User Profile",
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 8.5.h,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: widget.user.image.isNotEmpty
                              ? CachedNetworkImageProvider(widget.user.image)
                              : null,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      Center(
                        child: text_widget(
                          "${widget.user.firstName} ${widget.user.lastName}",
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Center(
                        child: text_widget(
                          widget.user.email,
                          fontSize: 14.sp,
                          color: Color(0xff1E1E1E).withOpacity(0.40),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    text_widget(
                                      widget.user.role.isNotEmpty
                                          ? widget.user.role
                                          : "Not specified",
                                      fontSize: 15.sp,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                      "Role",
                                      fontSize: 13.4.sp,
                                      color: Color(
                                        0xff1E1E1E,
                                      ).withOpacity(0.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    text_widget(
                                      widget.user.experience.isNotEmpty
                                          ? "${widget.user.experience} Years"
                                          : "Not specified",
                                      fontSize: 15.sp,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                      "Experience",
                                      fontSize: 13.4.sp,
                                      color: Color(
                                        0xff1E1E1E,
                                      ).withOpacity(0.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    text_widget(
                                      widget.user.city.isNotEmpty
                                          ? widget.user.city
                                          : "Not specified",
                                      fontSize: 15.sp,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    text_widget(
                                      "City",
                                      fontSize: 13.4.sp,
                                      color: Color(
                                        0xff1E1E1E,
                                      ).withOpacity(0.40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      widget.user.description.isNotEmpty
                          ? text_widget(
                        widget.user.description,
                        fontSize: 13.4.sp,
                        color: Color(0xff1E1E1E).withOpacity(0.40),
                      )
                          : SizedBox(),
                      SizedBox(height: 6.h),
                      gradientButton(
                        "Download CV",
                        width: Get.width,
                        ontap: () async {
                          _controller.openVendorCV(widget.user.cv);
                        },
                        height: 5.5,
                        isColor: false,
                        txtColor: MyColors.primary,
                        font: 16,
                        clr: MyColors.white,
                      ),
                      SizedBox(height: 2.h),
                      gradientButton(
                        "Message",
                        width: Get.width,
                        ontap: () async {
                          Get.to(() => ChatScreenView(
                            receiverId: widget.user.id,
                            receiverName: "${widget.user.firstName} ${widget.user.lastName}",
                            receiverImage: widget.user.image,
                            receiverRole: widget.user.role.isNotEmpty
                                ? widget.user.role
                                : "Pharmacist",
                          ));
                        },
                        height: 5.5,
                        isColor: true,
                        font: 16,
                        clr: MyColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}