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
    double iconSize = Size(width, height).shortestSide * 0.15;
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
                    Container(
                      // width: width * 0.4,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      // flex: 2,
                      child: Text(
                        controller
                            .sliderController.currentPosition.formattedDuration,
                      ),
                    ),
                    PlayerSliderWidget(
                      fullWidth: width * 0.63,
                      fullHeight: height * 0.4,
                      // value: (controller.sliderController.currentPosition.inMilliseconds
                      //         .toDouble() /
                      //     controller.sliderController.duration.inMilliseconds.toDouble()),
                      canMove: controller.isBeatLoaded,
                      onPositionChanged: (Duration duration) {
                        controller.sliderController.currentPosition = duration;
                      },
                    ),
                    Container(
                      // width: width * 0.4,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      // flex: 2,
                      child: Text(
                        controller.sliderController.duration.formattedDuration,
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
