import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/file_controller.dart';
import 'package:rap_edit/data/controllers/splash_controller.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => SplashController());
    Get.lazyPut(() => FileController(), fenix: true);
    Get.put(SplashController());
  }
}
