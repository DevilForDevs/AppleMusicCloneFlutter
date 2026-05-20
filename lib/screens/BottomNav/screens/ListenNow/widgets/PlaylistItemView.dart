import 'package:flutter/material.dart';

import '../../../../../models/PlaylistItem.dart';

class PlaylistItemView extends StatelessWidget {
  final PlaylistItem item;
  final VoidCallback onTap;

  const PlaylistItemView({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Image.network(
              item.thumbnail,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "SFPro",
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.37,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.37,
                    color: Color(0x993C3C43),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}