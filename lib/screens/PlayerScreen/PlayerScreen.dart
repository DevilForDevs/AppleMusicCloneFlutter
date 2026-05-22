import 'dart:ui';

import 'package:apple_music/TopLevelController.dart';
import 'package:apple_music/screens/PlayerScreen/widgets/Info.dart';
import 'package:apple_music/screens/PlayerScreen/widgets/PlayerControls.dart';
import 'package:apple_music/screens/PlayerScreen/widgets/ProgressInfoView.dart';
import 'package:apple_music/screens/PlayerScreen/widgets/VolumeControl.dart';
import 'package:apple_music/screens/widgets/SongViewItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerScreen extends StatelessWidget {

   const PlayerScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final TopLevelController controller = Get.find<TopLevelController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: SafeArea(
          bottom: false,
          child: SizedBox(height: 0),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/misc/playerbg.png",
            fit: BoxFit.cover,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                ),

                child: const Text(
                  "Apple Music Style Blur",
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              child: Column(
                children: [
                  Obx((){
                    return Image.network(
                      "https://img.youtube.com/vi/${controller.selectedSong.value?.videoId}/maxresdefault.jpg",
                    );
                  }),
                  Obx((){
                    return Info(title: controller.title.value,onMorePressed: (){},des: controller.des.value,);
                  })
                  ,
                  SizedBox(height: 16,),
                  Obx((){
                    return ProgressInfoView(totalSeconds: controller.totalSeconds.value, passedSeconds: controller.passedSeconds.value, onChanged:controller.handleSeek);
                  }),
                  SizedBox(height: 24,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() {
                        return PlayerControls(
                          isPlaying: controller.isPlaying.value,
                          onPlayPause: controller.togglePlayPause,
                          onForward: () {},
                          onBackward: () {},
                        );
                      }),

                      Obx(() {
                        return controller.isLoading.value
                            ? const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                            : const SizedBox.shrink();
                      }),
                    ],
                  )
                  ,
                  SizedBox(height: 24,),
                  Obx((){
                    return VolumeControl(volume: controller.volume.value, onVolumeChanged:controller.handleVolume);
                  }),

                  Obx(() {
                    if (controller.suggestions.isEmpty) {
                      return const Center(child: Text("No Suggestions"));
                    }

                    return ListView.builder(
                      shrinkWrap: true, // ✅ important inside scroll view
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.suggestions.length,
                      itemBuilder: (context, index) {
                        final song = controller.suggestions[index];

                        return SongViewItem(
                          item: song,
                          onItemClick:(item){
                            controller.loadSong(item);
                          },
                          isPlaying: controller.selectedSong.value?.videoId==song.videoId,
                        );
                      },
                    );
                  }),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}