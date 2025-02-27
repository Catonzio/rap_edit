import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../models/SongSingleton.dart';

class AudioPlayerWidget2 extends StatefulWidget {

  final AudioPlayerWidget2State state = AudioPlayerWidget2State();

  @override
  AudioPlayerWidget2State createState() => state;

  pauseSong() {
    state.pauseSong();
  }
}

class AudioPlayerWidget2State extends State<AudioPlayerWidget2> {

  static AudioPlayer player;
  static AudioCache cache;
  static AudioPlayerState playerState;
  static Duration duration;
  static Duration position;

  static IconData playPauseIcon = Icons.play_arrow;
  TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 15);

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    try {
      if (player == null) {
        player = new AudioPlayer();
        duration = new Duration();
        position = new Duration();
      }

      player.onDurationChanged.listen((Duration d) {
        if (this.mounted)
          setState(() => duration = d);
      });

      player.onAudioPositionChanged.listen((Duration p) {
        if (this.mounted)
          setState(() => { position = p});
      });

      player.onPlayerStateChanged.listen((AudioPlayerState s) {
        if (this.mounted)
          setState(() =>
          playerState = s);
      });

      player.onPlayerCompletion.listen((void v) {
        stopSong();
      });

      cache = AudioCache(fixedPlayer: player);

      if (SongSingleton.instance.beatPath != null &&
          SongSingleton.instance.beatPath.isNotEmpty && player != null) {
        playSong();
        if(SongSingleton.instance.isAsset == true) {

        } else {
          pauseSong();
        }
      }
    } catch(ex) { debugPrint("ooooooooooooooooooo porco diooo"); }
  }

  /// Updates the icon of play/pause
  void updateIcon(IconData data) {
    if (this.mounted) {
      setState(() {
        playPauseIcon = data;
      });
    }
  }

  /// Creates the slider belonging to the song played by the player
  SliderTheme createSlider() {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: MyColors.electricBlue,
          inactiveTrackColor: MyColors.textColor,
          trackShape: RoundedRectSliderTrackShape(),
          trackHeight: 4.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
          thumbColor: MyColors.electricBlue,
          overlayColor: Colors.white.withAlpha(20),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 5.0),
          tickMarkShape: RoundSliderTickMarkShape(),
          activeTickMarkColor: MyColors.electricBlue,
          inactiveTickMarkColor: MyColors.textColor,
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: MyColors.electricBlue,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: SongSingleton.instance.beatPath != null
        ? Slider(
          value: position.inSeconds.toDouble(),
          min: 0.0,
          max: duration.inSeconds.toDouble() + 0.1,
          divisions: 300,
          label: getDurationFormatted(position),
          activeColor: Theme.of(context).primaryColor,
          onChanged: (double value) {
            setState(() {
              seekToSecond(value.toInt());
              value = value;
              //resumeSong();
            });
          },
        )
       : Slider(
          value: 0.0,
          onChanged: (double val) => {},
        )
    );
  }

  /// Navigates to the ChoosingBeats page
  loadSong(BuildContext context) {
    Navigator.popAndPushNamed(context, ChoosingBeatsPage.routeName);
  }

  /// Returns the Duration displayed as 'minute':'seconds'
  String getDurationFormatted(Duration dur) {
    //se dur è != null, ritorna dur.toString(); altrimenti, Duration().toString()
    String pos = dur?.toString() ?? Duration().toString();
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
      if (this.mounted)
        setState(() {
          seekToSecond(0);
        });
    }
  }

  /// Starts playing the beat located at the beatPath of the SongSingleton
  playSong() {
    if(SongSingleton.instance.isAsset == true) {
      cache.play(SongSingleton.instance.beatPath);
      updateIcon(Icons.pause);
    }
    else if(SongSingleton.instance.isAsset == false) {
      player.play(SongSingleton.instance.beatPath,
          isLocal: SongSingleton.instance.isLocal);
    }
    updateIcon(Icons.pause);
  }

  /// Sets the player in pause
  void pauseSong() {
    if(player != null) {
      player.pause();
      updateIcon(Icons.play_arrow);
    }
  }

  /// Sets the player in pause or in play, depending on the current state
  playPause() {
    if(SongSingleton.instance.beatPath != null) {
      if (playerState == AudioPlayerState.PLAYING)
        pauseSong();
      else if (playerState != AudioPlayerState.PLAYING)
        playSong();
    }
  }

  @override
  Widget build(BuildContext context) {
    //slider = createSlider();
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*Expanded(
                    child: Text(
                      SongSingleton.instance.getName(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyColors.textColor, fontSize: 20),
                    )
                )*/
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(playPauseIcon, color: MyColors.primaryColor),
                  iconSize: 40,
                  onPressed: () => { playPause() },
                ),
                Container(width: 5,),
                IconButton(
                    icon: Icon(Icons.fast_rewind, color: MyColors.primaryColor,),
                    onPressed: () => { seekToSecond(position.inSeconds - 5) }
                ),
                Container(width: 5,),
                IconButton(
                    icon: Icon(Icons.fast_forward, color: MyColors.primaryColor,),
                    onPressed: () => { seekToSecond(position.inSeconds + 5) }
                ),
                Container(width: 5,),
                IconButton(
                  icon: Icon(Icons.stop, color: MyColors.primaryColor),
                  iconSize: 40,
                  onPressed: () => { stopSong() },
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  getDurationFormatted(position),
                  style: textStyle,
                ),
                Container(width: 10.0,),
                Expanded(
                  child: createSlider(),
                ),
                Container(width: 10.0,),
                Text(
                  getDurationFormatted(duration),
                  style: textStyle,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}