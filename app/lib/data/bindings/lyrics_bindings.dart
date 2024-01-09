import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/pages_controllers/lyrics_controller.dart';

class LyricsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LyricsController>(() => LyricsController());
  }
}
