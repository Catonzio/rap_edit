import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/models/beat.dart';

class MusicController extends GetxController {
  // final String baseUrl = "beats";
  Rx<Beat?> _beat = null.obs;
  Beat? get beat => _beat.value;
  set beat(Beat? value) {
    if (_beat.value == null) {
      _beat = value.obs;
    } else {
      _beat.value = value;
    }
  }

  final Rx<Duration> _currentPosition = Duration.zero.obs;
  Duration get currentPosition => _currentPosition.value;
  set currentPosition(Duration value) => _currentPosition.value = value;

  final Rx<Duration> _duration = Duration.zero.obs;
  Duration get duration => _duration.value;
  set duration(Duration value) => _duration.value = value;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    audioPlayer.onPositionChanged.listen((Duration duration) {
      currentPosition = duration;
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    beat = null;
    await audioPlayer.dispose();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await dispose();
  }

  Future<void> setSource(Beat beat, {bool isLocal = true}) async {
    if (isLocal) {
      await audioPlayer.setSource(AssetSource(beat.songUrl));
    } else {
      await audioPlayer.setSourceUrl(beat.songUrl);
    }
    this.beat = beat;
    duration = (await audioPlayer.getDuration()) ?? Duration.zero;
  }

  void play() {
    audioPlayer.resume();
  }

  void pause() {
    audioPlayer.pause();
  }

  void stop() {
    audioPlayer.stop();
  }

  void seek(Duration duration) {
    audioPlayer.seek(duration);
  }
}
