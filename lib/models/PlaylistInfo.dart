class PlaylistInfo {
  final String title;
  final String posterUrl;
  final String year;
  final String des;

  PlaylistInfo({
    required this.title,
    required this.posterUrl,
    required this.year,
    required this.des,
  });

  factory PlaylistInfo.fromJson(Map<String, dynamic> json) {
    return PlaylistInfo(
      title: json["title"] ?? "",
      posterUrl: json["posterUrl"] ?? "",
      year: json["year"] ?? "",
      des: json["des"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "posterUrl": posterUrl,
      "year": year,
      "des": des,
    };
  }
}