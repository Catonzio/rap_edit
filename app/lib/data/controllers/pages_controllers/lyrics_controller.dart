import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/domain_controllers/lyric_file_controller.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/data/models/lyric.dart';

class LyricsController extends GetxController {
  final LyricFileController fileController = LyricFileController.to;

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
    fetchLyrics();
    _disposeListen = fileController.box.listen(() => fetchLyrics());
  }

  @override
  void onClose() {
    super.onClose();
    _disposeListen.call();
  }

  void fetchLyrics() async {
    isLoadingLyrics = true;
    lyrics = await fileController.readAllLyrics();
    isLoadingLyrics = false;
  }

  void loadLyric(int index) {
    if (lyrics.isEmpty) {
      fetchLyrics();
    }
    if (index < lyrics.length) {
      Get.offAndToNamed(Routes.writing);
      HomeController.to.loadLyric(lyrics[index]);
    }
  }

  void deleteLyric(int index) {
    fileController.deleteLyric(lyrics[index].id);
    lyrics.removeAt(index);
  }
}
