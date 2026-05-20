import 'package:apple_music/screens/BottomNav/screens/BrowseScreen/BrowseScreen.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/ListenNow.dart';
import 'package:apple_music/screens/BottomNav/screens/RadioScreen/RadioScreen.dart';
import 'package:apple_music/screens/BottomNav/screens/SearchScreen/SearchScreen.dart';
import 'package:apple_music/screens/PlayerScreen/PlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../TopLevelController.dart';
import 'bottom_nav_controller.dart';
import 'commonWidgets/FloatingPlayer.dart';
import 'screens/Library/LibraryScreen.dart';

class BottomNavScreen extends StatelessWidget {

  BottomNavScreen({super.key});

  final BottomNavController controller =
  Get.put(BottomNavController());

  final List<Widget> pages = [
    ListenNow(),
    const BrowseScreen(),
    const RadioScreen(),
    const LibraryScreen(),
    const SearchScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final TopLevelController tpc = Get.find<TopLevelController>();

    return Obx(() => Scaffold(

      body: IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Mini Player
          Obx(() {
            final song = tpc.selectedSong.value;

            if (song == null) {
              return const SizedBox.shrink();
            }

            return FloatingPlayer(
              onTitleClick: ()=>Get.to(PlayerScreen()),
              item: song,
              playPause: tpc.togglePlayPause,
              isPlaying: tpc.isPlaying.value,
            );
          }),
          // Bottom Nav
          BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,

            // Disable splash / hopping animation
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            enableFeedback: false,

            // Label colors
            selectedItemColor: const Color(0xFFE63D43),
            unselectedItemColor: Colors.grey,

            // Label styles
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),

            items: [

              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "assets/images/selected/Listen Now.png",
                  height: 20,
                  width: 20,
                ),
                label: "Listen Now",
                icon: Image.asset(
                  "assets/images/unselected/Listen Now.png",
                  height: 20,
                  width: 20,
                ),
              ),

              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  "assets/images/selected/browse.png",
                  height: 20,
                  width: 20,
                ),
                label: "Browse",
                icon: Image.asset(
                  "assets/images/unselected/Browse.png",
                  height: 20,
                  width: 20,
                ),
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/unselected/Radio.png",
                  height: 20,
                  width: 20,
                ),
                label: "Radio",
                activeIcon: Image.asset(
                  "assets/images/selected/Radio.png",
                  height: 20,
                  width: 20,
                ),
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/unselected/Library.png",
                  height: 20,
                  width: 20,
                ),
                label: "Library",
                activeIcon: Image.asset(
                  "assets/images/selected/Library.png",
                  height: 20,
                  width: 20,
                ),
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/unselected/Search.png",
                  height: 20,
                  width: 20,
                ),
                label: "Search",
                activeIcon: Image.asset(
                  "assets/images/selected/Search.png",
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

