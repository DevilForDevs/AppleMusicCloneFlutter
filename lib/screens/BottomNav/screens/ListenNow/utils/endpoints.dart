import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> musicFeeds() async {

  final url = Uri.parse(
    "https://music.youtube.com/?gl=IN&hl=en-IN",
  );

  final headers = {
    "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36",

    "Accept":
    "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",

    "Accept-Language": "en-IN,en;q=0.9,hi;q=0.8",

    "X-YouTube-Client-Name": "1",
    "X-YouTube-Client-Version": "2.20260508.01.00",

    "Sec-CH-UA":
    '"Google Chrome";v="147", "Chromium";v="147", "Not_A Brand";v="99"',

    "Sec-CH-UA-Mobile": "?0",
    "Sec-CH-UA-Platform": '"Windows"',

    "timeZone": "Asia/Kolkata",

    "Referer": "https://www.youtube.com/",
    "Origin": "https://www.youtube.com",

    "X-Forwarded-For": "49.36.81.1",
  };

  final response = await http.get(
    url,
    headers: headers,
  );

  if (response.statusCode != 200) {
    throw Exception("fetch_failed");
  }

  final html = response.body;

  /*
  ------------------------------------------
  1️⃣ EXTRACT YTCFG
  ------------------------------------------
  */

  Map<String, dynamic>? ytcfg;

  final ytcfgRegex = RegExp(
    r'ytcfg\.set\((\{.*?\})\);',
    dotAll: true,
  );

  final ytcfgMatch = ytcfgRegex.firstMatch(html);

  if (ytcfgMatch != null) {
    try {
      ytcfg = jsonDecode(ytcfgMatch.group(1)!);
    } catch (_) {}
  }

  /*
  ------------------------------------------
  2️⃣ FIND SCRIPT WITH initialData.push
  ------------------------------------------
  */

  final scriptRegex = RegExp(
    r'<script[^>]*>(.*?)<\/script>',
    dotAll: true,
  );

  final scripts = scriptRegex.allMatches(html);

  String? targetScript;

  for (final match in scripts) {

    final script = match.group(1) ?? "";

    if (script.contains("initialData.push")) {
      targetScript = script;
      break;
    }
  }

  if (targetScript == null) {
    throw Exception("script_not_found");
  }

  /*
  ------------------------------------------
  3️⃣ EXTRACT SECOND initialData.push
  ------------------------------------------
  */

  final pushRegex = RegExp(
    r'initialData\.push\((\{.*?\})\)',
    dotAll: true,
  );

  final pushes = pushRegex.allMatches(targetScript).toList();

  if (pushes.length < 2) {
    throw Exception("push_not_found");
  }

  final secondPushObj = pushes[1].group(1)!;

  /*
  ------------------------------------------
  4️⃣ EXTRACT data FIELD
  ------------------------------------------
  */
  final dataRegex = RegExp(
    'data:\\s*(["\\\'])(.*?)\\1',
    dotAll: true,
  );

  final dataMatch = dataRegex.firstMatch(secondPushObj);

  if (dataMatch == null) {
  throw Exception("data_not_found");
  }

  final encoded = dataMatch.group(2)!;

  /*
  ------------------------------------------
  5️⃣ DECODE HEX
  ------------------------------------------
  */

  final decoded = decodeJsHex(encoded);

  final cleaned = decoded.replaceFirst(
  RegExp(r'^\uFEFF'),
  '',
  );

  final feed = jsonDecode(cleaned);

  /*
  ------------------------------------------
  FINAL RESPONSE
  ------------------------------------------
  */

  return {
  "success": true,
  "ytcfg": ytcfg?["INNERTUBE_CONTEXT"],
  "feed": feed,
  };
}

String decodeJsHex(String input) {

  return input.replaceAllMapped(
    RegExp(r'\\x([0-9a-fA-F]{2})'),
        (match) {

      final hex = match.group(1)!;

      return String.fromCharCode(
        int.parse(hex, radix: 16),
      );
    },
  );
}