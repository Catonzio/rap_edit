import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/utils/enums.dart';

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

  double get sliderFraction => duration == Duration.zero
      ? 0
      : currentPosition.inMilliseconds.toDouble() /
          duration.inMilliseconds.toDouble();

  final RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool value) => _isPlaying.value = value;

  final RxBool _isLooping = false.obs;
  bool get isLooping => _isLooping.value;
  set isLooping(bool value) => _isLooping.value = value;

  final RxBool _isLoadingBeat = false.obs;
  bool get isLoadingBeat => _isLoadingBeat.value;
  set isLoadingBeat(bool value) => _isLoadingBeat.value = value;

  bool get isBeatLoaded => beat != null && !isLoadingBeat;

  final AudioPlayer audioPlayer = AudioPlayer();

  MusicController();

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

  Future<void> loadBeat(Beat beat) async {
    isLoadingBeat = true;
    switch (beat.sourceType) {
      case SourceType.asset:
        await audioPlayer.setSource(AssetSource(beat.songUrl));
        break;
      case SourceType.url:
        await audioPlayer.setSource(UrlSource(beat.songUrl));
        break;
      case SourceType.file:
        await audioPlayer.setSource(DeviceFileSource(beat.songUrl));
        break;
    }

    this.beat = beat;
    duration = (await audioPlayer.getDuration()) ?? Duration.zero;
    isLoadingBeat = false;
  }

  void setEmpty() {
    isLoadingBeat = false;
    beat = null;
    duration = Duration.zero;
    // duration = Duration.zero;
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
