import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/writer_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/data/repositories/beats_repository.dart';

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
    musicController.loadBeat(beat);
    writerController.currentLyric.beatUrl = beat.songUrl;
  }

  void loadLyric(Lyric lyric) async {
    writerController.loadLyric(lyric);
    if (lyric.beatUrl.isEmpty) {
      musicController.setEmpty();
      return;
    }

    try {
      musicController.loadBeat(await BeatsRepository.to.getBeat(lyric.beatId));
    } catch (e) {
      musicController.setEmpty();
    }
    // try {
    //   beat = BeatsController.to.getBeatWithUrl(lyric.songUrl) ??
    //       Beat.fromSongUrl(lyric.songUrl);
    // } catch (e) {
    //   beat = Beat.fromSongUrl(lyric.songUrl);
    // }
    // musicController.loadBeat(beat);
  }
}
