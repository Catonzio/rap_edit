import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/beat_preview_controller.dart';
import 'package:rap_edit/data/controllers/beats_controller.dart';

class BeatsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeatsController>(() => BeatsController());
    Get.lazyPut<BeatPreviewController>(() => BeatPreviewController());
  }
}
