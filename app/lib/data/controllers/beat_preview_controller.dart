import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class BeatPreviewController extends GetxController {
  static BeatPreviewController get to => Get.find<BeatPreviewController>();
  
  final RxString _sourceName = "".obs;
  String get sourceName => _sourceName.value;
  set sourceName(String value) => _sourceName.value = value;

  bool isPlaying(String sourceUrl) => sourceName == sourceUrl;

  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    pause();
  }

  @override
  InternalFinalCallback<void> get onDelete {
    pause();
    return super.onDelete;
  }

  void play(String url) {
    sourceName = url;
    player.play(AssetSource(url), mode: PlayerMode.lowLatency);
  }

  void pause() {
    sourceName = "";
    player.release();
  }
}
