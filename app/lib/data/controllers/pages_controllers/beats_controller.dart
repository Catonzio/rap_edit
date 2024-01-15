import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/utils/constants.dart';

class BeatsController extends GetxController {
  static final BeatsController to = Get.find<BeatsController>();

  final RxBool _isLoadingBeats = false.obs;
  bool get isLoadingBeats => _isLoadingBeats.value;
  set isLoadingBeats(bool value) => _isLoadingBeats.value = value;

  final RxList<Beat> _beats = <Beat>[].obs;
  List<Beat> get beats => _beats;
  set beats(List<Beat> value) => _beats.value = value;

  Beat? getBeatWithUrl(String songUrl) =>
      beats.where((Beat beat) => beat.songUrl == songUrl).firstOrNull;

  void fetchBeats() async {
    if (beats.isEmpty) {
      isLoadingBeats = true;
      beats = assetsBeats;
      isLoadingBeats = false;
    }
  }

  void loadBeat(int index) {
    if (beats.isEmpty) {
      fetchBeats();
    }
    if (index < beats.length) {
      Get.toNamed(Routes.writing);
      HomeController.to.setSong(beats[index]);
    }
  }
}
