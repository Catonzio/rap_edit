import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/beat_file_controller.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/utils/constants.dart';

class BeatsController extends GetxController {
  static final BeatsController to = Get.find<BeatsController>();

  final BeatFileController fileController = BeatFileController.to;

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
      beats = [...beats, ...(await fileController.readAllBeats())];
      isLoadingBeats = false;
    }
  }

  void loadBeat(int index) {
    if (beats.isEmpty) {
      fetchBeats();
    }
    if (index < beats.length) {
      // Get.offAndToNamed(Routes.writing);
      HomeController.to.setSong(beats[index]);
    }
  }

  Future<void> loadBeatsFromFileSystem() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: musicExtensions,
        onFileLoading: (status) {
          print(status);
        });

    if (result != null) {
      List<Beat> newBeats = result.paths
          .where((path) =>
              path != null && !beats.map((beat) => beat.songUrl).contains(path))
          .map((path) => Beat.fromPath(path!))
          .toList();
      fileController.saveBeats(newBeats);
      beats = [...beats, ...newBeats];
    } else {
      // User canceled the picker
    }
  }
}
