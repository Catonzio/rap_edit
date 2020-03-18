import 'package:audioplayers/audio_cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';

class Trials extends StatefulWidget {
  static String routeName = "/trials";
  @override
  TrialsState createState() => TrialsState();
}
//storage/emulated/0/Download/MAMMASTOMALE (prod. Dade).mp3
class TrialsState extends State<Trials> {

  AudioPlayer player;
  AudioCache cache;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           CstmButton(
             text: "Play",
             pressed: () => { startCache() },
           ),
           SizedBox(height: 20.0,),
           CstmButton(
             text: "Pause",
             pressed: () => { pauseSong() },
           ),
           SizedBox(height: 20.0,),
           CstmButton(
             text: "Stop",
             pressed: () => { stopSong() },
           )
         ],
        )
      )
    );
  }

  startSong() async {
    String result = await FilePicker.getFilePath(type: FileType.audio);
    SongSingleton.instance.beatPath = result;
    SongSingleton.instance.isLocal = true;
    player.play(SongSingleton.instance.beatPath, isLocal: SongSingleton.instance.isLocal);
  }

  stopSong() {
    player.stop();
  }

  pauseSong() {
    player.pause();
  }

  startCache() {
    SongSingleton.instance.beatPath = "metronome_100bpm_8-8.mp3";
    cache.play(SongSingleton.instance.beatPath);
  }

}