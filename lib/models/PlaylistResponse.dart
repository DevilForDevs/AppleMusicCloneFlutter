import 'PlaylistInfo.dart';
import 'SongItem.dart';

class PlaylistResponse {
  final List<SongItem> items;
  final String? continuation;
  final PlaylistInfo? info;

  PlaylistResponse({
    required this.items,
    required this.continuation,
    this.info,
  });
}