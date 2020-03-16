import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/pages/ChoosingBeats.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String localFilePath;
  AudioPlayerWidget({Key key, @required this.localFilePath});
  @override
  AudioPlayerWidgetState createState() => new AudioPlayerWidgetState(localFilePath: localFilePath);
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {

  static AudioPlayer player;
  static Duration duration = new Duration();
  static Duration position = new Duration();
  static AudioPlayerState playerState;
  String localFilePath;
  IconData playPauseIcon = Icons.play_arrow;
  TextStyle textStyle = new TextStyle(color: Colors.white);

  AudioPlayerWidgetState({Key key, @required this.localFilePath});

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    if (player == null) {
      player = new AudioPlayer();

      player.onDurationChanged.listen((Duration d) {
        setState(() => duration = d);
      });

      player.onAudioPositionChanged.listen((Duration p) {
        setState(() => { position = p });
      });

      player.onPlayerStateChanged.listen((AudioPlayerState s) {
        setState(() => playerState = s);
      });
    }
    if(localFilePath != null && localFilePath.isNotEmpty) {
      player.play(localFilePath, isLocal: true);
      updateText(Icons.pause);
    }
  }

  void updateText(IconData data) {
    setState(() {
      playPauseIcon = data;
    });
  }

  Slider createSlider(BuildContext context) {
    return Slider(
      value: position.inSeconds.toDouble(),
      min: 0.0,
      max: duration.inSeconds.toDouble(),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
          resumeSong();
        });
      },
    );
  }

  void seekToSecond(int sec) {
    Duration newDuration = Duration(seconds: sec);
    player.seek(newDuration);
  }

  loadSong(BuildContext context) {
    /*try {
      localFilePath = await FilePicker.getFilePath(type: FileType.audio);
      if (localFilePath != null && localFilePath.isNotEmpty) {
        player.play(localFilePath, isLocal: true);
        updateText(Icons.pause);
      }
    } catch(ex) {

    }*/
    Navigator.pushNamed(context, ChoosingBeats.routeName);
  }

  stopSong() {
    player.stop();
    updateText(Icons.play_arrow);
    setState(() {
      seekToSecond(0);
    });
  }

  resumeSong() {
    player.resume();
    updateText(Icons.pause);
  }

  pauseSong() {
    player.pause();
    updateText(Icons.play_arrow);
  }

  playPause() {
    if(playerState == AudioPlayerState.PLAYING)
      pauseSong();
    if(playerState == AudioPlayerState.PAUSED || playerState == AudioPlayerState.STOPPED || playerState == AudioPlayerState.COMPLETED)
      resumeSong();
  }

  String getPositionFormatted() {
    String pos = position.toString();
    return pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf("."));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      child: MaterialButton(
                        //color: Colors.grey,
                        //child: Text('$playPauseButtonText', style: textStyle,),
                        child: Icon(playPauseIcon, color: Theme.of(context).primaryColor,),
                        onPressed: () => { playPause() },
                      ),
                    )
                  ),
                  createSlider(context),
                  Text(
                    getPositionFormatted(),
                    style: textStyle,
                  ),
                  Center(
                    child: Container(
                      width: 40,
                      child: MaterialButton(
                        child: Icon(Icons.stop, color: Theme.of(context).primaryColor,),
                        onPressed: () => { stopSong() },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CstmButton(
                      text: "Load",
                      pressed: () => { loadSong(context) },
                    )
                  ],
                ),
              )
            )
          ],
        ),
      );
    }
}