import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/file_controller.dart';

class SplashController extends GetxController {
  SplashController();
  @override
  void onInit() {
    super.onInit();
    FileController fileController = Get.find<FileController>();
    while(fileController.isCreatingStorage) {
      print("Creating storage...");
    }
    Future.delayed(const Duration(milliseconds: 10), () => goHome());
  }

  void goHome() {
    Get.offAndToNamed(Routes.writing);
  }
}
