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
    String name;
    if(beatPath != null) {
      if(beatPath.endsWith("mp3") || beatPath.endsWith("mp4"))
        name = beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".mp")).toLowerCase();
      else if(beatPath.endsWith("wav"))
        name = beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".wav")).toLowerCase();
      else if(beatPath.startsWith("https://"))
        name = "YouTube video";
      else
        name = beatPath.substring(beatPath.indexOf("/") + 1);
    }
    else
      name = "";
    if(name != null && name.isNotEmpty) {
      if(name.contains("_"))
        name = name.replaceAll("_", " ");
    }
    return name;
  }
}