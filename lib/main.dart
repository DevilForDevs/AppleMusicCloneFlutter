import 'package:apple_music/screens/BottomNav/BottomNavScreen.dart';
import 'package:apple_music/screens/SetupScreens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import 'TopLevelController.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();


  final box = GetStorage();
  final isFirstLaunch = box.read('first_launch') ?? true;

  if (isFirstLaunch) {
    box.write('first_launch', false);
  }

  Get.put(TopLevelController(), permanent: true);
  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstLaunch});
  final bool isFirstLaunch;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apple Music',
      home:isFirstLaunch?const Splashscreen():BottomNavScreen(),
    );
  }
}

// flutter build apk --split-per-abi
