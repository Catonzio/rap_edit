import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/utils/constants.dart';

class BeatFileController extends GetxController {
  static BeatFileController get to => Get.find<BeatFileController>();

  final RxBool _isCreatingStorage = false.obs;
  bool get isCreatingStorage => _isCreatingStorage.value;
  set isCreatingStorage(bool value) => _isCreatingStorage.value = value;

  late GetStorage box;

  @override
  Future<void> onInit() async {
    super.onInit();
    isCreatingStorage = true;
    box = GetStorage(beatsStorageName);
    isCreatingStorage = false;
  }

  Future<bool> saveBeat(Beat beat) async {
    try {
      await box.write(beat.id, beat.toJson());
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<bool> saveBeats(List<Beat> beats) async {
    try {
      for (Beat beat in beats) {
        await box.write(beat.id, beat.toJson());
      }
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<bool> deleteBeat(String id) async {
    try {
      await box.remove(id);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<Beat> readBeat(String id) async {
    final Map<String, dynamic> json = await box.read(id);
    return Beat.fromJson(json);
  }

  Future<List<Beat>> readAllBeats() async {
    List<String> keys = box.getKeys().toList();
    List<Beat> l = <Beat>[];

    for (String k in keys) {
      l.add(await readBeat(k));
    }

    return l;
  }
}
