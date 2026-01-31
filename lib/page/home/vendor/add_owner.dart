import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/page/home/vendor/vendor_home.dart';
import 'package:linkpharma/widgets/custom_button.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:linkpharma/services/firestorage_services.dart';
import 'package:linkpharma/services/firestore_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddOwner extends StatefulWidget {
  const AddOwner({super.key});

  @override
  State<AddOwner> createState() => AddOwnerState();
}

class AddOwnerState extends State<AddOwner> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  File? ownerImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        ownerImage = File(pickedFile.path);
      });
    }
  }

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
                        "Add Owner",
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      height: 15.h,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: onPress(
                        ontap: _pickImage,
                        child: Center(
                          child: ownerImage != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              ownerImage!,
                              height: 15.h,
                              width: 15.h,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Image.asset(
                            "assets/icons/pp.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    text_widget(
                      "Name",
                      color: Colors.black,
                      fontSize: 13.4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 0.8.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here",
                      controller: nameController,
                    ),
                    SizedBox(height: 2.h),
                    text_widget(
                      "Surname",
                      color: Colors.black,
                      fontSize: 13.4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 0.8.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here",
                      controller: surnameController,
                    ),
                    SizedBox(height: 14.h),
                    gradientButton(
                      "Add",
                      width: Get.width,
                      ontap: () async {
                        if (ownerImage == null) {
                          EasyLoading.showInfo("Please select owner image");
                          return;
                        }
                        if (nameController.text.isEmpty) {
                          EasyLoading.showInfo("Please enter owner name");
                          return;
                        }
                        if (surnameController.text.isEmpty) {
                          EasyLoading.showInfo("Please enter owner surname");
                          return;
                        }

                        EasyLoading.show(status: "Adding...");

                        try {
                          String uploadedImageUrl = await FirestorageServices.I
                              .uploadImage(ownerImage!, "owners");

                          Map<String, dynamic> newOwner = {
                            'name': nameController.text,
                            'sureName': surnameController.text,
                            'image': uploadedImageUrl,
                          };

                          Get.find<VendorOwnerController>().addOwnerToList(newOwner);
                          FirestoreServices.I.addUser(currentUser);
                          EasyLoading.dismiss();
                          Get.back();

                        } catch (e) {
                          EasyLoading.showError("Error: $e");
                        }
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
        ],
      ),
    );
  }
}