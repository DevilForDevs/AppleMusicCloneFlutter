import 'dart:async';

import 'package:apple_music/utils/RandomStringGenerator.dart';
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

  Rxn<SongItem> selectedSong = Rxn<SongItem>();

  RxDouble totalSeconds = 0.0.obs;
  RxDouble passedSeconds = 0.0.obs;
  RxDouble volume = 50.0.obs;

  RxString title = "Loading".obs;
  RxString des = "Loading".obs;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration?>? _durationSub;

  // prevents race conditions
  int _loadRequestId = 0;

  @override
  void onInit() {
    super.onInit();

    _listenPlayer();

    player.setVolume(volume.value / 100);
  }

  void _listenPlayer() {

    _positionSub?.cancel();

    _positionSub =
        player.positionStream.listen((position) {

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
        player.playerStateStream.listen((state) async {

          isPlaying.value = state.playing;

          // Auto next
          if (state.processingState ==
              ProcessingState.completed) {

            if (suggestions.isEmpty ||
                selectedSong.value == null) {

              await stopSong();
              return;
            }

            final currentIndex =
            suggestions.indexWhere(
                  (e) =>
              e.videoId ==
                  selectedSong.value?.videoId,
            );

            if (currentIndex == -1) {
              await stopSong();
              return;
            }

            final nextIndex = currentIndex + 1;

            if (nextIndex < suggestions.length) {
              await loadSong(
                suggestions[nextIndex],
              );
            } else {
              await stopSong();
            }
          }
        });
  }

  Future<void> loadSong(SongItem item) async {

    final requestId = ++_loadRequestId;

    print("Loading: ${item.title}");

    // prevent same song reload
    if (selectedSong.value?.videoId ==
        item.videoId &&
        player.playing) {
      return;
    }

    try {

      isLoading.value = true;

      // immediately update UI selection
      selectedSong.value = item;

      final cpn =
      RandomStringGenerator
          .generateContentPlaybackNonce();

      final tp =
      RandomStringGenerator
          .generateTParameter();

      final result =
      await androidPlayerResponse(
        cpn,
        client["client"]["visitorData"],
        item.videoId!,
        tp,
      );

      // old request ignored
      if (requestId != _loadRequestId) {
        return;
      }

      final playerResponse =
      result["playerResponse"];

      final videoDetails =
      playerResponse["videoDetails"];

      title.value =
          videoDetails?["title"] ??
              "Unknown Title";

      des.value =
          videoDetails?["author"] ??
              "Unknown Artist";

      final adaptiveFormats =
      playerResponse["streamingData"]
      ["adaptiveFormats"] as List<dynamic>;

      Map<String, dynamic>? audio140;

      for (final format in adaptiveFormats) {

        if (format["itag"] == 140) {

          audio140 =
          Map<String, dynamic>.from(
            format,
          );

          break;
        }
      }

      if (audio140 == null) {
        throw Exception(
          "itag 140 audio not found",
        );
      }

      final audioUrl = audio140["url"];

      if (audioUrl == null) {
        throw Exception(
          "Audio url missing",
        );
      }

      // old request ignored
      if (requestId != _loadRequestId) {
        return;
      }

      // important
      await player.stop();

      // old request ignored
      if (requestId != _loadRequestId) {
        return;
      }

      passedSeconds.value = 0;
      totalSeconds.value = 0;

      await player.setUrl(audioUrl);

      // old request ignored
      if (requestId != _loadRequestId) {
        return;
      }

      await player.play();

    } catch (e) {

      print("Load song error: $e");

    } finally {

      if (requestId == _loadRequestId) {
        isLoading.value = false;
      }
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

  Future<void> handleVolume(
      double value,
      ) async {

    volume.value = value;

    await player.setVolume(
      value / 100,
    );
  }

  Future<void> handleSeek(
      double value,
      ) async {

    passedSeconds.value = value;

    await player.seek(
      Duration(
        milliseconds:
        (value * 1000).toInt(),
      ),
    );
  }

  Future<void> stopSong() async {

    // invalidate old loads
    _loadRequestId++;

    await player.stop();

    isPlaying.value = false;

    passedSeconds.value = 0;
    totalSeconds.value = 0;
  }

  Future<void> nextSong() async {

    if (suggestions.isEmpty ||
        selectedSong.value == null) {
      return;
    }

    final currentIndex =
    suggestions.indexWhere(
          (e) =>
      e.videoId ==
          selectedSong.value?.videoId,
    );

    if (currentIndex == -1) {
      return;
    }

    final nextIndex = currentIndex + 1;

    if (nextIndex < suggestions.length) {

      await loadSong(
        suggestions[nextIndex],
      );
    }
  }

  Future<void> previousSong() async {

    if (suggestions.isEmpty ||
        selectedSong.value == null) {
      return;
    }

    final currentIndex =
    suggestions.indexWhere(
          (e) =>
      e.videoId ==
          selectedSong.value?.videoId,
    );

    if (currentIndex == -1) {
      return;
    }

    final previousIndex =
        currentIndex - 1;

    if (previousIndex >= 0) {

      await loadSong(
        suggestions[previousIndex],
      );
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