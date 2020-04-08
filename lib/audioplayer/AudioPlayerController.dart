import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';

class AudioPlayerController extends ChangeNotifier {

  static AudioPlayer player;
  static AudioCache cache;
  static bool loopSelected;
  static String previousSongPath;
  static AudioPlayerState playerState;
  static Duration duration;
  static Duration position;
  static RangeValues rangeValues;
  Function widgetFunction;


  void initPlayer() {
    loopSelected = loopSelected??true;
    rangeValues = rangeValues??RangeValues(0,0);

    try {
      if (player == null) {
        player = new AudioPlayer();
        cache = AudioCache(fixedPlayer: player);
      }

      if (SongSingleton.instance.beatIsReady() && player != null && previousSongPath != SongSingleton.instance.beatPath) {
        playSong();
        duration = new Duration();
        position = new Duration();
        rangeValues = RangeValues(0,0);
        previousSongPath = SongSingleton.instance.beatPath;
        if(widgetFunction != null)
          widgetFunction(Icons.pause_circle_outline);
      } else {
        duration = duration??new Duration();
        position = position??new Duration();
      }

      player.onDurationChanged.listen((Duration d) {
        duration = d;
        if(rangeValues == RangeValues(0,0)
            || previousSongPath == null
            || previousSongPath != SongSingleton.instance.beatPath) {
          rangeValues = RangeValues(0, durationSeconds());
          previousSongPath = SongSingleton.instance.beatPath;
        }
        notifyListeners();
      });

      player.onAudioPositionChanged.listen((Duration p) {
          position = p;
          if (positionSeconds() >= rangeValues.end || positionSeconds() >= durationSeconds()) {
            //debugPrint("Start: ${rangeValues.start}");
            seekToSecond(rangeValues.start.toInt());
            if(!loopSelected) {
              stopSong();
              if(widgetFunction != null)
                widgetFunction(Icons.play_circle_outline);
            }
          }
          notifyListeners();
      });

      player.onPlayerStateChanged.listen((AudioPlayerState s) {
          playerState = s;
          notifyListeners();
      });

      //pauseSong();

    } catch(ex) { debugPrint("ooooooooooooooooooo porco diooo"); }
  }

  String getSongName() {
    return SongSingleton.instance.getName();
  }

  fastMoving(int i) {
    int newPosition = position.inSeconds + i;
    //check if newPosition is inside the range of the SONG
    if(newPosition <= duration.inSeconds && newPosition >= 0) {
      //check if newPosition is inside the range of the SLIDER
      if(newPosition <= rangeValues.end.toInt() && newPosition >= rangeValues.start.toInt()) {
        seekToSecond(position.inSeconds + i);
      }
    }
    notifyListeners();
  }

  playPause() {
    bool isPaused = false;
    if(SongSingleton.instance.beatIsReady()) {
      if (playerState == AudioPlayerState.PLAYING) {
        pauseSong();
        isPaused = true;
      }
      else if (playerState != AudioPlayerState.PLAYING) {
        playSong();
        isPaused = false;
      }
    }
    return isPaused;
  }

  /// Stops the song
  stopSong() {
    if(player != null) {
      player.stop();
      seekToSecond(rangeValues.start.toInt());
    }
  }

  /// Starts playing the beat located at the beatPath of the SongSingleton
  void playSong() {
    try {
      if(SongSingleton.instance.beatIsReady() && SongSingleton.instance.isAsset == true) {
        cache.play(SongSingleton.instance.beatPath);
      }
      else if(SongSingleton.instance.beatIsReady() && SongSingleton.instance.isAsset == false) {
        player.play(SongSingleton.instance.beatPath,
            isLocal: SongSingleton.instance.isLocal);
      }
    } catch (exception) {

    }
  }

  /// Sets the player in pause
  void pauseSong() {
    if(player != null) {
      player.pause();
    }
  }

  /// Move the player at the second passed as argument
  void seekToSecond(int sec) {
    Duration newDuration = Duration(seconds: sec);
    player.seek(newDuration);
    notifyListeners();
  }

  setLoop() {
    loopSelected = !loopSelected;
    notifyListeners();
  }

  double durationSeconds() {
    return duration?.inSeconds?.toDouble();
  }

  double positionSeconds() {
    return position?.inSeconds?.toDouble();
  }

  /// Returns the Duration displayed as 'minute':'seconds'
  String getDurationFormatted(Duration dur) {
    //se dur è != null, ritorna dur.toString(); altrimenti, Duration().toString()
    String pos = dur?.toString() ?? Duration().toString();
    return pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf("."));
  }

  void setWidgetFunction(void Function(IconData data) updateIcon) { widgetFunction = updateIcon; }

}