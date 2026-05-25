import 'dart:io';
import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key, required this.onBackPress});
  final VoidCallback onBackPress;

  @override
  Widget build(BuildContext context) {
    bool isWindows = Platform.isWindows;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isWindows)
          IconButton(
            onPressed: onBackPress,
            icon: const Icon(Icons.chevron_left, color: Color(0xFFFF2D55)),
          ),
        Text(
          "Listen Now",
          style: const TextStyle(
            color: Color(0xFFFF2D55),
            fontFamily: "SFPro",
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
