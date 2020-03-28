import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'AudioPlayerController.dart';
import 'AudioPlayerSlider.dart';

class AudioPlayerWidget extends StatefulWidget {

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> with WidgetsBindingObserver {

  static IconData playPauseIcon = Icons.play_circle_outline;
  static Duration duration;
  static Duration position;

  TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 15);
  bool loopSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SongSingleton.instance.beatPath = "Rap_Instrumental_Beat.mp3";
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
    AudioPlayerController.instance.initPlayer();

      setState(() {
        position = AudioPlayerController.instance.position;
      });


      setState(() {
        duration = AudioPlayerController.instance.duration;
      });

  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    AudioPlayerController.instance.pauseSong();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
        debugPrint("App state: resumed");
        AudioPlayerController.instance.initPlayer();
        break;
      case AppLifecycleState.inactive:
        debugPrint("App state: inactive");
        AudioPlayerController.instance.pauseSong();
        break;
      case AppLifecycleState.paused:
        debugPrint("App state: paused");
        AudioPlayerController.instance.pauseSong();
        break;
      case AppLifecycleState.detached:
        debugPrint("App state: detached");
        AudioPlayerController.instance.pauseSong();
        break;
    }
  }

  /// Updates the icon of play/pause
  void updateIcon(IconData data) {
    if (this.mounted) {
      setState(() {
        playPauseIcon = data;
      });
    }
  }

  setLoop() {
    AudioPlayerController.instance.setLoop();
  }

  fastRewind() {
    AudioPlayerController.instance.fastMoving(-5);
  }

  fastForward() {
    AudioPlayerController.instance.fastMoving(5);
  }

  stopSong() {
    AudioPlayerController.instance.stopSong();
    updateIcon(Icons.play_circle_outline);
  }

  /// Sets the player in pause or in play, depending on the current state
  playPause() {
    if(AudioPlayerController.instance.playPause())
      updateIcon(Icons.play_circle_outline);
    else
      updateIcon(Icons.pause_circle_outline);
  }

  @override
  Widget build(BuildContext context) {
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
                        AudioPlayerController.instance.getSongName(),
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
                    icon: Icon(Icons.repeat, color: AudioPlayerController.instance.loopSelected ? MyColors.startElementColor : Color(0xFF7030A0)),
                    onPressed: () => { setLoop() },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_rewind, color: MyColors.startElementColor,),
                      onPressed: () => { fastRewind() }
                  ),
                  IconButton(
                    icon: Icon(playPauseIcon, color: MyColors.startElementColor),
                    iconSize: 50,
                    onPressed: () => { playPause() },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_forward, color: MyColors.startElementColor,),
                      onPressed: () => { fastForward() }
                  ),
                  IconButton(
                    icon: Icon(Icons.stop, color: MyColors.startElementColor),
                    onPressed: () => { stopSong() },
                  )
                ],
              ),
              //row del player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${AudioPlayerController.instance.getDurationFormatted(AudioPlayerController.instance.position)}",
                    style: textStyle,
                  ),
                  Expanded(
                    child: AudioPlayerSlider(),
                  ),
                  Text(
                    AudioPlayerController.instance.getDurationFormatted(duration),
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