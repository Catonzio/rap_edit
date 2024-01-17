import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';

class ButtonsRow extends StatelessWidget {
  const ButtonsRow({
    super.key,
    required this.width,
    required this.iconSize,
  });

  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GetX<MusicController>(
      builder: (controller) {
        return SizedBox(
          width: width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: null,
                  padding: EdgeInsets.zero,
                  tooltip: "Wheter replay or not",
                  icon: Icon(
                    Icons.replay_rounded,
                    size: iconSize,
                  )),
              IconButton(
                  onPressed: controller.isBeatLoaded &&
                          controller.currentPosition >
                              const Duration(seconds: 5)
                      ? controller.backwardFiveSeconds
                      : null,
                  padding: EdgeInsets.zero,
                  tooltip: "Rewind 5 seconds",
                  icon: Icon(
                    Icons.keyboard_double_arrow_left_rounded,
                    size: iconSize,
                  )),
              IconButton(
                  onPressed: controller.isBeatLoaded
                      ? (controller.isPlaying
                          ? controller.pause
                          : controller.play)
                      : null,
                  padding: EdgeInsets.zero,
                  tooltip: controller.isPlaying ? "Pause" : "Play",
                  icon: Icon(
                      controller.isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      size: iconSize * 2)),
              IconButton(
                  onPressed: controller.isBeatLoaded &&
                          controller.currentPosition <
                              controller.duration - const Duration(seconds: 5)
                      ? controller.forwardFiveSeconds
                      : null,
                  tooltip: "Forward 5 seconds",
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.keyboard_double_arrow_right_rounded,
                      size: iconSize)),
              IconButton(
                  onPressed: controller.isBeatLoaded &&
                          (controller.isPlaying ||
                              controller.currentPosition > Duration.zero)
                      ? controller.stop
                      : null,
                  tooltip: "Stop",
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.stop_rounded, size: iconSize)),
            ],
          ),
        );
      },
    );
  }
}
