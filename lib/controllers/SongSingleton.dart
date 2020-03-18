import 'package:rap_edit/models/SongFile.dart';

class SongSingleton {

  SongSingleton.privateConstructor();

  static final SongSingleton _instance = SongSingleton.privateConstructor();

  static SongSingleton get instance => _instance;

  SongFile currentSong;
  String beatPath;
  bool isLocal;
  bool isAsset;

  SongFile getSongFile() { return currentSong; }
  String getBeatPath() { return beatPath; }
  bool getIsLocal() { return isLocal; }

  setSongFile(SongFile song) { currentSong = song; }
  setBeatPath(String path) { beatPath = path; }
  setIsLocal(bool itIs) { isLocal = itIs; }

  getName() {
    if(beatPath != null)
      return beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".mp")).toLowerCase();
    else
      return "";
  }
}