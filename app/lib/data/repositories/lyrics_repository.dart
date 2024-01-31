import 'package:rap_edit/data/controllers/pages_controllers/settings_controller.dart';
import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/data/providers/local_lyrics_provider.dart';

abstract class LyricsRepository {
  static LyricsRepository get to => SettingsController.to.isOnline
      ? LocalLyricsProvider.to
      : LocalLyricsProvider.to;

  Future<bool> saveLyric(Lyric lyric);
  Future<bool> deleteLyric(String id);
  Future<Lyric> getLyric(String id);
  Future<List<Lyric>> getAllLyrics();
}
