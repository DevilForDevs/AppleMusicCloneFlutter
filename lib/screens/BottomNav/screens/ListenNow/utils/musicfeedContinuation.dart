import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchFeedsContinuation({
  required String continuationToken,
  required Map<String, dynamic> clientContext,
}) async {
  final uri = Uri.parse(
    'https://music.youtube.com/youtubei/v1/browse'
        '?ctoken=$continuationToken'
        '&continuation=$continuationToken'
        '&type=next'
        '&prettyPrint=false',
  );

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'User-Agent':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/147.0.0.0 Safari/537.36',
      'Origin': 'https://music.youtube.com',
      'Referer': 'https://music.youtube.com/',
    },
    body: jsonEncode({
      "context": clientContext,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'YouTube API failed: ${response.statusCode}\n${response.body}',
    );
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}