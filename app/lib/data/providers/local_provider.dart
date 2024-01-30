import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

mixin LocalProvider {
  final RxBool _isCreatingStorage = false.obs;
  bool get isCreatingStorage => _isCreatingStorage.value;
  set isCreatingStorage(bool value) => _isCreatingStorage.value = value;

  late GetStorage box;

  Future<void> initStorage(String storageName) async {
    isCreatingStorage = true;
    box = GetStorage(storageName);
    isCreatingStorage = false;
  }
}
