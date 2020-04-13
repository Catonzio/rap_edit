import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../models/SongSingleton.dart';
import 'AudioPlayerController.dart';
import 'AudioPlayerSlider.dart';

class AudioPlayerWidget extends StatefulWidget {

  final AudioPlayerWidgetState state = AudioPlayerWidgetState();

  @override
  AudioPlayerWidgetState createState() => state;

  ///se riesco, da modificare!
  void pauseSong() {
    state.pauseSong();
  }
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {

  static IconData playPauseIcon = Icons.play_circle_outline;

  TextStyle textStyle = CstmTextTheme.beatPositionAndDuration;
  bool loopSelected = true;
  AudioPlayerController controller;

  @override
  void initState() {
    super.initState();
    var controller = Provider.of<AudioPlayerController>(context, listen: false);
    controller.setWidgetFunction(updateIcon);
    controller.initPlayer();
  }

  @override
  void dispose() {
    pauseSong();
    super.dispose();
  }

  /// Updates the icon of play/pause
  void updateIcon(IconData data) {
    if(mounted)
      setState(() {
        playPauseIcon = data;
      });
  }

  setLoop() => controller?.setLoop();

  fastRewind() => controller?.fastMoving(-5);

  fastForward() => controller?.fastMoving(5);

  stopSong() {
    controller?.stopSong();
    updateIcon(Icons.play_circle_outline);
  }

  pauseSong() {
    controller?.pauseSong();
    //updateIcon(Icons.play_circle_outline);
  }

  /// Sets the player in pause or in play, depending on the current state
  playPause() {
    controller?.playPause();
    if(AudioPlayerController.playerState != null) {
      AudioPlayerController.playerState == AudioPlayerState.PLAYING
          ? updateIcon(Icons.play_circle_outline)
          : updateIcon(Icons.pause_circle_outline);
    } else if (SongSingleton.instance.beatPath != null) {
      updateIcon(Icons.pause_circle_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<AudioPlayerController>(context);
    if(controller == null)
      controller.initPlayer();
    return Container(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //row del nome della canzone caricata
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                        controller.getSongName(),
                        textAlign: TextAlign.center,
                        style: CstmTextTheme.displayingBeatName,
                      )
                  )
                ],
              ),
              //row dei comandi del player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: Text(
                      controller.getDurationFormatted(AudioPlayerController.position),
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.threesixty, color: AudioPlayerController.loopSelected ? MyColors.primaryColor : MyColors.secondaryColor),
                    onPressed: () => { setLoop() },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_rewind, color: MyColors.primaryColor,),
                      onPressed: () => { fastRewind() }
                  ),
                  IconButton(
                    icon: Icon(playPauseIcon, color: MyColors.primaryColor),
                    iconSize: 50,
                    onPressed: () => { playPause() },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_forward, color: MyColors.primaryColor,),
                      onPressed: () => { fastForward() }
                  ),
                  IconButton(
                    icon: Icon(Icons.stop, color: MyColors.primaryColor),
                    onPressed: () => { stopSong() },
                    tooltip: "Hello",
                  ),
                  Container(
                    width: 50,
                    child: Text(
                      controller.getDurationFormatted(AudioPlayerController.duration),
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              //row del player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AudioPlayerSlider(controller),
                ],
              ),
            ],
          ),
        )
    );
  }

}