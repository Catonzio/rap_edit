import 'package:get/get.dart';
import 'package:rap_edit/data/models/recording.dart';
import 'package:rap_edit/data/providers/local_provider.dart';
import 'package:rap_edit/data/repositories/recordings_repository.dart';

class LocalRecordingsProvider extends RecordingsRepository with LocalProvider {
  static LocalRecordingsProvider to = Get.find<LocalRecordingsProvider>();

  @override
  Future<bool> deleteRecording(String id) {
    // TODO: implement deleteRecording
    throw UnimplementedError();
  }

  @override
  Future<List<Recording>> getAllRecordings() {
    // TODO: implement getAllRecordings
    throw UnimplementedError();
  }

  @override
  Future<Recording> getRecording(String id) {
    // TODO: implement getRecording
    throw UnimplementedError();
  }

  @override
  Future<bool> saveRecording(Recording recording) {
    // TODO: implement saveRecording
    throw UnimplementedError();
  }

  @override
  Future<bool> saveRecordings(List<Recording> recordings) {
    // TODO: implement saveRecordings
    throw UnimplementedError();
  }
}
