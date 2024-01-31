import 'package:get/get.dart';
import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/data/providers/local_provider.dart';
import 'package:rap_edit/data/repositories/lyrics_repository.dart';
import 'package:rap_edit/utils/constants.dart';

class LocalLyricsProvider extends LyricsRepository with LocalProvider {
  static LocalLyricsProvider get to => Get.find<LocalLyricsProvider>();

  LocalLyricsProvider() {
    initStorage(lyricsStorageName);
  }

  @override
  Future<bool> deleteLyric(String id) async {
    try {
      await box.remove(id);
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }

  @override
  Future<List<Lyric>> getAllLyrics() async {
    List<String> keys = box.getKeys().toList();
    List<Lyric> l = <Lyric>[];

    for (String k in keys) {
      l.add(await getLyric(k));
    }

    return l;
  }

  @override
  Future<Lyric> getLyric(String id) async {
    final Map<String, dynamic> json = await box.read(id);
    return Lyric.fromJson(json);
  }

  @override
  Future<bool> saveLyric(Lyric lyric) async {
    try {
      await box.write(lyric.id, lyric.toJson());
      return true;
    } catch (e) {
      e.printError();
      return false;
    }
  }
}
