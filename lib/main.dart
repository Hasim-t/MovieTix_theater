import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/buisness_logic/auth/auth_getx.dart';
import 'package:theate/buisness_logic/bottom_nav_getx.dart';
import 'package:theate/buisness_logic/seatmanangment_controller.dart';

import 'package:theate/firebase_options.dart';

import 'package:theate/presentation/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(BottomNavController());
  Get.put(TheaterManagementController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
