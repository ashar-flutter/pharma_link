import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/controller/user_profile_controller.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfileVendor extends StatefulWidget {
  const EditProfileVendor({super.key});

  @override
  State<EditProfileVendor> createState() => EditProfileVendorState();
}

class EditProfileVendorState extends State<EditProfileVendor> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: UserProfileController(),
      builder: (con) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: MyColors.primary,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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
                                height: 4.h,
                              ),
                            ),
                            Spacer(),
                            text_widget(
                              "Edit Profile",
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
                            SizedBox(height: 2.h),
                            Center(
                              child: Container(
                                height: 15.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: onPress(
                                  ontap: () async {
                                    await con.selectImage(context);
                                  },
                                  child: con.profileImage != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          child: Image.file(
                                            con.profileImage!,
                                            fit: BoxFit.cover,
                                            width: 15.h,
                                            height: 15.h,
                                          ),
                                        )
                                      : (currentUser.userType == 2 &&
                                            currentUser.owners.isNotEmpty &&
                                            currentUser.owners[0]['image'] !=
                                                null &&
                                            currentUser.owners[0]['image']
                                                .toString()
                                                .isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: currentUser
                                                .owners[0]['image']
                                                .toString(),
                                            fit: BoxFit.cover,
                                            width: 15.h,
                                            height: 15.h,
                                            placeholder: (context, url) =>
                                                Container(
                                                  height: 15.h,
                                                  width: 15.h,
                                                  color: Colors.grey[200],
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      height: 15.h,
                                                      width: 15.h,
                                                      color: Colors.grey[200],
                                                    ),
                                          ),
                                        )
                                      : currentUser.image.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: currentUser.image,
                                            fit: BoxFit.cover,
                                            width: 15.h,
                                            height: 15.h,
                                            placeholder: (context, url) =>
                                                Container(
                                                  height: 15.h,
                                                  width: 15.h,
                                                  color: Colors.grey[200],
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      height: 15.h,
                                                      width: 15.h,
                                                      color: Colors.grey[200],
                                                    ),
                                          ),
                                        )
                                      : Container(
                                          height: 15.h,
                                          width: 15.h,
                                          color: Colors.grey[200],
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            text_widget(
                              "First Name",
                              color: Colors.black,
                              fontSize: 13.4.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 0.8.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Write here".tr,
                              prefixIcon: "assets/images/user.png",
                              controller: con.vendorFirstNameController,
                            ),
                            SizedBox(height: 2.h),
                            text_widget(
                              "Last Name",
                              color: Colors.black,
                              fontSize: 13.4.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 0.8.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Write your name".tr,
                              prefixIcon: "assets/images/user.png",
                              controller: con.vendorLastNameController,
                            ),
                            SizedBox(height: 2.h),
                            text_widget(
                              "Email Address",
                              color: Colors.black,
                              fontSize: 13.4.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 0.8.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Write your email".tr,
                              prefixIcon: "assets/icons/s2.png",
                              controller: con.vendorEmailController,
                            ),
                            SizedBox(height: 2.h),
                            text_widget(
                              "City",
                              color: Colors.black,
                              fontSize: 13.4.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 0.8.h),
                            textFieldWithPrefixSuffuxIconAndHintText(
                              "Write your city".tr,
                              controller: con.vendorCityController,
                            ),
                            SizedBox(height: 12.h),
                            gradientButton(
                              "Save",
                              width: Get.width,
                              ontap: () async {
                                await con.updateVendorProfile(context);
                              },
                              height: 5.5,
                              isColor: true,
                              font: 16,
                              clr: MyColors.primary,
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
        );
      },
    );
  }
}
