import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ListenAssetSupport {

  AudioPlayer player;
  AudioCache cache;
  AudioPlayerState playerState;
  String lastSongPlayed;

  ListenAssetSupport() {
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    player.onPlayerStateChanged.listen((AudioPlayerState s) {
      if(player != null)
        playerState = s;
    });
  }

  listenAssetPreview(String song) {
    if(lastSongPlayed == song) {
      if (playerState == AudioPlayerState.PLAYING) {
        player.stop();
      } else {
        cache.play(song);
      }
    } else {
      player.stop();
      cache.play(song);
    }
    lastSongPlayed = song;
  }

  listenPreview(String song) {
    if(lastSongPlayed == song) {
      if (playerState == AudioPlayerState.PLAYING) {
        player.stop();
      } else {
        player.play(song);
      }
    } else {
      player.stop();
      player.play(song);
    }
    lastSongPlayed = song;
  }

  stopPreview() {
    player.stop();
    cache.clearCache();
    player.release();
  }

  Future<List<int>> getAssetsDuration(List<String> song) async {
    List<int> durations = new List();
    /*song.forEach((str) async {
      cache.load(str);
      player.stop();
      Future.delayed(Duration(milliseconds: 1500), () async {
        int dur;
        try {
          dur = await player?.getDuration() ?? 1;
        } catch (ex) {
          dur = 1;
        }
        durations.add(dur);
        cache.clear(str);
      });
    });*/
    return durations;
  }

  Future<List<int>> getLocalsDuration(List<String> registrationsPath) async {
    List<int> durations = new List();
    /*registrationsPath?.forEach((str) async {
      player.setUrl(str, isLocal: true, respectSilence: true);
      Future.delayed(Duration(milliseconds: 1500), () async {
        int dur;
        try {
          dur = await player?.getDuration() ?? 1;
        } catch (ex) {
          dur = 1;
        }
        durations.add(dur);
        player.release();
      });
    });*/
    return durations;
  }
}