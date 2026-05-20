import 'package:apple_music/models/PlaylistItem.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/ListenNowController.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/widgets/PlaylistRow.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/widgets/Topbar.dart';
import 'package:apple_music/screens/PlaylistDetailsScreen/PlaylistDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../TopLevelController.dart';
import '../../../PlaylistDetailsScreen/ScreenController.dart';

class ListenNow extends StatefulWidget {
  const ListenNow({super.key});

  @override
  State<ListenNow> createState() => _ListenNowState();
}

class _ListenNowState extends State<ListenNow> {
  final ListenNowController controller =
  Get.put(ListenNowController());

  final ScrollController scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final position = scrollController.position;

      if (position.pixels >=
          position.maxScrollExtent - 200) {

        if (!controller.isLoading.value &&
            controller.continuation.value != null) {
          print("loading more triggered");

          controller.loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TopLevelController tpc =
    Get.find<TopLevelController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(child: Topbar()),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),

        child: Obx(() {

          if (controller.isLoading.value &&
              controller.feeds.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.feeds.isEmpty) {
            return const Center(
              child: Text("No feeds found"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {

            },

            child: ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.only(
                top: 8,
                bottom: 24,
              ),

              itemCount: controller.feeds.length,

              separatorBuilder: (context, index) =>
              const SizedBox(height: 20),

              itemBuilder: (context, index) {
                final section = controller.feeds[index];

                return PlaylistRow(
                  section: section,
                  onTapPlaylist: navigate,
                  onTapSong: tpc.loadSong,
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void navigate(PlaylistItem item) {
    Get.to(PlaylistDetailsScreen(item: item));
  }
}