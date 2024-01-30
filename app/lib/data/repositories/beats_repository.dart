import 'package:rap_edit/data/models/beat.dart';

abstract class BeatsRepository {
  Future<bool> saveBeat(Beat beat);
  Future<bool> saveBeats(List<Beat> beats);
  Future<bool> deleteBeat(String id);
  Future<Beat> getBeat(String id);
  Future<List<Beat>> getAllBeats();
}
