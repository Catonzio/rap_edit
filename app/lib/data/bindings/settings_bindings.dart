import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/settings_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}