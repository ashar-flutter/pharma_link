import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:linkpharma/page/auth/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          builder: EasyLoading.init(),
          locale: const Locale('en', 'US'),
          transitionDuration: const Duration(milliseconds: 300),
          theme: ThemeData(
            primaryColor: const Color(0xFFCC8640),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
