import 'package:rap_edit/models/SongFile.dart';

class SongSingleton {

  SongSingleton.privateConstructor();

  static final SongSingleton _instance = SongSingleton.privateConstructor();

  static SongSingleton get instance => _instance;

  SongFile currentSong;
  String beatPath;
  bool isLocal;

  SongFile getSongFile() { return currentSong; }
  String getBeatPath() { return beatPath; }
  bool getIsLocal() { return isLocal; }

  setSongFile(SongFile song) { currentSong = song; }
  setBeatPath(String path) { beatPath = path; }
  setIsLocal(bool itIs) { isLocal = itIs; }

}