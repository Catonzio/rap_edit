import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/home_controller.dart';
import 'package:rap_edit/data/controllers/music_controller.dart';
import 'package:rap_edit/data/controllers/writer_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    MusicController musicController =
        Get.put<MusicController>(MusicController());
    WriterController writerController =
        Get.put<WriterController>(WriterController());

    Get.lazyPut<HomeController>(
        () => HomeController(
              musicController: musicController,
              writerController: writerController,
            ),
        fenix: true);
  }
}
