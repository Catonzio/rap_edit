import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/utils/constants.dart';

class LyricFileController extends GetxController {
  static LyricFileController get to => Get.find<LyricFileController>();

  final RxBool _isCreatingStorage = false.obs;
  bool get isCreatingStorage => _isCreatingStorage.value;
  set isCreatingStorage(bool value) => _isCreatingStorage.value = value;

  late GetStorage box;

  @override
  Future<void> onInit() async {
    super.onInit();
    isCreatingStorage = true;
    box = GetStorage(lyricsStorageName);
    isCreatingStorage = false;
  }

  Future<bool> saveLyric(Lyric lyric) async {
    try {
      await box.write(lyric.id, lyric.toJson());
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<bool> deleteLyric(String id) async {
    try {
      await box.remove(id);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<Lyric> readLyric(String id) async {
    final Map<String, dynamic> json = await box.read(id);
    return Lyric.fromJson(json);
  }

  Future<List<Lyric>> readAllLyrics() async {
    List<String> keys = box.getKeys().toList();
    List<Lyric> l = <Lyric>[];

    for (String k in keys) {
      l.add(await readLyric(k));
    }

    return l;
  }
}
