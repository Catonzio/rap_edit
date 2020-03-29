import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'AudioPlayerController.dart';
import 'AudioPlayerSlider.dart';

class AudioPlayerWidget extends StatefulWidget {

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();

  void pauseSong() {}
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> with WidgetsBindingObserver {

  static IconData playPauseIcon = Icons.pause_circle_outline;

  TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 15);
  bool loopSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<AudioPlayerController>(context, listen: false).initPlayer();
  }

  @override
  void dispose() {
    Provider.of<AudioPlayerController>(context).pauseSong();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final AudioPlayerController controller = Provider.of<AudioPlayerController>(context, listen: false);
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
        debugPrint("App state: resumed");
        controller.initPlayer();
        break;
      case AppLifecycleState.inactive:
        debugPrint("App state: inactive");
        controller.pauseSong();
        break;
      case AppLifecycleState.paused:
        debugPrint("App state: paused");
        controller.pauseSong();
        break;
      case AppLifecycleState.detached:
        debugPrint("App state: detached");
        controller.pauseSong();
        break;
    }
  }

  /// Updates the icon of play/pause
  void updateIcon(IconData data) {

      setState(() {
        playPauseIcon = data;
      });

  }

  setLoop(AudioPlayerController controller) {
    controller.setLoop();
  }

  fastRewind(AudioPlayerController controller) {
    controller.fastMoving(-5);
  }

  fastForward(AudioPlayerController controller) {
    controller.fastMoving(5);
  }

  stopSong(AudioPlayerController controller) {
    controller.stopSong();
    updateIcon(Icons.play_circle_outline);
  }

  pauseSong() {
    Provider.of<AudioPlayerController>(context).pauseSong();
  }

  /// Sets the player in pause or in play, depending on the current state
  playPause(AudioPlayerController controller) {
    controller.playPause();
    controller.playerState == AudioPlayerState.PLAYING
    ? updateIcon(Icons.play_circle_outline)
    : updateIcon(Icons.pause_circle_outline);
  }

  @override
  Widget build(BuildContext context) {
    final AudioPlayerController controller = Provider.of<AudioPlayerController>(context);
    //if(controller.player == null)
      //controller.initPlayer();
    return Container(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                        style: TextStyle(color: MyColors.textColor, fontSize: 20),
                      )
                  )
                ],
              ),
              //row dei comandi del player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.repeat, color: controller.loopSelected ? MyColors.startElementColor : Color(0xFF7030A0)),
                    onPressed: () => { setLoop(controller) },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_rewind, color: MyColors.startElementColor,),
                      onPressed: () => { fastRewind(controller) }
                  ),
                  IconButton(
                    icon: Icon(playPauseIcon, color: MyColors.startElementColor),
                    iconSize: 50,
                    onPressed: () => { playPause(controller) },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_forward, color: MyColors.startElementColor,),
                      onPressed: () => { fastForward(controller) }
                  ),
                  IconButton(
                    icon: Icon(Icons.stop, color: MyColors.startElementColor),
                    onPressed: () => { stopSong(controller) },
                  )
                ],
              ),
              //row del player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    controller.getDurationFormatted(controller.position),
                    style: textStyle,
                  ),
                  Expanded(
                    child: AudioPlayerSlider(controller)
                  ),
                  Text(
                    controller.getDurationFormatted(controller.duration),
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