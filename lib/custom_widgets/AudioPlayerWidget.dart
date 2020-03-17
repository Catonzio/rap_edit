import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/pages/ChoosingBeats.dart';

class AudioPlayerWidget extends StatefulWidget {

  @override
  AudioPlayerWidgetState createState() => new AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {

  static AudioPlayer player;
  static Duration duration = new Duration();
  static Duration position = new Duration();
  static AudioPlayerState playerState;

  IconData playPauseIcon = Icons.play_arrow;
  TextStyle textStyle = new TextStyle(color: Colors.white);

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    //player.pause();
    //updateIcon(Icons.play_arrow);
    super.dispose();
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
    if(SongSingleton.instance.beatPath != null && SongSingleton.instance.beatPath.isNotEmpty && player != null) {
      player.play(SongSingleton.instance.beatPath, isLocal: SongSingleton.instance.isLocal);
      updateIcon(Icons.pause);
    }
  }

  void updateIcon(IconData data) {
    setState(() {
      playPauseIcon = data;
    });
  }

  Slider createSlider() {
    return Slider(
      value: position.inSeconds.toDouble(),
      min: 0.0,
      max: duration.inSeconds.toDouble(),
      //activeColor: Theme.of(context).primaryColor,
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
    Navigator.popAndPushNamed(context, ChoosingBeats.routeName);
  }

  stopSong() {
    if(player != null) {
      player.stop();
      updateIcon(Icons.play_arrow);
      setState(() {
        seekToSecond(0);
      });
    }
  }

  resumeSong() {
    player.resume();
    updateIcon(Icons.pause);
  }

  pauseSong() {
    player.pause();
    updateIcon(Icons.play_arrow);
  }

  playPause() {
    if(SongSingleton.instance.beatPath != null) {
      if (playerState == AudioPlayerState.PLAYING)
        pauseSong();
      else if (playerState == AudioPlayerState.PAUSED ||
          playerState == AudioPlayerState.STOPPED ||
          playerState == AudioPlayerState.COMPLETED)
        resumeSong();
    }
  }

  String getPositionFormatted() {
    String pos = position.toString();
    return pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf("."));
  }

  isPlaying() {
    return playerState == AudioPlayerState.PLAYING;
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
                      child: PlayerButton(
                        icon: playPauseIcon,
                        pressed: playPause(),
                      )
                    )
                  ),
                  createSlider(),
                  Text(
                    getPositionFormatted(),
                    style: textStyle,
                  ),
                  Center(
                    child: Container(
                      width: 40,
                      child: PlayerButton(
                        icon: Icons.stop,
                        pressed: stopSong(),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
}