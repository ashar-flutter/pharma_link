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
import 'package:linkpharma/services/local_storage.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool rememberMe = true;

  // userSide
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController userCountryController = TextEditingController();
  String? role;
  TextEditingController experienceController = TextEditingController();
  TextEditingController rppsController = TextEditingController();
  File? profileImage, cv;

  // Change password
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // vendorSide
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController siretController = TextEditingController();
  List<Map<String, dynamic>> owners = []; // {id, name, image, surename}
  List<dynamic> images = [
    {'type': 'add'},
  ];
  List<String> services = [];
  int selectIndex = 0;
  ScrollController scrollController = ScrollController();

  AuthController() {
    emailController.text = currentUser.email;
    if (currentUser.id.isNotEmpty) {
      firstNameController.text = currentUser.firstName;
      lastNameController.text = currentUser.lastName;
      cityController.text = currentUser.city;
      userCountryController.text = currentUser.country;
      role = currentUser.role;
      experienceController.text = currentUser.experience;
      rppsController.text = currentUser.rpps;
      descriptionController.text = currentUser.description;
    }
  }

  Future<void> loginWithEmail(BuildContext context) async {
    if (!emailController.text.isEmail) {
      EasyLoading.showInfo("Please enter a valid email address");
      return;
    }
    if (passwordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a password");
      return;
    }
    LoadingService.I.show(context);
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
    await LocalStorage.I.setValue(LocalStorageKeys.remeberLogin, rememberMe);
    if (currentUser.userType == 1) {
      Get.offAll(UserDrawer());
    } else {
      Get.offAll(VendorDrawer());
    }
  }

  Future<void> signUpUserEmail(BuildContext context) async {
    if (profileImage == null) {
      EasyLoading.showInfo("Please select a profile image");
      return;
    }
    if (firstNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a first name");
      return;
    }
    if (lastNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a last name");
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
    if (cityController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a city");
      return;
    }
    if (userCountryController.text.trim().isEmpty) {
      // <-- .trim() ADD KARO
      EasyLoading.showInfo("Please enter your country");
      return;
    }
    if (role == null) {
      EasyLoading.showInfo("Select the role");
      return;
    }
    if (experienceController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a experience");
      return;
    }
    if (rppsController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a rpps");
      return;
    }
    if (descriptionController.text.isEmpty) {
      EasyLoading.showInfo("Enter a description about yourself");
      return;
    }
    if (cv == null) {
      EasyLoading.showInfo("Please select a cv");
      return;
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
    currentUser.country = userCountryController.text
        .trim(); // <-- .trim() ADD KARO
    currentUser.role = role!;
    currentUser.experience = experienceController.text;
    currentUser.rpps = rppsController.text;
    currentUser.description = descriptionController.text;
    currentUser.cv = await FirestorageServices.I.uploadFile(cv!, "cvs");

    if (currentUser.id.isEmpty) {
      String error = await AuthServices.I.emailSignUp(
        context,
        emailController.text,
        passwordController.text,
      );
      if (error.isNotEmpty) {
        EasyLoading.showError(error);
        return;
      }
    }
    await FirestoreServices.I.addUser(currentUser);
    await LocalStorage.I.setValue(LocalStorageKeys.remeberLogin, true);
    LoadingService.I.dismiss();
    Get.offAll(UserDrawer());
  }

  void page1() {
    if (firstNameController.text.isEmpty) {
      EasyLoading.showInfo("Please enter a pharmacy name");
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
    if (countryController.text.trim().isEmpty) {
      // <-- .trim() ADD KARO VENDOR KE LIYE BHI
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
    selectIndex = 1;
    update();
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void page2(BuildContext context) {
    if (images.length < 2) {
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
    selectIndex = 2;
    update();
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void page3(BuildContext context) {
    if (owners.isEmpty) {
      EasyLoading.showInfo("Please add at least one image");
      return;
    }
    _signUpVendorEmail(context);
  }

  Future<void> _signUpVendorEmail(BuildContext context) async {
    LoadingService.I.show(context);
    currentUser.firstName = firstNameController.text;
    currentUser.address = addressController.text;
    currentUser.zipCode = zipCodeController.text;
    currentUser.city = cityController.text;
    currentUser.country = countryController.text.trim(); // <-- .trim() ADD KARO
    currentUser.email = emailController.text;
    currentUser.siret = siretController.text;
    currentUser.images = await Future.wait(
      images
          .where((img) => img['type'] == 'image')
          .map(
            (img) => FirestorageServices.I.uploadImage(
              File(img['path']),
              "pharmacies",
            ),
          )
          .toList(),
    );
    currentUser.description = descriptionController.text;
    currentUser.services = services;
    currentUser.owners = owners;
    if (currentUser.id.isEmpty) {
      String error = await AuthServices.I.emailSignUp(
        context,
        emailController.text,
        passwordController.text,
      );
      if (error.isNotEmpty) {
        EasyLoading.showError(error);
        return;
      }
    }
    await LocalStorage.I.setValue(LocalStorageKeys.remeberLogin, true);
    await FirestoreServices.I.addUser(currentUser);
    LoadingService.I.dismiss();
    Get.offAll(VendorDrawer());
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    bool check = await AuthServices.I.loginWithGoogle();
    if (currentUser.id == "" || !check) {
      await AuthServices.I.logOut();
      return;
    }
    signUp(context);
  }

  Future<void> loginWithApple(BuildContext context) async {
    bool check = await AuthServices.I.loginWithApple();
    if (currentUser.id == "" || !check) {
      await AuthServices.I.logOut();
      return;
    }
    signUp(context);
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    bool check = await AuthServices.I.loginWithFacebook();
    if (currentUser.id == "" || !check) {
      await AuthServices.I.logOut();
      return;
    }
    signUp(context);
  }

  Future<void> signUp(BuildContext context) async {
    LoadingService.I.show(context);
    UserModel user = await FirestoreServices.I.getUser(currentUser.id);
    LoadingService.I.dismiss();
    await LocalStorage.I.setValue(LocalStorageKeys.remeberLogin, true);
    if (user.id == "") {
      if (currentUser.userType == 1) {
        Get.to(SignupUserPage());
      } else {
        Get.to(PharmacyAdd(isEdit: false));
      }
    } else {
      currentUser = user;
      if (!currentUser.enable) {
        EasyLoading.showError("Your account is disabled");
        AuthServices.I.logOut();
        return;
      }
      if (currentUser.userType == 1) {
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
    LoadingService.I.show(context);
    await AuthServices.I.forgetPassword(context, emailController.text);
    Get.back();
  }

  // Change password method ...
  Future<void> changePassword(BuildContext context) async {
    if (oldPasswordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter old password");
      return;
    }
    if (newPasswordController.text.isEmpty) {
      EasyLoading.showInfo("Please enter new password");
      return;
    }
    if (newPasswordController.text.length < 6) {
      EasyLoading.showInfo("Password must be at least 6 characters");
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      EasyLoading.showInfo("Please confirm password");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      EasyLoading.showInfo("Passwords do not match");
      return;
    }

    LoadingService.I.show(context);

    String error = await AuthServices.I.updatePassword(
      context,
      oldPasswordController.text,
      newPasswordController.text,
    );

    LoadingService.I.dismiss();

    if (error.isEmpty) {
      EasyLoading.showSuccess("Password updated successfully");
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      Get.back();
    } else {
      EasyLoading.showError(error);
    }
  }

  void addOwner(String name, String surname, String imageUrl) {
    owners.add({'name': name, 'sureName': surname, 'image': imageUrl});
    update();
  }

  void removeOwner(int index) {
    if (owners.isNotEmpty && index < owners.length) {
      owners.removeAt(index);
      update();
    }
  }
}
