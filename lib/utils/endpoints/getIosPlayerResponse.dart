import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getIosPlayerResponse(
    String videoId,
    String visitorId,
    String cpn
    ) async {


  const url =
      'https://www.youtube.com/youtubei/v1/player?prettyPrint=false';

  final body = {
    "context": {
      "client": {
        "clientName": "IOS",
        "clientVersion": "21.03.2",
        "clientScreen": "WATCH",
        "platform": "MOBILE",
        "visitorData": visitorId,
        "deviceMake": "Apple",
        "deviceModel": "iPhone16,2",
        "osName": "iOS",
        "osVersion": "18.7.2.22H124",
        "hl": "en-GB",
        "gl": "GB",
        "utcOffsetMinutes": 0
      },
      "request": {
        "internalExperimentFlags": [],
        "useSsl": true
      },
      "user": {
        "lockedSafetyMode": false
      }
    },
    "videoId": videoId,
    "cpn": cpn,
    "contentCheckOk": true,
    "racyCheckOk": true
  };

  final headers = {
    "User-Agent":
    "com.google.ios.youtube/21.03.2(iPhone16,2; U; CPU iOS 18_7_2 like Mac OS X; GB)",
    "Content-Type": "application/json",
    "X-Goog-Api-Format-Version": "2",
    "X-Youtube-Client-Name": "5",
    "X-Youtube-Client-Version": "21.03.2",
    "Accept-Language": "en-GB,en;q=0.9",
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to fetch player response: ${response.statusCode}\n${response.body}',
    );
  }

  return jsonDecode(response.body);
}