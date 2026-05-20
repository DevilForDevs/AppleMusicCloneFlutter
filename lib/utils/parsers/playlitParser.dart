import '../../models/PlaylistInfo.dart';
import '../../models/PlaylistResponse.dart';
import '../../models/SongItem.dart';
import '../safeGate.dart';

PlaylistResponse parsePlaylist(dynamic json) {
  final continuationAndItems = safeGet(json, [
    "contents",
    "twoColumnBrowseResultsRenderer",
    "secondaryContents",
    "sectionListRenderer"
  ]);
  if (continuationAndItems == null ||
      continuationAndItems["contents"] == null) {
    return PlaylistResponse(
      continuation: null,
      items: [],
      info:PlaylistInfo(title: "", posterUrl: "", year: "", des: ""),
    );
  }

  final items = safeGet(continuationAndItems, [
    "contents",
    0,
    "musicPlaylistShelfRenderer",
    "contents"
  ]) ??
      [];

  List<SongItem> parsed = [];

  for (final i in items) {
    final renderer = i["musicResponsiveListItemRenderer"];
    if (renderer == null) continue;

    final thumbnail = safeGet(renderer, [
      "thumbnail",
      "musicThumbnailRenderer",
      "thumbnail",
      "thumbnails",
      -1,
      "url"
    ]);

    final title = safeGet(renderer, [
      "flexColumns",
      0,
      "musicResponsiveListItemFlexColumnRenderer",
      "text",
      "runs",
      0,
      "text"
    ]) ??
        "";

    final videoId = safeGet(renderer, [
      "playlistItemData",
      "videoId"
    ]);

    final artist = safeGet(renderer, [
      "flexColumns",
      1,
      "musicResponsiveListItemFlexColumnRenderer",
      "text",
      "runs",
      0,
      "text"
    ]);

    final duration = safeGet(renderer, [
      "fixedColumns",
      0,
      "musicResponsiveListItemFixedColumnRenderer",
      "text",
      "runs",
      0,
      "text"
    ]);

    parsed.add(
      SongItem(
        videoId: videoId ?? "",
        title: title,
        thumbnail: thumbnail ?? "",
        artist: artist ?? "",
      ),
    );
  }

  final section = safeGet(json, [
    "contents",
    "twoColumnBrowseResultsRenderer",
    "tabs",
    0,
    "tabRenderer",
    "content",
    "sectionListRenderer",
    "contents",
    0
  ]);

  final playlistPoster = safeGet(section, [
    "musicResponsiveHeaderRenderer",
    "thumbnail",
    "musicThumbnailRenderer",
    "thumbnail",
    "thumbnails",
    -1,
    "url"
  ]) ??
      "";

  final playlistTitle = safeGet(section, [
    "musicResponsiveHeaderRenderer",
    "title",
    "runs",
    0,
    "text"
  ]) ??
      "";

  final year = safeGet(section, [
    "musicResponsiveHeaderRenderer",
    "subtitle",
    "runs",
    2,
    "text"
  ]) ??
      "";

  final des = safeGet(section, [
    "musicResponsiveHeaderRenderer",
    "description",
    "musicDescriptionShelfRenderer",
    "description",
    "runs",
    0,
    "text"
  ]) ??
      "";

  final continuation = safeGet(continuationAndItems, [
    "continuations",
    0,
    "nextContinuationData",
    "continuation"
  ]);

  final PlaylistInfo info = PlaylistInfo(title:playlistTitle,posterUrl: playlistPoster,year: year,des: des );
  return PlaylistResponse(
    continuation: continuation,
    items: parsed,
    info:info,
  );


}