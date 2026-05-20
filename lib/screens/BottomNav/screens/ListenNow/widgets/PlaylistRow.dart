import 'package:apple_music/models/SongItem.dart';
import 'package:apple_music/screens/BottomNav/screens/ListenNow/widgets/PlaylistItemView.dart';
import 'package:apple_music/screens/widgets/SongViewItem.dart';
import 'package:flutter/material.dart';

import '../../../../../models/PlaylistItem.dart';
import '../../../../../models/Section.dart';

class PlaylistRow extends StatelessWidget {
  final Section section;
  final Function(PlaylistItem item) onTapPlaylist;
  final Function(SongItem item) onTapSong;

  const PlaylistRow({
    super.key,
    required this.section,
    required this.onTapPlaylist, required this.onTapSong,
  });

  @override
  Widget build(BuildContext context) {

    final hasPlaylists = section.items.isNotEmpty;

    final hasSongs =
        section.songItem != null &&
            section.songItem!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// TITLE
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 12,
          ),

          child: Text(
            section.title,

            textAlign: TextAlign.left,

            style: const TextStyle(
              fontFamily: "SFPro",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.37,
            ),
          ),
        ),

        /// PLAYLIST ROW
        if (hasPlaylists)
          SizedBox(
            height: 210,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,

              physics: const BouncingScrollPhysics(),

              itemCount: section.items.length,

              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },

              itemBuilder: (context, index) {

                final item = section.items[index];

                return PlaylistItemView(
                  item: item,
                  onTap: () => onTapPlaylist(item),
                );
              },
            ),
          ),

        /// SONG LIST
        if (hasSongs)
          ListView.separated(
            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemCount: section.songItem!.length,

            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },

            itemBuilder: (context, index) {

              final item =
              section.songItem![index];

              return SongViewItem(
                item: item,
                onItemClick: onTapSong,
              );
            },
          ),
      ],
    );
  }
}