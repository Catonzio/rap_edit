import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/music_controller.dart';
import 'package:rap_edit/utils/extensions/duration_extension.dart';

class PlayerWidget extends StatelessWidget {
  final MusicController controller = Get.find<MusicController>();
  final double width;

  PlayerWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: GetX<MusicController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.sourceName),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 9,
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
                    flex: 1,
                    child: Text(
                      "${controller.currentPosition.formattedDuration}/${controller.duration.formattedDuration}",
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => controller.play(),
                      child: const Text("Play")),
                  ElevatedButton(
                      onPressed: () => controller.pause(),
                      child: const Text("Pause")),
                  ElevatedButton(
                      onPressed: () => controller.stop(),
                      child: const Text("Stop")),
                ],
              )
            ],
          );
        }));
  }
}
