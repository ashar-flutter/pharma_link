import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/models/user_model.dart';
import 'package:linkpharma/page/auth/signup_user_page.dart';
import 'package:linkpharma/page/home/user_drawer.dart';
import 'package:linkpharma/page/home/vendor/pharmacy_add.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/services/auth_services.dart';
import 'package:linkpharma/services/firestorage_services.dart';
import 'package:linkpharma/services/firestore_services.dart';
import 'package:linkpharma/services/loadingService.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool rememberMe = false;

  // userSide
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController rppsController = TextEditingController();
  File? profileImage, cv;

  // vendorSide
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController siretController = TextEditingController();
  List<Map<String, dynamic>> owners = []; // {id, name, image, surename}
  List<File> images = [];
  List<String> services = [];

  Future<void> loginWithEmail(BuildContext context) async {
    if (!emailController.text.isEmail) {
      EasyLoading.showInfo("Please enter a valid email address");
    }
    if (passwordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a password");
    }
    String error = await AuthServices.I.emailSignIn(
      context,
      emailController.text,
      passwordController.text,
    );
    if (error.isNotEmpty) {
      EasyLoading.showError(error);
      return;
    }
    currentUser = await FirestoreServices.I.getUser(currentUser.id);
    if (!currentUser.enable) {
      EasyLoading.showError("Your account is disabled");
      return;
    }
    LoadingService.I.dismiss();
    if (currentUser.userType == 1) {
      Get.offAll(UserDrawer());
    } else {
      Get.offAll(VendorDrawer());
    }
  }

  Future<void> signUpUserEmail(BuildContext context) async {
    if (profileImage == null) {
      EasyLoading.showInfo("Please select a profile image");
    }
    if (firstNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a first name");
    }
    if (lastNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a last name");
    }
    if (!emailController.text.isEmail) {
      EasyLoading.showInfo("Please enter a valid email");
    }
    if (passwordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a password");
    }
    if (passwordController.text.length < 7) {
      EasyLoading.showInfo("Choose a strong password");
    }
    if (reEnterPasswordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a re-enter password");
    }
    if (passwordController.text != reEnterPasswordController.text) {
      EasyLoading.showInfo("Passwords do not match");
    }
    if (cityController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a city");
    }
    if (roleController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a role");
    }
    if (experienceController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a experience");
    }
    if (rppsController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a rpps");
    }
    if (descriptionController.text.isEmpty) {
      EasyLoading.showInfo("Enter a description about yourself");
    }
    if (cv == null) {
      EasyLoading.showInfo("Please select a cv");
    }
    LoadingService.I.show(context);
    currentUser.image = await FirestorageServices.I.uploadImage(
      profileImage!,
      "profiles",
    );
    currentUser.firstName = firstNameController.text;
    currentUser.lastName = lastNameController.text;
    currentUser.email = emailController.text;
    currentUser.city = cityController.text;
    currentUser.role = roleController.text;
    currentUser.experience = experienceController.text;
    currentUser.rpps = rppsController.text;
    currentUser.description = descriptionController.text;
    currentUser.cv = await FirestorageServices.I.uploadFile(cv!, "cvs");
    String error = await AuthServices.I.emailSignIn(
      context,
      emailController.text,
      passwordController.text,
    );
    if (error.isNotEmpty) {
      EasyLoading.showError(error);
      return;
    }
    await FirestoreServices.I.addUser(currentUser);
    LoadingService.I.dismiss();
    Get.offAll(UserDrawer());
  }

  void page1() {
    if (lastNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a last name");
      return;
    }
    if (addressController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a address");
      return;
    }
    if (zipCodeController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a zip code");
      return;
    }
    if (cityController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a city");
      return;
    }
    if (countryController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a country");
      return;
    }
    if (!emailController.text.isEmail) {
      EasyLoading.showInfo("Please enter a valid email");
      return;
    }
    if (passwordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a password");
      return;
    }
    if (passwordController.text.length < 7) {
      EasyLoading.showInfo("Choose a strong password");
      return;
    }
    if (reEnterPasswordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a re-enter password");
      return;
    }
    if (passwordController.text != reEnterPasswordController.text) {
      EasyLoading.showInfo("Passwords do not match");
      return;
    }
    if (siretController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a siret");
      return;
    }
    if (images.isEmpty) {
      EasyLoading.showInfo("Please add at least one image");
      return;
    }
    if (services.isEmpty) {
      EasyLoading.showInfo("Please add at least one service");
      return;
    }
    if (descriptionController.text.isEmpty) {
      EasyLoading.showInfo("Enter a description about yourself");
      return;
    }
    // Get.toNamed(AppRoutes.page2);;
  }

  void page2() {
    if (images.isEmpty) {
      EasyLoading.showInfo("Please add at least one image");
      return;
    }
    if (descriptionController.text.isEmpty) {
      EasyLoading.showInfo("Enter a description about your pharmacy");
      return;
    }
    if (services.isEmpty) {
      EasyLoading.showInfo("Please add at least one service");
      return;
    }
    // Get.toNamed(AppRoutes.page2);
  }

  void page3(BuildContext context) {
    if (owners.isEmpty) {
      EasyLoading.showInfo("Please add at least one image");
      return;
    }
    signUpVendorEmail(context);
  }

  Future<void> signUpVendorEmail(BuildContext context) async {
    LoadingService.I.show(context);
    currentUser.firstName = firstNameController.text;
    currentUser.address = addressController.text;
    currentUser.zipCode = zipCodeController.text;
    currentUser.city = cityController.text;
    currentUser.country = countryController.text;
    currentUser.email = emailController.text;
    currentUser.siret = siretController.text;
    currentUser.images = await Future.wait(
      images.map(
        (File image) => FirestorageServices.I.uploadImage(image, "pharmacies"),
      ),
    );
    currentUser.description = descriptionController.text;
    currentUser.services = services;
    currentUser.owners = owners;
    String error = await AuthServices.I.emailSignUp(
      context,
      emailController.text,
      passwordController.text,
    );
    if (error.isNotEmpty) {
      EasyLoading.showError(error);
      return;
    }
    await FirestoreServices.I.addUser(currentUser);
    LoadingService.I.dismiss();
    Get.to(PharmacyDetails(isEdit: false));
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    bool check = await AuthServices.I.loginWithGoogle();
    if (currentUser.id == "" || !check) {
      AuthServices.I.logOut();
      return;
    }
    signUp(context);
  }

  Future<void> loginWithApple(BuildContext context) async {
    bool check = await AuthServices.I.loginWithApple();
    if (currentUser.id == "" || !check) {
      AuthServices.I.logOut();
      return;
    }
    signUp(context);
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    bool check = await AuthServices.I.loginWithFacebook();
    if (currentUser.id == "" || !check) {
      AuthServices.I.logOut();
      return;
    }
    signUp(context);
  }

  Future<void> signUp(BuildContext context) async {
    LoadingService.I.show(context);
    UserModel user = await FirestoreServices.I.getUser(currentUser.id);
    LoadingService.I.dismiss();
    if (user.id == "") {
      if (currentUser.userType == 0) {
        Get.to(SignupUserPage());
      } else {
        Get.to(PharmacyDetails(isEdit: false));
      }
    } else {
      currentUser = user;
      if (!currentUser.enable) {
        EasyLoading.showError("Your account is disabled");
        AuthServices.I.logOut();
        return;
      }
      if (currentUser.userType == 0) {
        Get.to(UserDrawer());
      } else {
        Get.to(VendorDrawer());
      }
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (!emailController.text.isEmail) {
      EasyLoading.showInfo("Please enter a valid email");
      return;
    }
    await AuthServices.I.forgetPassword(context, emailController.text);
    Get.back();
  }
}
