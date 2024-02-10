import 'package:get/get.dart';
import 'package:rap_edit/data/models/recording.dart';
import 'package:rap_edit/data/repositories/recordings_repository.dart';

class RecordingsController extends GetxController {
  static final RecordingsController to = Get.find<RecordingsController>();

  final RecordingsRepository recordingsRepository = RecordingsRepository.to;

  final RxBool _isLoadingRecordings = false.obs;
  bool get isLoadingRecordings => _isLoadingRecordings.value;
  set isLoadingRecordings(bool value) => _isLoadingRecordings.value = value;

  final RxList<Recording> _recordings = <Recording>[].obs;
  List<Recording> get recordings => _recordings;
  set recordings(List<Recording> value) => _recordings.value = value;

  @override
  void onReady() {
    super.onReady();
    fetchRecordings();
  }

  void fetchRecordings() async {
    isLoadingRecordings = true;
    recordings = await recordingsRepository.getAllRecordings();
    isLoadingRecordings = false;
  }

  void deleteRecording(int index) {
    recordingsRepository.deleteRecording(recordings[index].id);
    recordings.removeAt(index);
  }

  void loadRecording(int index) {
    if (recordings.isEmpty) {
      fetchRecordings();
    }
    if (index < recordings.length) {
      // Get.offAndToNamed(Routes.recording);
      // HomeController.to.loadLyric(lyrics[index]);
    }
  }

  void saveRecording(Recording recording) {
    recordingsRepository.saveRecording(recording);
  }
}
