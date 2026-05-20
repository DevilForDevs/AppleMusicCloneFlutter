import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onForward,
    required this.onBackward,
  });

  final bool isPlaying;

  final VoidCallback onPlayPause;
  final VoidCallback onForward;
  final VoidCallback onBackward;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          /// BACKWARD
          GestureDetector(
            onTap: onBackward,

            child: Image.asset(
              "assets/images/playerControls/backward.png",
              height: 50,
              width: 50,
            ),
          ),

          const SizedBox(width: 20),

          /// PLAY / PAUSE
          GestureDetector(
            onTap: onPlayPause,

            child: Image.asset(
              isPlaying
                  ? "assets/images/playerControls/pause.png"
                  : "assets/images/playerControls/play.png",

              height: 50,
              width: 50,
            ),
          ),

          const SizedBox(width: 20),

          /// FORWARD
          GestureDetector(
            onTap: onForward,

            child: Image.asset(
              "assets/images/playerControls/forward.png",
              height: 50,
              width: 50,
            ),
          ),
        ],
      ),
    );
  }
}