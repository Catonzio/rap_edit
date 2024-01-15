import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/writer_controller.dart';
import 'package:rap_edit/data/controllers/pages_controllers/beats_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/models/lyric.dart';

class HomeController extends GetxController {
  static final HomeController to = Get.find<HomeController>();

  final MusicController musicController;
  final WriterController writerController;

  HomeController(
      {required this.musicController, required this.writerController});

  void pauseSong() {
    musicController.pause();
  }

  void setSong(Beat beat) {
    musicController.setSource(beat);
    writerController.currentLyric.songUrl = beat.songUrl;
  }

  void loadLyric(Lyric lyric) {
    writerController.currentLyric = lyric;
    if (lyric.songUrl.isEmpty) {
      
      return;
    }
    Beat beat;
    try {
      beat = BeatsController.to.getBeatWithUrl(lyric.songUrl) ??
          Beat.fromSongUrl(lyric.songUrl);
    } catch (e) {
      print(e.runtimeType);
      beat = Beat.fromSongUrl(lyric.songUrl);
    }
    musicController.setSource(beat);
  }
}
