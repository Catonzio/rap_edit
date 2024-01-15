import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/models/beat.dart';

class MusicController extends GetxController {
  static MusicController get to => Get.find<MusicController>();

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

  final RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool value) => _isPlaying.value = value;

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

  void setEmpty() {
    beat = null;
    duration = Duration.zero;
    audioPlayer.release();
  }

  void play() {
    isPlaying = true;
    audioPlayer.resume();
  }

  void pause() {
    isPlaying = false;
    audioPlayer.pause();
  }

  void stop() {
    isPlaying = false;
    audioPlayer.stop();
  }

  void forwardFiveSeconds() {
    Duration newDuration = currentPosition + const Duration(seconds: 5);
    if (newDuration < duration) {
      seek(newDuration);
    }
  }

  void backwardFiveSeconds() {
    Duration newDuration = currentPosition - const Duration(seconds: 5);
    if (newDuration > Duration.zero) {
      seek(newDuration);
    }
  }

  void seek(Duration duration) {
    audioPlayer.seek(duration);
  }
}
