import 'dart:async';

import 'package:get/get.dart';

class RecorderController extends GetxController {
  static final RecorderController to = Get.find<RecorderController>();

  static const Duration countdownDuration = Duration(seconds: 3);

  final RxBool _isRecording = false.obs;
  bool get isRecording => _isRecording.value;
  set isRecording(bool value) => _isRecording.value = value;

  final Rx<Duration> _countdown = Duration.zero.obs;
  Duration get countdown => _countdown.value;
  set countdown(Duration value) => _countdown.value = value;

  final Rx<Duration> _counter = Duration.zero.obs;
  Duration get counter => _counter.value;
  set counter(Duration value) => _counter.value = value;

  Timer? counterTimer;
  Timer? countdownTimer;

  void startRecording() {
    const oneSecond = Duration(seconds: 1);
    counterTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown < countdownDuration) {
        countdown = countdown + oneSecond;
      } else {
        isRecording = true;
        counter = counter + oneSecond;
      }
    });
    // countdownTimer = Timer(const Duration(seconds: countdownDuration), () {
    //   counterTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //     counter = counter + const Duration(seconds: 1);
    //   });
    //   isRecording = true;
    // });
  }

  void stopRecording() {
    countdownTimer?.cancel();
    countdownTimer = null;
    counterTimer?.cancel();
    counterTimer = null;
    counter = Duration.zero;
    countdown = Duration.zero;
    isRecording = false;
  }
}
