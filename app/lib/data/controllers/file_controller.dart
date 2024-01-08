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
    await GetStorage.init("Lyrics");
    box = GetStorage("Lyrics");
    isCreatingStorage = false;
  }

  Future<void> saveFile(Lyric lyric) async {
    await box.write(lyric.id, lyric.toJson());
  }

  Future<void> deleteFile(String id) async {
    await box.remove(id);
  }

  Future<Lyric> readFile(String id) async {
    final Map<String, dynamic> json = await box.read(id);
    return Lyric.fromJson(json);
  }

  Future<List<Lyric>> readAllFiles() async {
    return await box.getKeys().map((key) async => await readFile(key)).toList();
  }
}
