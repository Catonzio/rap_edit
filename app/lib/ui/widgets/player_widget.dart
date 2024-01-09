import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/music_controller.dart';
import 'package:rap_edit/utils/extensions/duration_extension.dart';

class PlayerWidget extends StatelessWidget {
  final double width;

  const PlayerWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    double iconSize = Size(context.width, context.height).shortestSide * 0.05;
    return SizedBox(
        width: width,
        child: GetX<MusicController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.beat?.title ?? "No beat selected"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 8,
                    child: Slider(
                      value:
                          controller.currentPosition.inMilliseconds.toDouble(),
                      min: 0,
                      max: controller.duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        controller.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${controller.currentPosition.formattedDuration}/${controller.duration.formattedDuration}",
                    ),
                  )
                ],
              ),
              SizedBox(
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
                        onPressed: controller.beat != null
                            ? controller.backwardFiveSeconds
                            : null,
                        padding: EdgeInsets.zero,
                        tooltip: "Rewind 5 seconds",
                        icon: Icon(
                          Icons.keyboard_double_arrow_left_rounded,
                          size: iconSize,
                        )),
                    IconButton(
                        onPressed: controller.beat != null
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
                        onPressed: controller.beat != null
                            ? controller.forwardFiveSeconds
                            : null,
                        tooltip: "Forward 5 seconds",
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.keyboard_double_arrow_right_rounded,
                            size: iconSize)),
                    IconButton(
                        onPressed: controller.beat != null &&
                                (controller.isPlaying ||
                                    controller.currentPosition > Duration.zero)
                            ? controller.stop
                            : null,
                        tooltip: "Stop",
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.stop_rounded, size: iconSize)),
                  ],
                ),
              )
            ],
          );
        }));
  }
}
