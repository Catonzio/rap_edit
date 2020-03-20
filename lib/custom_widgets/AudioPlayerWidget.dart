import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../controllers/SongSingleton.dart';

class AudioPlayerWidget extends StatefulWidget {

  @override
  AudioPlayerWidgetState createState() => new AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {

  static AudioPlayer player;
  static AudioCache cache;
  static AudioPlayerState playerState;
  static Duration duration = new Duration();
  static Duration position = new Duration();
  Slider slider;

  IconData playPauseIcon = Icons.play_arrow;
  TextStyle textStyle = new TextStyle(color: MyColors.textColor);

  @override
  void initState() {
    super.initState();
    initPlayer();
    slider = createSlider();
  }

  @override
  void dispose() {
    super.dispose();
    player.pause();
    slider = null;
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

      cache = AudioCache(fixedPlayer: player);
    }
    if(SongSingleton.instance.beatPath != null && SongSingleton.instance.beatPath.isNotEmpty && player != null) {
      player.play(SongSingleton.instance.beatPath, isLocal: SongSingleton.instance.isLocal);
      player.pause();
    }
  }

  /// Updates the icon of play/pause
  void updateIcon(IconData data) {
    setState(() {
      playPauseIcon = data;
    });
  }

  /// Creates the slider belonging to the song played by the player
  Slider createSlider() {
    if(SongSingleton.instance.beatPath != null) {
      return Slider(
        activeColor: MyColors.startElementColor,
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
    } else {
      return Slider(
        value: 0,
      );
    }
  }

  /// Navigates to the ChoosingBeats page
  loadSong(BuildContext context) {
    Navigator.popAndPushNamed(context, ChoosingBeatsPage.routeName);
  }

  /// Returns the current position of the player displayed as 'minute':'seconds'
  String getPositionFormatted() {
    String pos = position.toString();
    return pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf("."));
  }

  /// Move the player at the second passed as argument
  void seekToSecond(int sec) {
    Duration newDuration = Duration(seconds: sec);
    player.seek(newDuration);
  }

  /// Stops the song
  stopSong() {
    if(player != null) {
      player.stop();
      updateIcon(Icons.play_arrow);
      setState(() {
        seekToSecond(0);
      });
    }
  }

  /// Starts playing the beat located at the beatPath of the SongSingleton
  resumeSong() {
    //player.resume();
    if(SongSingleton.instance.isLocal == false && SongSingleton.instance.isAsset == true) {
      cache.play(SongSingleton.instance.beatPath);
    }
    else if(SongSingleton.instance.isLocal == true && SongSingleton.instance.isAsset == false) {
      player.play(SongSingleton.instance.beatPath,
          isLocal: SongSingleton.instance.isLocal);
    }
    updateIcon(Icons.pause);
  }

  /// Sets the player in pause
  pauseSong() {
    player.pause();
    updateIcon(Icons.play_arrow);
  }

  /// Sets the player in pause or in play, depending on the current state
  playPause() {
    if(SongSingleton.instance.beatPath != null) {
      if (playerState == AudioPlayerState.PLAYING)
        pauseSong();
      else if (playerState != AudioPlayerState.PLAYING)
        resumeSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    slider = createSlider();
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                      SongSingleton.instance.getName(),
                    textAlign: TextAlign.center,
                  )
                )
              ],
            ),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Container(
                            width: 40,
                            child: Center(
                              child: FlatButton(
                                child: Center(
                                    child: Icon(playPauseIcon, color: MyColors.startElementColor, size: 40)
                                ),
                                onPressed: () => { playPause() },
                              ),
                            )
                        )
                    ),
                    Container(width: 10.0,),
                    Container(
                      width: 250,
                      child: slider,
                    ),
                    Text(
                      getPositionFormatted(),
                      style: textStyle,
                    ),
                    Center(
                      child: Container(
                          width: 50,
                          child: MaterialButton(
                            child: Icon(Icons.stop, color: MyColors.startElementColor, size: 40,),
                            onPressed: () => { stopSong() },
                          )
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      );
    }
}