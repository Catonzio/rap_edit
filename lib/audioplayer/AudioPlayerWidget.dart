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

class AudioPlayerWidgetState extends State<AudioPlayerWidget> with WidgetsBindingObserver {

  static IconData playPauseIcon = Icons.play_circle_outline;

  TextStyle textStyle = CstmTextTheme.beatPositionAndDuration;
  bool loopSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    var controller = Provider.of<AudioPlayerController>(context, listen: false);
    controller.initPlayer();
    playPause(controller);
  }

  @override
  void dispose() {
    //Provider.of<AudioPlayerController>(context, listen: false).pauseSong();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
    Provider.of<AudioPlayerController>(context, listen: false).pauseSong();
  }

  /// Sets the player in pause or in play, depending on the current state
  playPause(AudioPlayerController controller) {
    controller.playPause();
    if(controller.playerState != null) {
      controller.playerState == AudioPlayerState.PLAYING
          ? updateIcon(Icons.play_circle_outline)
          : updateIcon(Icons.pause_circle_outline);
    } else if (SongSingleton.instance.beatPath != null) {
      updateIcon(Icons.pause_circle_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AudioPlayerController controller = Provider.of<AudioPlayerController>(context);
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
                      controller.getDurationFormatted(controller.position),
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat, color: controller.loopSelected ? MyColors.primaryColor : MyColors.secondaryColor),
                    onPressed: () => { setLoop(controller) },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_rewind, color: MyColors.primaryColor,),
                      onPressed: () => { fastRewind(controller) }
                  ),
                  IconButton(
                    icon: Icon(playPauseIcon, color: MyColors.primaryColor),
                    iconSize: 50,
                    onPressed: () => { playPause(controller) },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_forward, color: MyColors.primaryColor,),
                      onPressed: () => { fastForward(controller) }
                  ),
                  IconButton(
                    icon: Icon(Icons.stop, color: MyColors.primaryColor),
                    onPressed: () => { stopSong(controller) },
                  ),
                  Container(
                    width: 50,
                    child: Text(
                      controller.getDurationFormatted(controller.duration),
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
                  Container(width: 10,),
                  AudioPlayerSlider(controller),
                  Container(width: 10,),
                ],
              ),
            ],
          ),
        )
    );
  }

}