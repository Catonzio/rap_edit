import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ListenAssetSupport {

  AudioPlayer player;
  AudioCache cache;
  AudioPlayerState playerState;

  ListenAssetSupport() {
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    player.onPlayerStateChanged.listen((AudioPlayerState s) {
      if(player != null)
        playerState = s;
    });
  }

  IconData listenAssetPreview(String song) {
    if (playerState == AudioPlayerState.PLAYING) {
      player.stop();
    } else {
      cache.play(song);
    }
    return playerState != AudioPlayerState.PLAYING ? Icons.stop : Icons.play_arrow;
  }

  IconData listenPreview(String song) {
    if(playerState == AudioPlayerState.PLAYING) {
      player.stop();
      return Icons.play_arrow;
    } else {
      player.play(song, isLocal: true);
      return Icons.stop;
    }
  }

  stopPreview() {
    player.stop();
    cache.clearCache();
    player.release();
  }
}