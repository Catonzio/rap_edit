import 'dart:io';
import 'dart:typed_data';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';

import '../controllers/FileController.dart';
import '../custom_widgets/CtsmButton.dart';

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
  static String routeName = "/asd";
  @override
  TrialsState createState() => TrialsState();
}
//storage/emulated/0/Download/MAMMASTOMALE (prod. Dade).mp3
class TrialsState extends State<Trials> {

  PermissionHandler _permissionHandler;
  bool hasPermissions;
  bool isRecording;

  @override
  void initState() {
    super.initState();
    _permissionHandler = PermissionHandler();
    checkPermissions();
  }

  checkPermissions() async {
    var result = await _permissionHandler.requestPermissions([PermissionGroup.microphone]);
    if(result[PermissionGroup.microphone] == PermissionStatus.granted) {
      hasPermissions = await AudioRecorder.hasPermissions;hasPermissions = await AudioRecorder.hasPermissions;
    isRecording = await AudioRecorder.isRecording;
      isRecording = await AudioRecorder.isRecording;
    }

    debugPrint("Has permissions: " + hasPermissions.toString() + " isRecording: " + isRecording.toString());
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
             pressed: () => { play() },
           ),
           SizedBox(height: 20.0,),
           CstmButton(
             text: "Record",
             pressed: () => { startRecording() },
           ),
           SizedBox(height: 20.0,),
           CstmButton(
             text: "Stop",
             pressed: () => { stopRecording() },
           )
         ],
        )
      )
    );
  }

  startRecording() async {
    if(hasPermissions != null) {
      await AudioRecorder.start(path: FileController.filePath + "/prova7", audioOutputFormat: AudioOutputFormat.WAV);
    }
  }

  stopRecording() async {
    if(isRecording != null) {
      Recording recording = await AudioRecorder.stop();
      print("Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
    }
  }

  play() {
    AudioPlayer player = AudioPlayer();
    player.play("/data/user/0/com.catonz.rap_edit/app_flutter/prova7.wav", isLocal: true);
  }



}