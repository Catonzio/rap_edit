import 'package:rap_edit/models/SongFile.dart';

class SongSingleton {

  SongSingleton.privateConstructor();

  static final SongSingleton _instance = SongSingleton.privateConstructor();

  static SongSingleton get instance => _instance;

  SongFile currentSong;
  String beatPath;
  bool isLocal;
  bool isAsset;

  /// Returns the name of the currentSong (without extension)
  String getName() {
    if(beatPath != null) {
      if(beatPath.endsWith("mp3") || beatPath.endsWith("mp4"))
        return beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".mp")).toLowerCase();
      else if(beatPath.endsWith("wav"))
        return beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".wav")).toLowerCase();
      else
        return beatPath.substring(beatPath.indexOf("/") + 1);
    }
    else
      return "";
  }
}