import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';

import 'package:rap_edit/ui/widgets/player/buttons_row.dart';
import 'package:rap_edit/ui/widgets/player/player_slider_widget.dart';
import 'package:rap_edit/utils/extensions/duration_extension.dart';

class PlayerWidget extends StatelessWidget {
  final double height;
  final double width;

  const PlayerWidget({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    double iconSize = Size(context.width, context.height).shortestSide * 0.05;
    return SizedBox(
        height: height,
        width: width,
        child: GetX<MusicController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: controller.isLoadingBeat
                    ? SizedBox(
                        width: width / 3,
                        child: const LinearProgressIndicator())
                    : AutoSizeText(
                        controller.beat?.title ?? "No beat selected",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              Expanded(
                // height: height * 0.1,
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => PlayerSliderWidget(
                          width: width * 0.75,
                          fullHeight: height * 0.2,
                          value: (controller.currentPosition.inMilliseconds
                                  .toDouble() /
                              controller.duration.inMilliseconds.toDouble()),
                          canMove: controller.isBeatLoaded,
                        )),
                    Container(
                      width: width * 0.25,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      // flex: 2,
                      child: Text(
                        "${controller.currentPosition.formattedDuration}/${controller.duration.formattedDuration}",
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ButtonsRow(width: width, iconSize: iconSize),
              )
            ],
          );
        }));
  }
}
