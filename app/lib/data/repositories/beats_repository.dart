import 'package:rap_edit/data/controllers/pages_controllers/settings_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/providers/local_beats_provider.dart';

abstract class BeatsRepository {
  static BeatsRepository get to => SettingsController.to.isOnline
      ? LocalBeatsProvider.to
      : LocalBeatsProvider.to;

  Future<bool> saveBeat(Beat beat);
  Future<bool> saveBeats(List<Beat> beats);
  Future<bool> deleteBeat(String id);
  Future<Beat> getBeat(String id);
  Future<List<Beat>> getAllBeats();
}
