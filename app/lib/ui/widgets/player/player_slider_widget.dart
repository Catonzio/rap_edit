import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/utils/extensions/duration_extension.dart';
import 'package:rap_edit/utils/utility_functions.dart';

class PlayerSliderController extends GetxController {
  static PlayerSliderController get to => Get.find<PlayerSliderController>();

  final Rx<Duration> _currentPosition = Duration.zero.obs;
  Duration get currentPosition => _currentPosition.value;
  set currentPosition(Duration value) => _currentPosition.value = value;

  final Rx<Duration> _duration = Duration.zero.obs;
  Duration get duration => _duration.value;
  set duration(Duration value) => _duration.value = value;

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
  final double fullWidth;
  final double fullHeight;
  final double height;
  final double limiterHeight;
  // final double value;
  final bool canMove;

  final Function(Duration) onPositionChanged;

  final double limiterWidth;

  const PlayerSliderWidget(
      {super.key,
      required this.fullWidth,
      required this.fullHeight,
      // required this.value,
      required this.canMove,
      required this.onPositionChanged,
      this.limiterWidth = 10})
      : height = fullHeight / 4,
        limiterHeight = fullHeight / 2,
        width = fullWidth - limiterWidth * 2;

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerSliderController>(
      // init: PlayerSliderController(),
      builder: (controller) {
        return Container(
          color: Colors.green,
          width: fullWidth,
          height: fullHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundBar(),
              activeBar(controller),
              // Start slider
              ...leftSlider(controller),
              // End slider
              ...rightSlider(controller),
            ],
          ),
        );
      },
    );
  }

  Positioned backgroundBar() {
    return Positioned(
      top: (fullHeight - height) / 2,
      left: limiterWidth,
      width: width,
      height: height,
      child: Container(
        // color: Colors.grey,
        height: height,
        color: Colors.grey[800],
      ),
    );
  }

  Positioned activeBar(PlayerSliderController controller) {
    return Positioned(
      top: (fullHeight - height) / 2,
      height: height,
      left: controller.startPosition * width + limiterWidth,
      width: (controller.endPosition - controller.startPosition) *
          (width - limiterWidth * 2),
      child: GestureDetector(
        onPanUpdate: (details) => onPanUpdate(controller, details),
        onTapDown: (details) => onTapDown(controller, details),
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
              width: (adjustNanWidth(
                          controller.currentPosition / controller.duration) -
                      controller.startPosition) *
                  (width + limiterWidth),
              child: Container(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Positioned> leftSlider(PlayerSliderController controller) {
    return [
      Positioned(
        top: (fullHeight - limiterHeight) / 2,
        left: controller.startPosition * width + limiterWidth,
        width:
            limiterWidth, // (controller.endPosition - controller.startPosition) * width,
        height: limiterHeight,
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
      Positioned(
          top: (fullHeight - limiterHeight) / 2 + limiterHeight,
          left: controller.startPosition * width,
          width: limiterWidth * 10,
          height: limiterHeight,
          child: Text((controller.duration * controller.startPosition)
              .formattedDuration))
    ];
  }

  List<Positioned> rightSlider(PlayerSliderController controller) {
    return [
      Positioned(
        top: (fullHeight - limiterHeight) / 2,
        left: controller.endPosition * width,
        width: limiterWidth,
        height: limiterHeight,
        child: GestureDetector(
          onPanUpdate: (details) {
            rightLimiterPan(controller, details);
          },
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
      Positioned(
          top: (fullHeight - limiterHeight) / 2 + limiterHeight,
          left: controller.endPosition * width - limiterWidth * 2,
          width: limiterWidth * 10,
          height: limiterHeight,
          child: Text(
              (controller.duration * controller.endPosition).formattedDuration))
    ];
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

  void onTapDown(PlayerSliderController controller, TapDownDetails details) {
    controller.currentPosition = Duration(
        milliseconds: (details.localPosition.dx /
                width *
                controller.duration.inMilliseconds)
            .toInt());
    onPositionChanged(controller.currentPosition);
  }

  void onPanUpdate(
      PlayerSliderController controller, DragUpdateDetails details) {
    double newFraction = controller.currentPosition / controller.duration +
        details.delta.dx / width;
    newFraction =
        newFraction.clamp(controller.startPosition, controller.endPosition);

    controller.currentPosition = Duration(
        milliseconds:
            (newFraction * controller.duration.inMilliseconds).toInt());

    onPositionChanged(controller.currentPosition);
  }
}
