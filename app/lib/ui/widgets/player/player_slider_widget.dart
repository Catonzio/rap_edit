import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/utils/utility_functions.dart';

class PlayerSliderController extends GetxController {
  static PlayerSliderController get to => Get.find<PlayerSliderController>();

  // final Rx<Duration> _currentPosition = Duration.zero.obs;
  // Duration get currentPosition => _currentPosition.value;
  // set currentPosition(Duration value) => _currentPosition.value = value;

  // final Rx<Duration> _duration = Duration.zero.obs;
  // Duration get duration => _duration.value;
  // set duration(Duration value) => _duration.value = value;

  final RxDouble _startPosition = 0.0.obs;
  double get startPosition => _startPosition.value;
  set startPosition(double value) => _startPosition.value = value;

  final RxDouble _endPosition = 1.0.obs;
  double get endPosition => _endPosition.value;
  set endPosition(double value) => _endPosition.value = value;

  // double get sliderFraction => duration == Duration.zero
  //     ? 0
  //     : currentPosition.inMilliseconds.toDouble() /
  //         duration.inMilliseconds.toDouble();
}

class PlayerSliderWidget extends StatelessWidget {
  final double width;
  final double fullHeight;
  final double height;
  final double value;
  final bool canMove;

  final double limiterWidth;

  const PlayerSliderWidget(
      {super.key,
      required this.width,
      required this.fullHeight,
      required this.value,
      required this.canMove,
      this.limiterWidth = 10})
      : height = fullHeight / 2;

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerSliderController>(
      init: PlayerSliderController(),
      builder: (controller) {
        return Stack(
          children: [
            Container(
              // color: Colors.grey,
              height: height,
              width: width,
              alignment: Alignment.center,
              child: Container(
                color: Colors.grey[800],
                height: (fullHeight - height) / 2,
              ),
            ),
            Positioned(
              top: (fullHeight - height) / 4,
              bottom: (fullHeight - height) / 4,
              left: controller.startPosition * width,
              right: (1 - controller.endPosition) * width,
              child: GestureDetector(
                onPanUpdate: (details) {},
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Colors.grey[300],
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      width: adjustNanWidth(value * width),
                      child: Container(
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Start slider
            Positioned(
              top: 0,
              left: controller.startPosition * width,
              width:
                  limiterWidth, // (controller.endPosition - controller.startPosition) * width,
              height: fullHeight,
              child: GestureDetector(
                onPanUpdate: (details) {
                  leftLimiterPan(controller, details);
                },
                child: Container(
                  color: Colors.purple,
                  width: limiterWidth,
                ),
              ),
            ),
            // End slider
            Positioned(
              top: 0,
              left: controller.endPosition * width - limiterWidth,
              width: limiterWidth,
              height: fullHeight,
              child: GestureDetector(
                onTapDown: (details) => print(controller.endPosition),
                onPanUpdate: (details) {
                  rightLimiterPan(controller, details);
                },
                child: Container(
                  color: Colors.red,
                  width: limiterWidth,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void leftLimiterPan(
      PlayerSliderController controller, DragUpdateDetails details) {
    if (!canMove) return;
    double newFraction = controller.startPosition + details.delta.dx / width;
    newFraction = newFraction.clamp(
        0, controller.endPosition - limiterWidth / width * 10);
    controller.startPosition = newFraction;
  }

  void rightLimiterPan(
      PlayerSliderController controller, DragUpdateDetails details) {
    if (!canMove) return;
    double newFraction = controller.endPosition + details.delta.dx / width;
    newFraction = newFraction.clamp(
        controller.startPosition + limiterWidth / width * 10, 1);
    controller.endPosition = newFraction;
  }

  // void onTapDown(PlayerSliderController controller, TapDownDetails details) {
  //   controller.currentPosition = Duration(
  //       milliseconds: (details.localPosition.dx /
  //               width *
  //               controller.duration.inMilliseconds)
  //           .toInt());
  // }

  // void onPanUpdate(
  //     PlayerSliderController controller, DragUpdateDetails details) {
  //   double newFraction = controller.sliderFraction + details.delta.dx / width;
  //   if (newFraction < 0) {
  //     newFraction = 0;
  //   } else if (newFraction > 1) {
  //     newFraction = 1;
  //   }
  //   controller.currentPosition = Duration(
  //       milliseconds:
  //           (newFraction * controller.duration.inMilliseconds).toInt());
  // }
}
