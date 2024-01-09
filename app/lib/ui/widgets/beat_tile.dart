import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/controllers/beat_preview_controller.dart';
import 'package:rap_edit/data/models/beat.dart';

class BeatTile extends StatelessWidget {
  final Beat beat;
  final Function() onTap;
  const BeatTile({super.key, required this.beat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final BeatPreviewController controller = Get.find<BeatPreviewController>();
    return Card(
        elevation: 1,
        margin: EdgeInsets.symmetric(
            horizontal: context.width * 0.05, vertical: context.height * 0.01),
        child: ListTile(
            title: Text(beat.title),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
            )));
  }
}
