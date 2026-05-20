import 'package:flutter/material.dart';

import '../utils/timeformattor.dart';

class ProgressInfoView extends StatelessWidget {
  const ProgressInfoView({
    super.key,
    required this.totalSeconds,
    required this.passedSeconds,
    required this.onChanged,
  });

  final double totalSeconds;
  final double passedSeconds;

  final Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {

    final safeProgress = passedSeconds.clamp(
      0.0,
      totalSeconds <= 0 ? 0.0 : totalSeconds,
    );

    final remaining =
    (totalSeconds - passedSeconds)
        .clamp(0.0, totalSeconds);

    return Column(
      children: [

        /// SLIDER
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,

            activeTrackColor:
            const Color.fromRGBO(
              60,
              60,
              67,
              0.7,
            ),

            inactiveTrackColor:
            const Color.fromRGBO(
              60,
              60,
              67,
              0.18,
            ),

            thumbColor: Colors.black,

            overlayShape:
            SliderComponentShape.noOverlay,

            thumbShape:
            const RoundSliderThumbShape(
              enabledThumbRadius: 4,
            ),
          ),

          child: Slider(
            value: safeProgress,

            min: 0,

            max: totalSeconds <= 0
                ? 1
                : totalSeconds,

            onChanged: onChanged,
          ),
        ),

        /// TIME ROW
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            Text(
              formatTime(passedSeconds),

              style: const TextStyle(
                fontSize: 12,

                color: Color.fromRGBO(
                  60,
                  60,
                  67,
                  0.6,
                ),
              ),
            ),

            Text(
              "-${formatTime(remaining)}",

              style: const TextStyle(
                fontSize: 12,

                color: Color.fromRGBO(
                  60,
                  60,
                  67,
                  0.6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}