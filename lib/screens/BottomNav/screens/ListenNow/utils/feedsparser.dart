

import '../../../../../models/HomepageFeeds.dart';
import '../../../../../models/PlaylistItem.dart';
import '../../../../../models/Section.dart';
import '../../../../../models/SongItem.dart';
import '../../../../../utils/safeGate.dart';



PlaylistItem parseItem(dynamic item) {

  final thumbnail = safeGet(item, [
    "thumbnailRenderer",
    "musicThumbnailRenderer",
    "thumbnail",
    "thumbnails",
    0,
    "url"
  ]) ??
      "";

  final title = safeGet(item, [
    "title",
    "runs",
    0,
    "text",
  ]) ??
      "";

  final subtitle = safeGet(item, [
    "subtitle",
    "runs",
    0,
    "text",
  ]) ??
      "";

  final browseId = safeGet(item, [
    "title",
    "runs",
    0,
    "navigationEndpoint",
    "browseEndpoint",
    "browseId",
  ]) ??
      "";

  final params = safeGet(item, [
    "title",
    "runs",
    0,
    "navigationEndpoint",
    "browseEndpoint",
    "params",
  ]) ??
      "";

  return PlaylistItem(
    title: title,
    subtitle: subtitle,
    browseId: browseId,
    params: params,
    thumbnail: thumbnail,
  );
}

SongItem parseSongItem(dynamic k) {

  final thumbnail = safeGet(k, [
    "musicResponsiveListItemRenderer",
    "thumbnail",
    "musicThumbnailRenderer",
    "thumbnail",
    "thumbnails",
    -1,
    "url"
  ]);

  final title = safeGet(k, [
    "musicResponsiveListItemRenderer",
    "flexColumns",
    0,
    "musicResponsiveListItemFlexColumnRenderer",
    "text",
    "runs",
    0,
    "text"
  ]) ??
      "";

  final artist = safeGet(k, [
    "musicResponsiveListItemRenderer",
    "flexColumns",
    1,
    "musicResponsiveListItemFlexColumnRenderer",
    "text",
    "runs",
    0,
    "text"
  ]);

  final videoId = safeGet(k, [
    "musicResponsiveListItemRenderer",
    "playlistItemData",
    "videoId"
  ]);

  return SongItem(
    title: title,
    thumbnail: thumbnail,
    artist: artist,
    videoId: videoId,
  );
}

Future<HomepageFeeds> parseFeeds(Map<String, dynamic> json) async {
  final feed = json["feed"];

  final itemsAndContinuation = safeGet(feed, [
    "contents",
    "singleColumnBrowseResultsRenderer",
    "tabs",
    0,
    "tabRenderer",
    "content",
    "sectionListRenderer"
  ]);

  if (itemsAndContinuation == null ||
      itemsAndContinuation["contents"] == null) {

    return HomepageFeeds(
      continuation: null,
      sections: [],
      client: {},
    );
  }

  final items = itemsAndContinuation["contents"] as List;

  List<Section> sections = [];

  for (final r in items) {

    final carousel = r["musicCarouselShelfRenderer"];

    if (carousel == null) continue;

    final listHeader = safeGet(carousel, [
      "header",
      "musicCarouselShelfBasicHeaderRenderer",
      "title",
      "runs",
      0,
      "text",
    ]) ??
        "";

    List<PlaylistItem> playlistItems = [];

    List<SongItem> songItems = [];

    final contents = carousel["contents"] ?? [];

    for (final k in contents) {

      if (k["musicTwoRowItemRenderer"] != null) {

        final item = k["musicTwoRowItemRenderer"];

        playlistItems.add(
          parseItem(item),
        );
      }

      if (k["musicResponsiveListItemRenderer"] != null) {

        songItems.add(
          parseSongItem(k),
        );
      }
    }

    sections.add(
      Section(
        title: listHeader,
        items: playlistItems,
        songItem: songItems,
      ),
    );
  }

  final continuation = safeGet(itemsAndContinuation, [
    "continuations",
    0,
    "nextContinuationData",
    "continuation"
  ]);

  return HomepageFeeds(
    continuation: continuation,
    sections: sections,
    client: json["ytcfg"] ?? {},
  );
}

Future<HomepageFeeds> getContinuationItems({
  required Map<String, dynamic> data
}) async {

  final contentsAndContinuation = safeGet(data, [
    "continuationContents",
    "sectionListContinuation",
    "contents"
  ]) ??
      [];

  final continuationToken = safeGet(data, [
    "continuationContents",
    "sectionListContinuation",
    "continuations",
    0,
    "nextContinuationData",
    "continuation"
  ]);

  List<Section> sections = [];

  for (final r in contentsAndContinuation) {

    final carousel = r["musicCarouselShelfRenderer"];

    if (carousel == null) continue;

    final listHeader = safeGet(carousel, [
      "header",
      "musicCarouselShelfBasicHeaderRenderer",
      "title",
      "runs",
      0,
      "text",
    ]) ??
        "";

    List<PlaylistItem> playlistItems = [];

    List<SongItem> songItems = [];

    final contents = carousel["contents"] ?? [];

    for (final k in contents) {

      if (k["musicTwoRowItemRenderer"] != null) {

        final item = k["musicTwoRowItemRenderer"];

        playlistItems.add(
          parseItem(item),
        );
      }

      if (k["musicResponsiveListItemRenderer"] != null) {

        songItems.add(
          parseSongItem(k),
        );
      }
    }

    sections.add(
      Section(
        title: listHeader,
        items: playlistItems,
        songItem: songItems,
      ),
    );
  }

  return HomepageFeeds(
    sections: sections,
    continuation: continuationToken,
    client: {},
  );
}