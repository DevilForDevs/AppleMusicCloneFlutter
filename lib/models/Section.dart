import 'PlaylistItem.dart';
import 'SongItem.dart';

class Section {
  final String title;
  final List<PlaylistItem> items;
  final List<SongItem>? songItem;

  Section({
    required this.title,
    required this.items,
    this.songItem,
  });
}