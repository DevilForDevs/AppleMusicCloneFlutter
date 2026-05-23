import 'package:apple_music/models/PlaylistItem.dart';
import 'package:apple_music/screens/PlaylistDetailsScreen/ScreenController.dart';
import 'package:apple_music/screens/PlaylistDetailsScreen/widgets/PlaylistInfo.dart';
import 'package:apple_music/screens/PlaylistDetailsScreen/widgets/SongItemView.dart';
import 'package:apple_music/screens/PlaylistDetailsScreen/widgets/Topbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../TopLevelController.dart';
import '../PlayerScreen/PlayerScreen.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final PlaylistItem item;

  PlaylistDetailsScreen({super.key, required this.item}) {
    Get.put(ScreenController());
  }

  @override
  Widget build(BuildContext context) {
    final ScreenController controller = Get.find<ScreenController>();
    final TopLevelController tpc = Get.find<TopLevelController>();
    controller.loadPlaylist(item.browseId);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(bottom: false,child: Topbar(onBackPress: backPress)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                item.thumbnail,
                height: 300,
                width: 400,
                fit: BoxFit.cover,
              ),
              Obx(() {
                return PlaylistInfoView(
                  item: item,
                  subtitle: controller.des.value,
                  year: controller.year.value,
                );
              }),
              const SizedBox(height: 10),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.songs.isEmpty) {
                  return const Center(child: Text("No songs found"));
                }

                return ListView.builder(
                  shrinkWrap: true, // ✅ important inside scroll view
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.songs.length,
                  itemBuilder: (context, index) {
                    final song = controller.songs[index];

                    return SongItemView(
                      item: song,
                      index: index,
                      onItemClick:(item){
                        tpc.loadSong(item);
                        tpc.suggestions.clear();
                        tpc.suggestions.addAll(controller.songs);
                        Get.to(PlayerScreen());
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void backPress() {
    Get.back();
  }

}
