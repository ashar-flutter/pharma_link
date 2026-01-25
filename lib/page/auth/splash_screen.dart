import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:linkpharma/config/global.dart';
import 'package:linkpharma/firebase_options.dart';
import 'package:linkpharma/page/auth/boardin_page.dart';
import 'package:linkpharma/page/home/user_drawer.dart';
import 'package:linkpharma/page/home/vendor/vendor_drawer.dart';
import 'package:linkpharma/services/auth_services.dart';
import 'package:path/path.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      await init();
      if (currentUser.id == "") {
        Get.offAll(() => const BoardingPage());
      } else if (currentUser.userType == 1) {
        Get.offAll(() => const UserDrawer());
      } else {
        Get.offAll(() => const VendorDrawer());
      }
    });
  }

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AuthServices.I.checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/splahs.png',
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
