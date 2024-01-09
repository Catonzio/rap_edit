import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/domain_controllers/file_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/writer_controller.dart';
import 'package:rap_edit/data/models/lyric.dart';

class LyricsController extends GetxController {
  final FileController fileController = FileController.to;

  final RxBool _isLoadingLyrics = false.obs;
  bool get isLoadingLyrics => _isLoadingLyrics.value;
  set isLoadingLyrics(bool value) => _isLoadingLyrics.value = value;

  final RxList<Lyric> _lyrics = <Lyric>[].obs;
  List<Lyric> get lyrics => _lyrics;
  set lyrics(List<Lyric> value) => _lyrics.value = value;

  Function() _disposeListen = () {};

  @override
  void onReady() {
    super.onReady();
    loadLyrics();
    _disposeListen = fileController.box.listen(() => loadLyrics());
  }

  @override
  void onClose() {
    super.onClose();
    _disposeListen.call();
  }

  void loadLyrics() async {
    isLoadingLyrics = true;
    lyrics = await fileController.readAllFiles();
    isLoadingLyrics = false;
  }

  void loadLyric(int index) {
    if (lyrics.isEmpty) {
      loadLyrics();
    }
    if (index < lyrics.length) {
      Get.toNamed(Routes.writing);
      WriterController.to.loadLyric(lyrics[index]);
    }
  }

  void deleteLyric(int index) {
    fileController.deleteFile(lyrics[index].id);
    lyrics.removeAt(index);
  }
}
