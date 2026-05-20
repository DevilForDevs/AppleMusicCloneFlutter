import 'package:apple_music/screens/BottomNav/BottomNavScreen.dart';
import 'package:apple_music/screens/SetupScreens/commanWidgets/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commanWidgets/ActionButton.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Topbar(showBackButton: false),
            ),

            Image.asset('assets/images/misc/poster.png'),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Image.asset(
                          'assets/images/misc/applelogo.png',
                          height: 20,
                          width: 20,
                        ),

                        SizedBox(width: 4),

                        Text(
                          "Music",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: "SFPro",
                            height: 20 / 21,
                            letterSpacing: -0.5,
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 16),

                    Text(
                      "60 million songs. All ad-free.",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: "SFPro",
                        height: 20 / 21,
                        letterSpacing: -0.5,
                      ),
                    ),

                    SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text(
                        "Plus your entire music library on all your devices. Plan auto-renews for \$9.99/month until canceled.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: "SFPro",
                          height: 20 / 21,
                        ),
                        maxLines: 4,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "See More Plans",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE63D43),
                        fontFamily: "SFPro",
                        height: 20 / 21,
                        letterSpacing: -0.5,
                      ),
                    ),

                    Spacer(),

                    ActionButton(
                      title: "Start Listening",
                      onPress: () {
                        Get.to(() => BottomNavScreen());
                      },
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}

