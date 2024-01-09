import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/controllers/domain_controllers/beat_preview_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/ui/widgets/tiles/basic_tile.dart';

class BeatTile extends StatelessWidget {
  final Beat beat;
  final Function() onTap;
  const BeatTile({super.key, required this.beat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final BeatPreviewController controller = BeatPreviewController.to;
    return BasicTile(
        title: Text(beat.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.upload_rounded),
              color: Themes.yellow,
            ),
            Obx(() => IconButton(
                  onPressed: () => controller.isPlaying(beat.songUrl)
                      ? controller.pause()
                      : controller.play(beat.songUrl),
                  icon: Icon(controller.isPlaying(beat.songUrl)
                      ? Icons.pause
                      : Icons.play_arrow),
                  color: Themes.blue,
                )),
          ],
        ));
  }
}
