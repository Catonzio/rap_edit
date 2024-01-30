import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/data/providers/local_provider.dart';
import 'package:rap_edit/data/repositories/lyrics_repository.dart';
import 'package:rap_edit/utils/constants.dart';

class LocalLyricsProvider extends LyricsRepository with LocalProvider {
  LocalLyricsProvider() {
    initStorage(lyricsStorageName);
  }

  @override
  Future<bool> deleteLyric(String id) {
    // TODO: implement deleteLyric
    throw UnimplementedError();
  }

  @override
  Future<List<Lyric>> getAllLyrics() {
    // TODO: implement getAllLyrics
    throw UnimplementedError();
  }

  @override
  Future<Lyric> getLyric(String id) {
    // TODO: implement getLyric
    throw UnimplementedError();
  }

  @override
  Future<bool> saveLyric(Lyric lyric) {
    // TODO: implement saveLyric
    throw UnimplementedError();
  }
}
