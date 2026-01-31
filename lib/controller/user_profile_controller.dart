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

class UserProfileController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedCountry;
  File? profileImage;
  File? cvFile;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
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
      "Pharmacist"
    ];

    if (availableRoles.contains(currentUser.role)) {
      selectedCountry = currentUser.role;
    } else {
      selectedCountry = "Part Time";
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

      EasyLoading.showSuccess("CV link copied to clipboard!\nPaste in browser to download.");

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
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        ],
      );

    } catch (e) {
      EasyLoading.showError("Failed to copy CV link");
      EasyLoading.dismiss();
    }
  }
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
      currentUser.cv = await FirestorageServices.I.uploadFile(
        cvFile!,
        "cvs",
      );
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

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    cityController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}