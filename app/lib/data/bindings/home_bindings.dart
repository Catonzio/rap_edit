import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/writer_controller.dart';

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
