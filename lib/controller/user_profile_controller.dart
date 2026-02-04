import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/config/supportFunctions.dart';
import 'package:linkpharma/services/firestorage_services.dart';
import 'package:linkpharma/services/firestore_services.dart';
import 'package:linkpharma/services/loadingService.dart';

import '../models/user_model.dart';

class UserProfileController extends GetxController {
  // users
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // vendor
  TextEditingController vendorFirstNameController = TextEditingController();
  TextEditingController vendorLastNameController = TextEditingController();
  TextEditingController vendorEmailController = TextEditingController();
  TextEditingController vendorCityController = TextEditingController();

  // COMMON VARIABLES
  String? selectedCountry;
  File? profileImage;
  File? cvFile;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    if (currentUser.userType == 1) {
      firstNameController.text = currentUser.firstName;
      lastNameController.text = currentUser.lastName;
      emailController.text = currentUser.email;
      cityController.text = currentUser.city;
      experienceController.text = currentUser.experience;
      descriptionController.text = currentUser.description;

      final List<String> availableRoles = [
        "Part Time",
        "Full Time",
        "Replacement",
        "Internship",
        "Owner",
        "Doctor",
        "Pharmacist",
      ];

      if (availableRoles.contains(currentUser.role)) {
        selectedCountry = currentUser.role;
      } else {
        selectedCountry = "Part Time";
      }
    } else if (currentUser.userType == 2) {
      if (currentUser.owners.isNotEmpty) {
        vendorFirstNameController.text =
            currentUser.owners[0]['name']?.toString() ?? "";
        vendorLastNameController.text =
            currentUser.owners[0]['sureName']?.toString() ?? "";
      }
      vendorEmailController.text = currentUser.email;
      vendorCityController.text = currentUser.city;
    }
  }

  Future<void> selectImage(BuildContext context) async {
    profileImage = await SupportFunctions.I.getImage(
      context: context,
      isCircleCrop: true,
    );
    update();
  }

  Future<void> selectCV(BuildContext context) async {
    cvFile = await SupportFunctions.I.getFile(context: context);
    update();
  }

  Future<void> downloadCV() async {
    if (currentUser.cv.isEmpty) {
      EasyLoading.showInfo("No CV available");
      return;
    }

    try {
      EasyLoading.show(status: "Opening CV...");

      await Clipboard.setData(ClipboardData(text: currentUser.cv));

      EasyLoading.showSuccess(
        "CV link copied to clipboard!\nPaste in browser to download.",
      );

      Get.defaultDialog(
        title: "CV Download",
        content: Column(
          children: [
            Text("CV link copied to clipboard"),
            SizedBox(height: 10),
            Text("Paste in browser to download"),
            SizedBox(height: 10),
            SelectableText(
              currentUser.cv,
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: Text("OK"))],
      );
    } catch (e) {
      EasyLoading.showError("Failed to copy CV link");
      EasyLoading.dismiss();
    }
  }

  // USER PROFILE UPDATE FUNCTION
  Future<void> updateProfile(BuildContext context) async {
    if (firstNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter first name");
      return;
    }
    if (lastNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter last name");
      return;
    }
    if (!emailController.text.isEmail) {
      EasyLoading.showInfo("Please enter valid email");
      return;
    }
    if (cityController.text.isEmpty) {
      EasyLoading.showInfo("Please enter city");
      return;
    }
    if (selectedCountry == null || selectedCountry!.isEmpty) {
      EasyLoading.showInfo("Please select role");
      return;
    }
    if (experienceController.text.isEmpty) {
      EasyLoading.showInfo("Please enter experience");
      return;
    }
    if (descriptionController.text.isEmpty) {
      EasyLoading.showInfo("Please enter description");
      return;
    }

    LoadingService.I.show(context);

    if (profileImage != null) {
      currentUser.image = await FirestorageServices.I.uploadImage(
        profileImage!,
        "profiles",
      );
    }

    if (cvFile != null) {
      currentUser.cv = await FirestorageServices.I.uploadFile(cvFile!, "cvs");
    }

    currentUser.firstName = firstNameController.text;
    currentUser.lastName = lastNameController.text;
    currentUser.email = emailController.text;
    currentUser.city = cityController.text;
    currentUser.role = selectedCountry!;
    currentUser.experience = experienceController.text;
    currentUser.description = descriptionController.text;

    await FirestoreServices.I.addUser(currentUser);

    LoadingService.I.dismiss();
    EasyLoading.showSuccess("Profile updated successfully!");
    Get.back();
  }

  // VENDOR PROFILE UPDATE FUNCTION
  Future<void> updateVendorProfile(BuildContext context) async {
    if (vendorFirstNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter first name");
      return;
    }
    if (vendorLastNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter last name");
      return;
    }
    if (!vendorEmailController.text.isEmail) {
      EasyLoading.showInfo("Please enter valid email");
      return;
    }
    if (vendorCityController.text.isEmpty) {
      EasyLoading.showInfo("Please enter city");
      return;
    }

    LoadingService.I.show(context);

    String? uploadedImageUrl;
    if (profileImage != null) {
      uploadedImageUrl = await FirestorageServices.I.uploadImage(
        profileImage!,
        "owners",
      );
    }

    currentUser.email = vendorEmailController.text;
    currentUser.city = vendorCityController.text;

    if (currentUser.owners.isNotEmpty) {
      currentUser.owners[0]['name'] = vendorFirstNameController.text;
      currentUser.owners[0]['sureName'] = vendorLastNameController.text;
      if (uploadedImageUrl != null) {
        currentUser.owners[0]['image'] = uploadedImageUrl;
      }
    } else {
      currentUser.owners.add({
        'name': vendorFirstNameController.text,
        'sureName': vendorLastNameController.text,
        'image': uploadedImageUrl ?? "",
      });
    }

    await FirestoreServices.I.addUser(currentUser);
    UserModel refreshedUser = await FirestoreServices.I.getUser(currentUser.id);
    currentUser = refreshedUser;

    LoadingService.I.dismiss();
    EasyLoading.showSuccess("Profile updated successfully!");
    update();
    Get.back();
    Get.find<UserProfileController>().update();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cityController.dispose();
    experienceController.dispose();
    descriptionController.dispose();

    vendorFirstNameController.dispose();
    vendorLastNameController.dispose();
    vendorEmailController.dispose();
    vendorCityController.dispose();

    super.onClose();
  }
}
