import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';

class SplashController extends GetxController {
  SplashController();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 10), goHome);
  }

  void goHome() {
    Get.offAndToNamed(Routes.writing);
  }
}
