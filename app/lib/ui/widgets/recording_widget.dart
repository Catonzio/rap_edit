import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/record_controller.dart';
import 'package:rap_edit/utils/extensions/duration_extension.dart';

class RecordingWidget extends StatelessWidget {
  final double width;
  final double height;

  const RecordingWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    double circleInnerFraction = 0.8;
    double squareInnerFraction = 0.65;
    return GetX<RecorderController>(
      builder: (controller) {
        return SizedBox(
          width: width * 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // if it's counting down, don't do anything
                  if (controller.isCountingDown) return;
                  controller.isRecording
                      ? controller.stopRecording()
                      : controller.startRecording();
                },
                child: Stack(
                  children: [
                    Container(
                      width: width,
                      height: height,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    controller.isRecording
                        ? Positioned(
                            top: height * (1 - squareInnerFraction) / 2,
                            left: width * (1 - squareInnerFraction) / 2,
                            child: SquareContainer(
                              width: width * squareInnerFraction,
                              height: height * squareInnerFraction,
                            ),
                          )
                        : Positioned(
                            top: height * (1 - circleInnerFraction) / 2,
                            left: width * (1 - circleInnerFraction) / 2,
                            child: CircularContainer(
                              width: width * circleInnerFraction,
                              height: height * circleInnerFraction,
                            ),
                          ),
                    controller.isCountingDown
                        ? Positioned(
                            top: height / 2 - 10,
                            left: width / 2 - 5,
                            child: AutoSizeText(
                              "${(RecorderController.countdownDuration - controller.countdown).inSeconds + 1}",
                              maxLines: 1,
                            ))
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              Obx(() => AutoSizeText(
                    controller.counter.formattedDuration,
                    maxLines: 1,
                  ))
            ],
          ),
        );
      },
    );
  }
}

class CircularContainer extends StatelessWidget {
  final double width;
  final double height;

  const CircularContainer(
      {super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}

class SquareContainer extends StatelessWidget {
  final double width;
  final double height;

  const SquareContainer({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.red,
        ));
  }
}
