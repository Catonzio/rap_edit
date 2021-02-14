import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/audioplayer/AudioPlayerController.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';

class SimpleAudioPlayer extends StatefulWidget {

  SimpleAudioPlayerState state = SimpleAudioPlayerState();

  loadAsset(String name) {
    state.loadAsset(name);
  }

  @override
  SimpleAudioPlayerState createState() => state;

}

class SimpleAudioPlayerState extends State<SimpleAudioPlayer> {

  double sliderValue;
  ListenAssetSupport player;
  String songPath;
  IconData playPauseIcon = Icons.play_circle_outline;

  @override
  void initState() {
    super.initState();
    sliderValue = 0.0;
    player = new ListenAssetSupport();
    songPath = "";
  }

  loadAsset(String songPath) {
    this.songPath = songPath;
    player.loadAsset(songPath+".mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_circle_outline),
                onPressed: () {
                  if(player.playerState == AudioPlayerState.PLAYING) {
                      player.listenAssetPreview("$songPath.mp3");
                      setState(() {
                        playPauseIcon = Icons.pause_circle_outline;
                      });
                    }
                  else if(player.playerState == AudioPlayerState.PAUSED) {
                    player.player.stop();
                    setState(() {
                      playPauseIcon = Icons.play_circle_outline;
                    });
                  }
                },
                color: Colors.blue,
              ),
              Expanded(
                child: Slider(
                  value: player.position == null ? 0.0 : player.position.inSeconds.toDouble(),
                  min: 0.0,
                  max: player.duration == null ? 100.0 : player.duration.inSeconds.toDouble(),
                  divisions: player.duration == null ? 100 : player.duration.inSeconds,
                  label: '${player?.position}',
                  onChanged: (double newValue) {
                    setState(() {
                      sliderValue = newValue;
                    });
                  },
                ),
              ),
              Text("${AudioPlayerController.getDurationFormatted(player.duration)}")
            ],
          )
        ],
      ),
    );
  }

}