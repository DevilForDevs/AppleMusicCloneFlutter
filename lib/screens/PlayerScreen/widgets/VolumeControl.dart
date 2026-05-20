import 'package:flutter/material.dart';

class VolumeControl extends StatelessWidget {

  const VolumeControl({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
  });

  final double volume;

  final Function(double value) onVolumeChanged;

  void updateVolume(double value) {

    double newValue = value;

    if (newValue < 0) newValue = 0;
    if (newValue > 100) newValue = 100;

    onVolumeChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [

          /// VOLUME DOWN
          GestureDetector(
            onTap: () => updateVolume(volume - 10),

            child: Image.asset(
              "assets/images/playerControls/dec.png",
              height: 34,
              width: 34,
            ),
          ),

          const SizedBox(width: 12),

          /// SLIDER
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(

                trackHeight: 2,

                activeTrackColor:
                const Color.fromRGBO(60, 60, 67, 0.7),

                inactiveTrackColor:
                const Color.fromRGBO(60, 60, 67, 0.18),

                thumbColor: Colors.white,

                overlayShape:
                SliderComponentShape.noOverlay,

                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
              ),

              child: Slider(
                value: volume,
                min: 0,
                max: 100,

                onChanged: (value) {
                  updateVolume(value);
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// VOLUME UP
          GestureDetector(
            onTap: () => updateVolume(volume + 10),

            child: Image.asset(
              "assets/images/playerControls/inc.png",
              height: 34,
              width: 34,
            ),
          ),
        ],
      ),
    );
  }
}