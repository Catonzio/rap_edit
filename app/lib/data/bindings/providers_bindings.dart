import 'package:get/get.dart';
import 'package:rap_edit/data/providers/local_beats_provider.dart';
import 'package:rap_edit/data/providers/local_lyrics_provider.dart';

class ProvidersBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalLyricsProvider(), fenix: true);
    Get.lazyPut(() => LocalBeatsProvider(), fenix: true);
  }
}
