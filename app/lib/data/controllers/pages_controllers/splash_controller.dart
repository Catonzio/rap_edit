import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/pages_controllers/settings_controller.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find<SplashController>();

  SplashController();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100), () {
      SettingsController.to.loadSettings();
      goHome();
    });
  }

  void goHome() {
    Get.offNamedUntil(Routes.writing, ModalRoute.withName(Routes.writing));
    // Get.offNamed(Routes.writing);
  }
}
