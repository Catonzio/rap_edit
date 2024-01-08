import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class MusicController extends GetxController {
  final String baseUrl = "beats";

  final RxString _sourceName = "".obs;
  String get sourceName => _sourceName.value;
  set sourceName(String value) => _sourceName.value = value;

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
    sourceName = "";
    await audioPlayer.dispose();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await dispose();
  }

  Future<void> setLocalSource(String url) async {
    await audioPlayer.setSource(AssetSource("$baseUrl/$url"));
    sourceName = url;
    duration = (await audioPlayer.getDuration()) ?? Duration.zero;
  }

  void setRemoteSource(String url) {
    audioPlayer.setSourceUrl(url);
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
