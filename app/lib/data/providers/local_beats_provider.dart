import 'package:get/get.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/providers/local_provider.dart';
import 'package:rap_edit/data/repositories/beats_repository.dart';
import 'package:rap_edit/utils/constants.dart';

class LocalBeatsProvider extends BeatsRepository with LocalProvider {
  static LocalBeatsProvider get to => Get.find<LocalBeatsProvider>();

  LocalBeatsProvider() {
    initStorage(beatsStorageName);
  }

  @override
  Future<bool> saveBeat(Beat beat) async {
    try {
      await box.write(beat.id, beat.toJson());
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  @override
  Future<bool> saveBeats(List<Beat> beats) async {
    try {
      for (Beat beat in beats) {
        await box.write(beat.id, beat.toJson());
      }
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  @override
  Future<bool> deleteBeat(String id) async {
    try {
      await box.remove(id);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  @override
  Future<List<Beat>> getAllBeats() async {
    List<String> keys = box.getKeys().toList();
    List<Beat> l = <Beat>[];

    for (String k in keys) {
      l.add(await getBeat(k));
    }

    return l;
  }

  @override
  Future<Beat> getBeat(String id) async {
    final Map<String, dynamic> json = await box.read(id);
    return Beat.fromJson(json);
  }
}
