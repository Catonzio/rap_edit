import 'package:get/get.dart';
import 'package:rap_edit/data/bindings/settings_bindings.dart';
import 'package:rap_edit/data/controllers/domain_controllers/beat_file_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/lyric_file_controller.dart';
import 'package:rap_edit/data/controllers/pages_controllers/splash_controller.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    SettingsBindings().dependencies();
    Get.lazyPut(() => LyricFileController(), fenix: true);
    Get.lazyPut(() => BeatFileController(), fenix: true);
    Get.put(SplashController());
  }
}
