import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getVisitorId() async {
  const url =
      'https://youtubei.googleapis.com/youtubei/v1/visitor_id?prettyPrint=false';

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
      },
      "request": {
        "internalExperimentFlags": [],
        "useSsl": true,
      },
      "user": {
        "lockedSafetyMode": false,
      },
    }
  };

  final headers = {
    "User-Agent":
    "com.google.android.youtube/21.03.36 (Linux; U; Android 15; GB) gzip",
    "X-Goog-Api-Format-Version": "2",
    "Content-Type": "application/json",
    "Accept-Language": "en-GB, en;q=0.9",
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(jsonBody),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Request failed: ${response.statusCode}\n${response.body}',
    );
  }

  final json = jsonDecode(response.body);

  return json["responseContext"]["visitorData"];
}