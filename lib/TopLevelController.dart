import 'dart:async';
import 'dart:io';
import 'package:apple_music/utils/endpoints/streamingData.dart';
import 'package:apple_music/utils/endpoints/visitorIdfetcher.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  RxDouble volume = 25.0.obs;

  RxString title = "Loading".obs;
  RxString des = "Loading".obs;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _loadingStateListenerSub;





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

  Future<void> loadSong(SongItem item,) async {

    if (selectedSong.value?.videoId == item.videoId) {
      return;
    }

    selectedSong.value = item;

    isLoading.value = true;

    try {

      await player.stop();

      passedSeconds.value = 0;
      totalSeconds.value = 0;

      title.value = "Loading...";
      des.value = "Loading...";

      String? audioUrl;
      Map<String, dynamic>? playerResponse;
      int maxAttempts = 3;

      // Retry loop: try up to 3 times if audio URL is null
      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        try {
          // Get a fresh visitorId on each attempt
          final visitorId = await getVisitorId();

          playerResponse =
          await androidPlayerResponse(
            item.videoId ?? "",
            visitorId,
          );

          audioUrl = extractAudioUrl(
            playerResponse["playerResponse"],
          );

          // If we got the audio URL, break out of the retry loop
          if (audioUrl != null) {
            title.value =
            playerResponse["playerResponse"]
            ["videoDetails"]["title"];

            des.value =
            playerResponse["playerResponse"]
            ["videoDetails"]["author"];
            
            break;
          }

          // If this was the last attempt and audioUrl is still null, show error
          if (attempt == maxAttempts - 1) {
            Fluttertoast.showToast(
              msg: "Failed to get audio url after $maxAttempts attempts",
            );
            return;
          }

        } catch (e) {
          print("Attempt ${attempt + 1} failed: $e");
          
          // If this was the last attempt, show error
          if (attempt == maxAttempts - 1) {
            Fluttertoast.showToast(
              msg: "Failed to load song after $maxAttempts attempts",
            );
            return;
          }
        }
      }

      if (audioUrl == null) {
        return;
      }

      await player.setUrl(audioUrl);
      isLoading.value = false;

      await _startPlayback();

    } catch (e) {

      print(e);

    } finally {

      isLoading.value = false;
    }
  }


  Future<void> _startPlayback() async {
    await player.seek(Duration.zero);

    for (var attempt = 0; attempt < 3; attempt++) {
      await player.play();

      await Future.delayed(const Duration(milliseconds: 500));

      if (player.playing) {
        return;
      }
    }

  }


  Future<void> togglePlayPause() async {

    try {

      if (player.playing) {
        await player.pause();
      } else {
        await _startPlayback();
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
    await player.stop();

    isPlaying.value = false;

    passedSeconds.value = 0;
    totalSeconds.value = 0;
  }


  @override
  void onClose() {

    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _loadingStateListenerSub?.cancel();

    player.dispose();

    super.onClose();
  }
}