import 'dart:convert';

import 'package:apple_music/utils/endpoints/visitorIdfetcher.dart';
import 'package:http/http.dart' as http;

import '../RandomStringGenerator.dart';

Future<Map<String, dynamic>> androidPlayerResponse(
    String videoId,
    String visitorData
    ) async {
  final cpn = RandomStringGenerator.generateContentPlaybackNonce();
  final t = RandomStringGenerator.generateTParameter();

  final url =
      "https://youtubei.googleapis.com/youtubei/v1/reel/reel_item_watch"
      "?prettyPrint=false&t=$t&id=$videoId&\$fields=playerResponse";

  final jsonBody = {
    "context": {
      "client": {
        "clientName": "ANDROID",
        "clientVersion": "21.03.36",
        "clientScreen": "WATCH",
        "platform": "MOBILE",
        "osName": "Android",
        "osVersion": "16",
        "androidSdkVersion": 36,
        "hl": "en-GB",
        "gl": "GB",
        "utcOffsetMinutes": 0,
        "visitorData": visitorData,
      },
      "request": {
        "internalExperimentFlags": [],
        "useSsl": true,
      },
      "user": {
        "lockedSafetyMode": false,
      },
    },
    "playerRequest": {
      "videoId": videoId,
      "cpn": cpn,
      "contentCheckOk": true,
      "racyCheckOk": true,
    },
    "disablePlayerResponse": false,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "User-Agent":
      "com.google.android.youtube/21.03.36 "
          "(Linux; U; Android 15; GB) gzip",
      "X-Goog-Api-Format-Version": "2",
      "Content-Type": "application/json",
      "Accept-Language": "en-GB, en;q=0.9",
    },
    body: jsonEncode(jsonBody),
  );

  if (response.statusCode != 200) {
    throw Exception(
      "Request failed: ${response.statusCode}\n${response.body}",
    );
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}

String? extractAudioUrl(Map<String, dynamic> playerResponse) {
  final streamingData = playerResponse["streamingData"];
  final adaptiveFormats = streamingData is Map<String, dynamic>
      ? streamingData["adaptiveFormats"]
      : null;

  if (adaptiveFormats is! List) {
    return null;
  }

  for (final format in adaptiveFormats) {
    if (format is Map && format["itag"] == 140) {
      final audio140 = Map<String, dynamic>.from(format);
      final audioUrl = audio140["url"];

      if (audioUrl is String && audioUrl.isNotEmpty) {
        return audioUrl;
      }
    }
  }

  return null;
}