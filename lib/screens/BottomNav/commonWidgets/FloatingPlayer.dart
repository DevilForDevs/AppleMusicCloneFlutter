import 'package:apple_music/models/SongItem.dart';
import 'package:flutter/material.dart';

class FloatingPlayer extends StatelessWidget {
  const FloatingPlayer({
    super.key,
    required this.playPause,
    required this.item, required this.isPlaying, required this.onTitleClick,
  });
  final bool isPlaying;
  final SongItem item;
  final VoidCallback playPause;
  final VoidCallback onTitleClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              item.thumbnail ?? "",
              height: 45,
              width: 65,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // ✅ FIX: title takes remaining space only
          Expanded(
            child: GestureDetector(
              onTap: onTitleClick,
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // right controls stay fixed
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: playPause,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
