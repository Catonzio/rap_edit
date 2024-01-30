import 'package:rap_edit/data/models/lyric.dart';

abstract class LyricsRepository {
  Future<bool> saveLyric(Lyric lyric);
  Future<bool> deleteLyric(String id);
  Future<Lyric> getLyric(String id);
  Future<List<Lyric>> getAllLyrics();
}
