import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:linkpharma/page/auth/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'config/online_status_manager.dart';
import 'controller/chat_controller.dart';
import 'controller/job_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final OnlineStatusManager _statusManager = OnlineStatusManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeOnlineStatus();
  }

  void _initializeOnlineStatus() {
    Future.delayed(Duration(seconds: 1), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _statusManager.startOnlineTracking();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _statusManager.stopOnlineTracking();
    } else if (state == AppLifecycleState.resumed) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _statusManager.startOnlineTracking();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _statusManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(JobController());
    Get.put(ChatController());
    return ResponsiveSizer(
      builder: (BuildContext context, orientation, screenType) {
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
