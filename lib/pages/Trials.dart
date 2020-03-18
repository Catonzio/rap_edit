import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';

typedef void OnError(Exception exception);
///SERVE PER CARICARE UNA CANZONE DA INTERNET, MA SOLO SE FINISCE PER .MP3 (NO VIDEO DI YT)
class AudioProvider {
  String url;

  AudioProvider(String url) {
    this.url = url;
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  Future<String> load() async {
    final bytes = await _loadFileBytes(url,
        onError: (Exception exception) =>
            print('audio_provider.load => exception $exception'));

    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      return file.path;
    }
    return '';
  }
}



class Trials extends StatefulWidget {
  static String routeName = "/sdfg";
  @override
  TrialsState createState() => TrialsState();
}
//storage/emulated/0/Download/MAMMASTOMALE (prod. Dade).mp3
class TrialsState extends State<Trials> {

  AudioPlayer player;
  AudioCache cache;
  AudioPlayerState state;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    player.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() => state = s);
    });
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
             pressed: () => { startSong() },
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
    //String result = await FilePicker.getFilePath(type: FileType.AUDIO);
    //SongSingleton.instance.beatPath = result;


    AudioProvider provider = AudioProvider("https://codingwithjoe.com/wp-content/uploads/2018/03/applause.mp3");
    String result = await provider.load();
    player.play(result, isLocal: true);
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