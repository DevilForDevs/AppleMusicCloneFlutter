import 'package:apple_music/screens/SetupScreens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'TopLevelController.dart';

void main() {
  Get.put(TopLevelController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apple Music',
      home: const Splashscreen(),
    );
  }
}


