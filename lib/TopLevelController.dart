import 'dart:async';

import 'package:apple_music/utils/RandomStringGenerator.dart';
import 'package:apple_music/utils/endpoints/getVisitorId.dart';
import 'package:apple_music/utils/endpoints/streamingData.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'models/SongItem.dart';

class TopLevelController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  RxMap<String, dynamic> client = <String, dynamic>{}.obs;
  RxList<SongItem> suggestions = <SongItem>[].obs;

  var isLoading = false.obs;
  var isPlaying = false.obs;
  var showVideo = false.obs;


  Rxn<SongItem> selectedSong = Rxn<SongItem>();

  RxDouble totalSeconds = 0.0.obs;
  RxDouble passedSeconds = 0.0.obs;
  RxDouble volume = 50.0.obs;

  RxString title = "Loading".obs;
  RxString des = "Loading".obs;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration?>? _durationSub;

  @override
  void onInit() {
    super.onInit();
    final item=SongItem(title: "haan tu hai",videoId: "dnND99uRz5o");
    loadSong(item);

    _listenPlayer();
    player.setVolume(volume.value / 100);
  }

  void _listenPlayer() {

    _positionSub?.cancel();

    _positionSub = player.positionStream.listen((position) {

      passedSeconds.value =
          position.inMilliseconds / 1000;
    });

    _durationSub?.cancel();

    _durationSub =
        player.durationStream.listen((duration) {

          if (duration == null) return;

          totalSeconds.value =
              duration.inMilliseconds / 1000;

        });

    _playerStateSub?.cancel();

    _playerStateSub =
        player.playerStateStream.listen((state) {

          isPlaying.value = state.playing;
        });
  }

  Future<void> loadSong(SongItem item) async {

    if (selectedSong.value?.videoId ==
        item.videoId) {

      if (player.playing) {
        return;
      }

      await player.play();
      return;
    }

    try {
      isLoading.value = true;

      selectedSong.value = item;

      final cpn =
      RandomStringGenerator.generateContentPlaybackNonce();

      final tp =
      RandomStringGenerator.generateTParameter();

      final visitorId=await getVisitorId();
      // client["client"]["visitorData"]

      final result = await androidPlayerResponse(
        cpn,
        visitorId,
        item.videoId!,
        tp,
      );

      final playerResponse = result["playerResponse"];

      // -----------------------------
      // Extract title + description
      // -----------------------------
      final videoDetails = playerResponse["videoDetails"];

      title.value =
          videoDetails?["title"] ?? "Unknown Title";

      des.value =
          videoDetails?["author"] ?? "Unknown Artist";

      // -----------------------------
      // Extract streaming formats
      // -----------------------------
      final adaptiveFormats =
      playerResponse["streamingData"]["adaptiveFormats"]
      as List<dynamic>;

      Map<String, dynamic>? audio140;

      for (final format in adaptiveFormats) {
        if (format["itag"] == 140) {
          audio140 = Map<String, dynamic>.from(format);
          break;
        }
      }

      if (audio140 == null) {
        throw Exception("itag 140 audio not found");
      }

      final audioUrl = audio140["url"];



      if (audioUrl == null) {
        title.value="Missing Audio Url, Retry";
        throw Exception("Audio url missing");
      }

      await player.setUrl(audioUrl);

      await player.play();
    } catch (e) {
      print("Load song error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
    } catch (e) {
      print("Toggle play error: $e");
    }
  }

  Future<void> handleVolume(double value) async {
    volume.value = value;

    await player.setVolume(value / 100);
  }

  Future<void> handleSeek(double value) async {
    passedSeconds.value = value;

    await player.seek(
      Duration(
        seconds: value.toInt(),
      ),
    );
  }

  Future<void> stopSong() async {
    await player.stop();

    isPlaying.value = false;

    passedSeconds.value = 0;
  }

  Future<void> nextSong() async {
    if (suggestions.isEmpty || selectedSong.value == null) return;

    final currentIndex = suggestions.indexOf(selectedSong.value!);

    if (currentIndex == -1) return;

    final nextIndex = currentIndex + 1;

    if (nextIndex < suggestions.length) {
      await loadSong(suggestions[nextIndex]);
    }
  }

  Future<void> previousSong() async {
    if (suggestions.isEmpty || selectedSong.value == null) return;

    final currentIndex = suggestions.indexOf(selectedSong.value!);

    if (currentIndex == -1) return;

    final previousIndex = currentIndex - 1;

    if (previousIndex >= 0) {
      await loadSong(suggestions[previousIndex]);
    }
  }

  @override
  void onClose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();

    player.dispose();

    super.onClose();
  }
}