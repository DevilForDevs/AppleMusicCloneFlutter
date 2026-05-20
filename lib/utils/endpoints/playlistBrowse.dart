import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> browse({
  required Map<String, dynamic> client,
  required String browseId,
  String? params,
}) async {
  const String _baseUrl = "https://music.youtube.com/youtubei/v1/browse?prettyPrint=false";
  try {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/147.0.0.0 Safari/537.36",
        "Referer": "https://music.youtube.com/",
      },
      body: jsonEncode({
        "context": client,
        "browseId": browseId,
        if (params != null) "params": params,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception({
        "error": "youtube_api_failed",
        "status": response.statusCode,
        "body": response.body,
      });
    }

    final data = jsonDecode(response.body);

    if (data == null) {
      throw Exception("invalid_json_from_youtube");
    }

    return data as Map<String, dynamic>;
  } catch (e) {
    throw Exception("browse() failed: $e");
  }
}