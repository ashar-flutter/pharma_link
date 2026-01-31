import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/config/colors.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/page/home/vendor/vendor_nav.dart';
import 'package:linkpharma/services/firestore_services.dart';
import 'package:linkpharma/widgets/ontap.dart';
import 'package:linkpharma/widgets/txt_field.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'bottom_nav.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String get _userType => currentUser.userType == 1 ? 'user' : 'vendor';

  Future<void> _submitContactForm() async {
    debugPrint("SUBMIT CLICKED");
    if (_nameController.text.isEmpty) {
      EasyLoading.showError("Please enter your name");
      return;
    }

    if (_emailController.text.isEmpty) {
      EasyLoading.showError("Please enter your email");
      return;
    }

    if (!_emailController.text.contains('@')) {
      EasyLoading.showError("Please enter a valid email");
      return;
    }

    if (_subjectController.text.isEmpty) {
      EasyLoading.showError("Please enter subject");
      return;
    }

    if (_descriptionController.text.isEmpty) {
      EasyLoading.showError("Please enter description");
      return;
    }

    if (_descriptionController.text.length < 10) {
      EasyLoading.showError("Description should be at least 10 characters");
      return;
    }

    EasyLoading.show(status: "Sending...");

    try {
      bool success = await FirestoreServices.I.submitContactMessage(
        userId: currentUser.id,
        userType: _userType,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (success) {
        EasyLoading.showSuccess("Message sent successfully!");

        if (_userType == 'user') {
          Get.offAll(() => BottomNavUser());
        } else {
          Get.offAll(() => BottomNavVendor());
        }
      } else {
        EasyLoading.showError("Failed to send message");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff10B66D),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff10B66D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.center,
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
                        "Contact Us",
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
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here",
                      controller: _nameController,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Email",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Subject",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here",
                      controller: _subjectController,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Description",
                      style: GoogleFonts.plusJakartaSans(
                        color: Color(0xff1E1E1E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    textFieldWithPrefixSuffuxIconAndHintText(
                      "Write here",
                      controller: _descriptionController,
                      line: 5,
                    ),
                    SizedBox(height: 4.h),
                    contactSendButton(
                      onTap: _submitContactForm,
                    ),

                    SizedBox(height: 4.h),
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


Widget contactSendButton({
  required VoidCallback onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 5.5.h,
      decoration: BoxDecoration(
        color: MyColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        "Send",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}
