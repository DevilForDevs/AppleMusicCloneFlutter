import 'package:apple_music/models/SongItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../TopLevelController.dart';
import '../../models/PlaylistItem.dart';
import '../../utils/endpoints/playlistBrowse.dart';
import '../../utils/parsers/playlitParser.dart';

class ScreenController extends GetxController {
  final TopLevelController top = Get.find<TopLevelController>();

  // ✅ track current loaded browseId
  final RxString currentBrowseId = "".obs;

  var des = "Loading...".obs;
  var year = "Loading...".obs;
  RxList<SongItem> songs = <SongItem>[].obs;

  var isLoading = false.obs;


  Future<void> loadPlaylist(String browseId) async {
    // ✅ prevent duplicate API calls
    if (currentBrowseId.value == browseId && songs.isNotEmpty) {
      return;
    }

    currentBrowseId.value = browseId;
    isLoading.value = true;

    try {
      final json = await browse(
        client: top.client.value,
        browseId: browseId,
      );

      final result = parsePlaylist(json);

      songs.value = result.items;
      des.value = result.info?.des ?? "";
      year.value = result.info?.year ?? "";
    } catch (e) {
      debugPrint("loadPlaylist error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}