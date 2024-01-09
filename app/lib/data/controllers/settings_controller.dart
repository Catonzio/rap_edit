import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/utils/constants.dart';

class SettingsController extends GetxController {
  late GetStorage box;

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  set isDarkMode(bool value) => _isDarkMode.value = value;

  @override
  Future<void> onInit() async {
    super.onInit();
    box = GetStorage(settingsStorageName);
  }

  Future<bool> saveSetting(String key, dynamic value) async {
    try {
      await box.write(key, value);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }
}
