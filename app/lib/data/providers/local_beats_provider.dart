import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/providers/local_provider.dart';
import 'package:rap_edit/data/repositories/beats_repository.dart';
import 'package:rap_edit/utils/constants.dart';

class LocalBeatsProvider extends BeatsRepository with LocalProvider {
  LocalBeatsProvider() {
    initStorage(beatsStorageName);
  }

  @override
  Future<bool> saveBeat(Beat beat) {
    // TODO: implement saveBeat
    throw UnimplementedError();
  }

  @override
  Future<bool> saveBeats(List<Beat> beats) {
    // TODO: implement saveBeats
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteBeat(String id) {
    // TODO: implement deleteBeat
    throw UnimplementedError();
  }

  @override
  Future<List<Beat>> getAllBeats() {
    // TODO: implement readAllBeats
    throw UnimplementedError();
  }

  @override
  Future<Beat> getBeat(String id) {
    // TODO: implement readBeat
    throw UnimplementedError();
  }
}
