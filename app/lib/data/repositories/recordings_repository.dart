import 'package:rap_edit/data/controllers/pages_controllers/settings_controller.dart';
import 'package:rap_edit/data/models/recording.dart';
import 'package:rap_edit/data/providers/local_recordings_provider.dart';

abstract class RecordingsRepository {
  static RecordingsRepository get to => SettingsController.to.isOnline
      ? LocalRecordingsProvider.to
      : LocalRecordingsProvider.to;

  Future<bool> saveRecording(Recording recording);
  Future<bool> saveRecordings(List<Recording> recordings);
  Future<bool> deleteRecording(String id);
  Future<Recording> getRecording(String id);
  Future<List<Recording>> getAllRecordings();
}
