import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/file_controller.dart';
import 'package:rap_edit/data/controllers/writer_controller.dart';
import 'package:rap_edit/data/models/lyric.dart';

class LyricsController extends GetxController {
  final FileController fileController = Get.find<FileController>();

  final RxBool _isLoadingLyrics = false.obs;
  bool get isLoadingLyrics => _isLoadingLyrics.value;
  set isLoadingLyrics(bool value) => _isLoadingLyrics.value = value;

  final RxList<Lyric> _lyrics = <Lyric>[].obs;
  List<Lyric> get lyrics => _lyrics;
  set lyrics(List<Lyric> value) => _lyrics.value = value;

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
      Get.find<WriterController>().loadLyric(lyrics[index]);
    }
  }

  void deleteLyric(int index) {
    fileController.deleteFile(lyrics[index].id);
    lyrics.removeAt(index);
  }
}
