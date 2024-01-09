import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/pages_controllers/recordings_controller.dart';

class RecordingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordingsController>(() => RecordingsController());
  }
}