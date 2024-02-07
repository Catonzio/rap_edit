import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/record_controller.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';
import 'package:rap_edit/data/controllers/domain_controllers/writer_controller.dart';
import 'package:rap_edit/ui/widgets/player/player_slider_widget.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<PlayerSliderController>(PlayerSliderController());

    MusicController musicController =
        Get.put<MusicController>(MusicController());

    WriterController writerController =
        Get.put<WriterController>(WriterController());

    Get.lazyPut(() => RecorderController());

    Get.lazyPut<HomeController>(
        () => HomeController(
              musicController: musicController,
              writerController: writerController,
            ),
        fenix: true);
  }
}
