import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/record_controller.dart';

class RecorderBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecorderController>(() => RecorderController());
  }
}
