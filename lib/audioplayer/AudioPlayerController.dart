import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';

class AudioPlayerController extends ChangeNotifier {

  static AudioPlayer player;
  static AudioCache cache;
  AudioPlayerState playerState;
  Duration duration;
  Duration position;
  RangeValues rangeValues;
  bool loopSelected;
  String previousSongPath;

  void initPlayer() {
    loopSelected = loopSelected??true;
    rangeValues = rangeValues??RangeValues(0,0);

    try {
      if (player == null) {
        player = new AudioPlayer();
        cache = AudioCache(fixedPlayer: player);
      }

      duration = new Duration();
      position = new Duration();

      if (SongSingleton.instance.beatPath != null &&
          SongSingleton.instance.beatPath.isNotEmpty && player != null) {
        playSong();
      }

      player.onDurationChanged.listen((Duration d) {
        duration = d;
        if(rangeValues == RangeValues(0,0) || rangeValues.end > durationSeconds() || previousSongPath != SongSingleton.instance.beatPath) {
          rangeValues = RangeValues(0, durationSeconds());
          previousSongPath = SongSingleton.instance.beatPath;
        }
        notifyListeners();
      });

      player.onAudioPositionChanged.listen((Duration p) {
          position = p;
          if (positionSeconds() >= rangeValues.end) {
            seekToSecond(rangeValues.start.toInt());
            if(!loopSelected)
              pauseSong();
          }
          notifyListeners();
      });

      player.onPlayerStateChanged.listen((AudioPlayerState s) {
          playerState = s;
          notifyListeners();
      });

    } catch(ex) { debugPrint("ooooooooooooooooooo porco diooo"); }
  }

  String getSongName() {
    return "";
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
    if(SongSingleton.instance.beatPath != null) {
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
    if(SongSingleton.instance.isAsset == true) {
      cache.play(SongSingleton.instance.beatPath);
    }
    else if(SongSingleton.instance.isAsset == false) {
      player.play(SongSingleton.instance.beatPath,
          isLocal: SongSingleton.instance.isLocal);
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

}