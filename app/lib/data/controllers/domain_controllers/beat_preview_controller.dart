import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:rap_edit/utils/enums.dart';

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

  void play(String url, SourceType sourceType) {
    sourceName = url;
    Source source = sourceType == SourceType.asset
        ? AssetSource(url)
        : DeviceFileSource(url);
    player.play(source, mode: PlayerMode.lowLatency);
  }

  void pause() {
    sourceName = "";
    player.release();
  }
}
