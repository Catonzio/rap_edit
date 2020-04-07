import 'package:rap_edit/models/SongFile.dart';

class SongSingleton {

  SongSingleton.privateConstructor();

  static final SongSingleton _instance = SongSingleton.privateConstructor();

  static SongSingleton get instance => _instance;

  /// the object representing the current song
  SongFile currentSong;
  /// the path of the beat current loaded in the mediaplayer
  String beatPath;
  /// bool value that says if the path of the beat is local or not
  bool isLocal;
  /// bool value that says if the path of the beat is from an asset or not
  bool isAsset;
  /// path of the first song to mix
  String firstMixingSong;
  /// path of the second song to mix
  String secondMixingSong;

  /// Returns the name of the currentSong (without extension)
  String getName() {
    String name;
    if(beatIsReady()) {
      if(beatPath.endsWith("mp3") || beatPath.endsWith("mp4"))
        name = beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".mp")).toLowerCase();
      else if(beatPath.endsWith("wav"))
        name = beatPath.substring(beatPath.lastIndexOf("/") + 1, beatPath.lastIndexOf(".wav")).toLowerCase();
      else if(beatPath.startsWith("https://"))
        name = "YouTube video";
      else if(beatPath.contains("/"))
        name = beatPath.substring(beatPath.indexOf("/") + 1);
      else
        name = beatPath;
    }
    else
      name = "";
    if(name != null && name.isNotEmpty) {
      if(name.contains("_"))
        name = name.replaceAll("_", " ");
    }
    return name;
  }

  bool beatIsReady() {
    return beatPath != null && beatPath.isNotEmpty && beatPath != "null";
  }
}