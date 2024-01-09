import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/utils/constants.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find<SettingsController>();

  late GetStorage box;

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  set isDarkMode(bool value) => _isDarkMode.value = value;

  @override
  Future<void> onInit() async {
    super.onInit();
    box = GetStorage(settingsStorageName);
  }

  @override
  void onReady() {
    super.onReady();
    loadSettings();
  }

  void loadSettings() {
    setIsDarkMode(box.read("isDarkMode") ?? Get.isDarkMode);
  }

  Future<bool> saveSetting() async {
    try {
      await box.write("isDarkMode", isDarkMode);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  void setIsDarkMode(bool value) {
    isDarkMode = value;
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
