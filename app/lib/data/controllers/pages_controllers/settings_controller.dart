import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/utils/constants.dart';
import 'package:rap_edit/utils/utility_functions.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find<SettingsController>();

  late GetStorage box;

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  set isDarkMode(bool value) => _isDarkMode.value = value;

  final RxBool _isOnline = false.obs;
  bool get isOnline => _isOnline.value;
  set isOnline(bool value) => _isOnline.value = value;

  StreamSubscription<ConnectivityResult>? subscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    box = GetStorage(settingsStorageName);
    isOnline = isConnectionOnline(await (Connectivity().checkConnectivity()));
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      isOnline = isConnectionOnline(result);
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadSettings();
  }

  @override
  void onClose() {
    super.onClose();
    subscription?.cancel();
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
