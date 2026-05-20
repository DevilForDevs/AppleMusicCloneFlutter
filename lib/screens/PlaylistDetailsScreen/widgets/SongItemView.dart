import 'package:flutter/material.dart';

import '../../../models/SongItem.dart';

class SongItemView extends StatelessWidget {
  final SongItem item;
  final int index;
  final Function(SongItem item) onItemClick;

  const SongItemView({
    super.key,
    required this.item,
    required this.index,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Index
        SizedBox(
          width: 24,
          child: Text(
            "${index + 1}",
            style: const TextStyle(
              color: Color(0x993C3C43),
              fontSize: 17,
              height: 27 / 17,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0x2E3C3C43),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Title
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onItemClick(item);
                    },
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 22 / 17,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Icon
                Image.asset(
                  "assets/images/misc/down.png",
                  height: 35,
                  width: 35,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}