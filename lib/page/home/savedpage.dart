import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkpharma/widgets/txt_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff10B66D),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xff10B66D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/images/back.png",
                          height: 3.5.h,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      Spacer(),
                      text_widget(
                        "Saved",
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
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: GridView.builder(
                itemCount: 6,
                padding: const EdgeInsets.all(0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,

                  childAspectRatio: 0.85,
                ),
                itemBuilder: (BuildContext context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                              child: Image.asset(
                                "assets/images/as52.png",
                                width: double.infinity,
                                height: 14.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Text(
                                "Pharmacie du Centre",
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xff1E1E1E),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                "Pharmacist-Full Time,\nInternship, Assistant",
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color.fromARGB(110, 30, 30, 30),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Color(0xff10B66D),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
