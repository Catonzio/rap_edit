import 'package:auto_size_text/auto_size_text.dart';
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

  double get posPerc => adjustNanWidth(currentPosition / duration);

  Duration get getStartDuration =>
      Duration(milliseconds: (startPosition * duration.inMilliseconds).toInt());

  Duration get getEndDuration =>
      Duration(milliseconds: (endPosition * duration.inMilliseconds).toInt());
}

class PlayerSliderWidget extends StatelessWidget {
  final double width;
  final double fullWidth;
  final double fullHeight;
  final double barHeight;
  final double limiterHeight;
  // final double value;
  final bool canMove;
  final double limiterWidth;
  final double percMinDistance;

  final Function(Duration) onPositionChanged;
  final Function() onReachEnd;

  const PlayerSliderWidget(
      {super.key,
      required this.fullWidth,
      required this.fullHeight,
      // required this.value,
      required this.canMove,
      required this.onPositionChanged,
      required this.onReachEnd,
      this.limiterWidth = 10})
      : barHeight = fullHeight / 4,
        limiterHeight = fullHeight / 2,
        width = fullWidth - limiterWidth * 2,
        percMinDistance = 0.10;

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerSliderController>(
      // init: PlayerSliderController(),
      // didChangeDependencies: (state) => print("Did change dependencies"),
      // didUpdateWidget: (oldWidget, state) => print("Did update widget"),
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
      top: (fullHeight - barHeight) / 2,
      left: limiterWidth * 2,
      width: width - limiterWidth * 2,
      height: barHeight * 2,
      child: Container(
        // color: Colors.grey,
        height: barHeight,
        color: Colors.grey[800],
      ),
    );
  }

  Positioned activeBar(PlayerSliderController controller) {
    return Positioned(
      top: (fullHeight - barHeight) / 2,
      height: barHeight * 1.3,
      left: controller.startPosition * width + limiterWidth * 2,
      width: (controller.endPosition - controller.startPosition) * width -
          limiterWidth * 2,
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
              width: (controller.posPerc - controller.startPosition) *
                  (width - limiterWidth * 2),
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
          onPanUpdate: !canMove
              ? null
              : (details) {
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
          width: limiterWidth * 3,
          height: limiterHeight,
          child: AutoSizeText(
            (controller.duration * controller.startPosition).formattedDuration,
            maxLines: 1,
          ))
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
          onPanUpdate: !canMove
              ? null
              : (details) {
                  rightLimiterPan(controller, details);
                },
          child: Container(
            color: Colors.red,
          ),
        ),
      ),
      Positioned(
          top: (fullHeight - limiterHeight) / 2 + limiterHeight,
          left: controller.endPosition * width - limiterWidth,
          width: limiterWidth * 3,
          height: limiterHeight,
          child: AutoSizeText(
            (controller.duration * controller.endPosition).formattedDuration,
            maxLines: 1,
          ))
    ];
  }

  void leftLimiterPan(
      PlayerSliderController controller, DragUpdateDetails details) {
    double newFraction = controller.startPosition + details.delta.dx / width;
    // limit distance between start and end
    newFraction =
        newFraction.clamp(0, controller.endPosition - percMinDistance);
    controller.startPosition = newFraction;

    // check if current position is less than start position
    Duration newDuration = controller.getStartDuration;
    if (controller.currentPosition < newDuration) {
      onPositionChanged(newDuration);
    }
  }

  void rightLimiterPan(
      PlayerSliderController controller, DragUpdateDetails details) {
    double newFraction = controller.endPosition + details.delta.dx / width;
    // limit distance between start and end
    newFraction =
        newFraction.clamp(controller.startPosition + percMinDistance, 1);
    controller.endPosition = newFraction;

    // check if current position is greater than end position
    Duration endDuration = controller.getEndDuration;
    if (controller.currentPosition > endDuration) {
      onReachEnd();
    }
  }

  void onTapDown(PlayerSliderController controller, TapDownDetails details) {
    double posPerc = details.localPosition.dx / (width - limiterWidth * 2) +
        controller.startPosition;
    // double posPerc = details.localPosition.dx /
    //         ((controller.endPosition - controller.startPosition) * width) +
    //     controller.startPosition;
    print("${details.localPosition.dx}, ${width - limiterWidth * 2}");
    print("$posPerc, ${controller.startPosition}, ${controller.endPosition}");
    controller.currentPosition = Duration(
        milliseconds: (posPerc * controller.duration.inMilliseconds).toInt());
    onPositionChanged(controller.currentPosition);
  }

  void onPanUpdate(
      PlayerSliderController controller, DragUpdateDetails details) {
    double newFraction = controller.currentPosition / controller.duration +
        details.delta.dx / (width - limiterWidth * 2);
    newFraction =
        newFraction.clamp(controller.startPosition, controller.endPosition);

    controller.currentPosition = Duration(
        milliseconds:
            (newFraction * controller.duration.inMilliseconds).toInt());

    onPositionChanged(controller.currentPosition);
  }
}
