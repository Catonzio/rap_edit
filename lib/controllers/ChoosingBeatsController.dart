import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ChoosingBeatsController extends ChangeNotifier {

  ListenAssetSupport listenAssetSupport;
  List<String> songs = new List();

  void init() {
    songs = [
      "Hip_Hop_Instrumental_Beat.mp3",
      "Rap_Instrumental_Beat.mp3",
      "Trap_Instrumental_Beat.mp3",
      "metronome_100bpm_4-4.mp3", "metronome_100bpm_6-8.mp3",
      "Gemitaiz - Gigante (instrumental).mp3"
    ]
      ..sort((a,b) => a.compareTo(b));
    listenAssetSupport = ListenAssetSupport();
  }

  void stopPreview() => listenAssetSupport.stopPreview();

  loadAsset(String song) {
    SongSingleton.instance.beatPath = song;
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
  }

  listenAssetPreview(String song) { listenAssetSupport.listenAssetPreview(song); }

  loadFromYoutube(String text) async {
    var id = YoutubeExplode.parseVideoId(text);
    var yt = YoutubeExplode();
    var mediaStreams = await yt.getVideoMediaStream(id);
    var audio = mediaStreams.audio;
    String videoPath = audio[0].url.toString();
    debugPrint("Video path: $videoPath");
    SongSingleton.instance.beatPath = videoPath;
    SongSingleton.instance.isLocal = false;
    SongSingleton.instance.isAsset = false;
  }

  Future<bool> loadFromFileSystem() async {
    try {
      String localFilePath = await FilePicker.getFilePath(type: FileType.audio);
      if(localFilePath != null && localFilePath.isNotEmpty) {
        SongSingleton.instance.beatPath = localFilePath;
        SongSingleton.instance.isLocal = true;
        SongSingleton.instance.isAsset = false;
        return true;
      }
        else
          return false;
    } catch(ex) {
      return false;
    }
  }

  String getOnlySongName(String song) {
    song = song.replaceAll("_", " ");
    return song.substring(song.indexOf("/") + 1, song.lastIndexOf(".mp3"));
  }

}