import 'package:flutter/material.dart';

import '../../../models/PlaylistItem.dart';
import 'BigButton.dart';
class PlaylistInfoView extends StatelessWidget {
  const PlaylistInfoView({
    super.key,
    required this.item, required this.subtitle, required this.year,
  });

  final PlaylistItem item;
  final String subtitle;
  final String year;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(item.title,style: TextStyle(
            fontFamily: "SFPro",
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.38
        )),
        Text(subtitle,maxLines:2,textAlign:TextAlign.center,style: TextStyle(
            fontFamily: "SFPro",
            fontWeight: FontWeight.w400,
            letterSpacing: 0.38,
            color: Color(0xFFFF2D55),


        )),
        Text(year,style: TextStyle(
            fontFamily: "SFPro",
            fontWeight: FontWeight.w700,
            letterSpacing: 0.38,
            color: Color(0x993C3C43),
            fontSize: 11
        )),
        SizedBox(height: 8,),
        Row(
          children: [
            Expanded(
              child: BigButton(
                icon: Icons.play_arrow,
                label: "Play",
                onTap: () {
                  debugPrint("Clicked");
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: BigButton(
                icon: Icons.shuffle,
                label: "Shuffle",
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
