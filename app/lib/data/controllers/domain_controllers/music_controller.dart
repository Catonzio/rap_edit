import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/ui/widgets/player/player_slider_widget.dart';
import 'package:rap_edit/utils/enums.dart';
// import 'package:rap_edit/utils/utility_functions.dart';

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

  final PlayerSliderController sliderController = PlayerSliderController.to;

  // final Rx<Duration> _sliderController.currentPosition = Duration.zero.obs;
  // Duration get sliderController.currentPosition => _sliderController.currentPosition.value;
  // set sliderController.currentPosition(Duration value) => _sliderController.currentPosition.value = value;

  // final Rx<Duration> _duration = Duration.zero.obs;
  // Duration get duration => _duration.value;
  // set duration(Duration value) => _duration.value = value;

  // double get sliderFraction => adjustNanWidth(
  //     sliderController.currentPosition.inMilliseconds.toDouble() /
  //         sliderController.duration.inMilliseconds.toDouble());

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

  @override
  void onInit() {
    super.onInit();
    audioPlayer.onPositionChanged.listen((Duration duration) {
      sliderController.currentPosition = duration;
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
    sliderController.duration =
        (await audioPlayer.getDuration()) ?? Duration.zero;
    isLoadingBeat = false;
  }

  void setEmpty() {
    isLoadingBeat = false;
    beat = null;
    sliderController.currentPosition = Duration.zero;
    sliderController.duration = Duration.zero;
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
    Duration newDuration =
        sliderController.currentPosition + const Duration(seconds: 5);
    if (newDuration < sliderController.duration) {
      seek(newDuration);
    }
  }

  void backwardFiveSeconds() {
    Duration newDuration =
        sliderController.currentPosition - const Duration(seconds: 5);
    if (newDuration > Duration.zero) {
      seek(newDuration);
    }
  }

  void seek(Duration duration) {
    audioPlayer.seek(duration);
  }
}
