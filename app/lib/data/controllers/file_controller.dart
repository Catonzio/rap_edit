import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/data/models/lyric.dart';

class FileController extends GetxController {
  final RxBool _isCreatingStorage = false.obs;
  bool get isCreatingStorage => _isCreatingStorage.value;
  set isCreatingStorage(bool value) => _isCreatingStorage.value = value;

  late GetStorage box;

  @override
  Future<void> onInit() async {
    super.onInit();
    isCreatingStorage = true;
    box = GetStorage("Lyrics");
    isCreatingStorage = false;
  }

  StreamSubscription<bool> addCreatingStorageListener(
      void Function(bool) listener,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) {
    return _isCreatingStorage.listen(listener);
  }

  Future<bool> saveFile(Lyric lyric) async {
    try {
      await box.write(lyric.id, lyric.toJson());
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<bool> deleteFile(String id) async {
    try {
      await box.remove(id);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  Future<Lyric> readFile(String id) async {
    final Map<String, dynamic> json = await box.read(id);
    return Lyric.fromJson(json);
  }

  Future<List<Lyric>> readAllFiles() async {
    List<String> keys = box.getKeys().toList();
    List<Lyric> l = <Lyric>[];

    for (String k in keys) {
      l.add(await readFile(k));
    }

    return l;
  }
}
