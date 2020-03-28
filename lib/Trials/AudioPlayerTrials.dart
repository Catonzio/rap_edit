import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/support/MyColors.dart';
import 'package:rap_edit/Trials/_CustomRangeThumbShape.dart';
import '../controllers/SongSingleton.dart';

class AudioPlayerTrials extends StatefulWidget {

  final AudioPlayerTrialsState state = AudioPlayerTrialsState();

  @override
  AudioPlayerTrialsState createState() => state;

  pauseSong() {
    state.pauseSong();
  }
}

class AudioPlayerTrialsState extends State<AudioPlayerTrials> with WidgetsBindingObserver {

  static AudioPlayer player;
  static AudioCache cache;
  static AudioPlayerState playerState;
  static Duration duration;
  static Duration position;
  static IconData playPauseIcon = Icons.play_circle_outline;

  TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 15);
  RangeValues _values;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SongSingleton.instance.beatPath = "Rap_Instrumental_Beat.mp3";
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
    initPlayer();
    _values = RangeValues(0,0);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    player.pause();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
        debugPrint("App state: resumed");
        initPlayer();
        break;
      case AppLifecycleState.inactive:
        debugPrint("App state: inactive");
        player.pause();
        break;
      case AppLifecycleState.paused:
        debugPrint("App state: paused");
        player.pause();
        break;
      case AppLifecycleState.detached:
        debugPrint("App state: detached");
        player.pause();
        break;
    }
  }


  void initPlayer() {
    try {
      if (player == null) {
        player = new AudioPlayer();
        duration = new Duration();
        position = new Duration();
        cache = AudioCache(fixedPlayer: player);
      }

      if (SongSingleton.instance.beatPath != null &&
          SongSingleton.instance.beatPath.isNotEmpty && player != null) {
        playSong();
        if(SongSingleton.instance.isAsset == true) {
          //pauseSong();
        } else {
          pauseSong();
        }
      }

      player.onDurationChanged.listen((Duration d) {
        if (this.mounted)
          setState(() {
            duration = d;
            if(_values == RangeValues(0,0))
              _values = RangeValues(position.inSeconds.toDouble(), duration.inSeconds.toDouble());
          });
      });

      player.onAudioPositionChanged.listen((Duration p) {
        if (this.mounted)
          setState(() {
            position = p;
          });
      });

      player.onPlayerStateChanged.listen((AudioPlayerState s) {
        if (this.mounted)
          setState(() =>
          playerState = s);
      });

      player.onPlayerCompletion.listen((void v) {
        stopSong();
      });
      //_values = RangeValues(position.inSeconds.toDouble(), duration.inSeconds.toDouble());
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

  static final RangeThumbSelector _customRangeThumbSelector = (
      TextDirection textDirection,
      RangeValues values,
      double tapValue,
      Size thumbSize,
      Size trackSize,
      double dx,
      ) {
    final double start = (tapValue - values.start).abs();
    final double end = (tapValue - values.end).abs();
    return start < end ? Thumb.start : Thumb.end;
  };

  /*
  activeTrackColor: MyColors.electricBlue,
          inactiveTrackColor: MyColors.textColor,
          trackShape: RoundedRectSliderTrackShape(),
          trackHeight: 5.0,
          //thumbShape: RoundSliderThumbShape(enabledThumbRadius: 25.0),
          //thumbColor: MyColors.electricBlue,
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
   */
  /// Creates the slider belonging to the song played by the player
  SliderTheme createSlider() {
    return SliderTheme(
        data: SliderThemeData(
          trackHeight: 5.0,
          inactiveTrackColor: Colors.grey[800],
          activeTrackColor: MyColors.textColor,
          thumbColor: MyColors.electricBlue,
          rangeThumbShape: MySliderThumb(),
          valueIndicatorColor: MyColors.darkGrey,
          showValueIndicator: ShowValueIndicator.always,
          rangeTrackShape: MySliderTrackShape(sliderRangeValues: _values, position: position.inSeconds.toDouble())
        ),
        child: SongSingleton.instance.beatPath != null
            ? RangeSlider(
          values: _values,
          min: 0.0,
          max: duration.inSeconds.toDouble() + 0.1,
          divisions: 300,
          labels: RangeLabels(
              getDurationFormatted(Duration(seconds: _values.start.toInt())),
              getDurationFormatted(Duration(seconds: _values.end.toInt()))
          ),
          onChanged: (RangeValues values) {
            setState(() {
              if (values.end - values.start >= 5) {
                _values = values;
              } else {
                if (_values.start == values.start) {
                  _values = RangeValues(_values.start, _values.start + 10);
                } else {
                  _values = RangeValues(_values.end - 10, _values.end);
                }
              }
              seekToSecond(values.start.toInt());
              //setLoop();
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
      updateIcon(Icons.play_circle_outline);
      if (this.mounted)
        setState(() {
          seekToSecond(0);
        });
    }
  }

  setLoop() async {
    while(playerState == AudioPlayerState.PLAYING) {
      debugPrint("Position ${position.inSeconds.toDouble()} | valued end ${_values.end}");
      if(position.inSeconds.toDouble() >= _values.end) {
        seekToSecond(_values.start.toInt());
      }
    }
  }
//
  /// Starts playing the beat located at the beatPath of the SongSingleton
  playSong() async {
    if(SongSingleton.instance.isLocal == false && SongSingleton.instance.isAsset == true) {
      cache.play(SongSingleton.instance.beatPath);
      await setLoop();
    }
    else if(SongSingleton.instance.isLocal == true && SongSingleton.instance.isAsset == false) {
      player.play(SongSingleton.instance.beatPath,
          isLocal: SongSingleton.instance.isLocal);
      await setLoop();
    }
    updateIcon(Icons.pause_circle_outline);
  }

  /// Sets the player in pause
  void pauseSong() {
    if(player != null) {
      player.pause();
      updateIcon(Icons.play_circle_outline);
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
                        SongSingleton.instance.getName().replaceAll("_", " "),
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
                      icon: Icon(Icons.fast_rewind, color: MyColors.startElementColor,),
                      onPressed: () => { fastMoving(-5) }
                  ),
                  IconButton(
                    icon: Icon(playPauseIcon, color: MyColors.startElementColor),
                    iconSize: 40,
                    onPressed: () => { playPause() },
                  ),
                  IconButton(
                      icon: Icon(Icons.fast_forward, color: MyColors.startElementColor,),
                      onPressed: () => { fastMoving(5) }
                  ),
                  Container(width: 5,),
                  /*IconButton(
                    icon: Icon(Icons.repeat, color: MyColors.startElementColor),
                    iconSize: 40,
                    onPressed: () => { stopSong() },
                  )*/
                ],
              ),
              //row del player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    getDurationFormatted(position),
                    style: textStyle,
                  ),
                  Expanded(
                    child: createSlider()
                  ),
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

  fastMoving(int i) {
    int newPosition = position.inSeconds + i;
    //check if newPosition is inside the range of the SONG
    if(newPosition <= duration.inSeconds && newPosition >= 0) {
      //check if newPosition is inside the range of the SLIDER
      if(newPosition <= _values.end.toInt() && newPosition >= _values.start.toInt()) {
        seekToSecond(position.inSeconds + i);
      }
    }
  }
}

class MySliderTrackShape extends RangeSliderTrackShape {

  final RangeValues sliderRangeValues;
  final double position;

  MySliderTrackShape({
    Key key,
    @required this.sliderRangeValues,
    @required this.position
  });


  @override
  Rect getPreferredRect({RenderBox parentBox, Offset offset = Offset.zero, SliderThemeData sliderTheme, bool isEnabled, bool isDiscrete}) {
    final double thumbWidth =
        sliderTheme.rangeThumbShape.getPreferredSize(true, isDiscrete).width + 20;
    final double trackHeight = sliderTheme.trackHeight;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + thumbWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - thumbWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset, {RenderBox parentBox, SliderThemeData sliderTheme, Animation<double> enableAnimation, Offset startThumbCenter, Offset endThumbCenter, bool isEnabled, bool isDiscrete, TextDirection textDirection}) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final double thumbWidth =
        sliderTheme.rangeThumbShape.getPreferredSize(true, isDiscrete).width + 20;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final double trackDyPosition = offset.dy + trackRect.height * 4.8;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    final Paint positionPaint = Paint()
      ..color = MyColors.electricBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    Offset initInactivePoint = Offset(offset.dx + thumbWidth / 2, trackDyPosition);
    Offset endInactivePoint = Offset(offset.dx + trackRect.width + thumbWidth / 2, trackDyPosition);

    Offset initActivePoint = Offset(initInactivePoint.dx + sliderRangeValues.start * 1.6, trackDyPosition);
    Offset endActivePoint = Offset(initActivePoint.dx + (sliderRangeValues.end - sliderRangeValues.start)*1.6, trackDyPosition);

    Offset initPositionPoint = Offset(initActivePoint.dx , trackDyPosition);
    Offset endPositionPoint = Offset(initInactivePoint.dx + (position)*1.6, trackDyPosition);

    context.canvas.drawLine(initInactivePoint, endInactivePoint, inactivePaint);
    context.canvas.drawLine(initActivePoint, endActivePoint, activePaint);
    context.canvas.drawLine(initPositionPoint, endPositionPoint, positionPaint);
    //debugPrint("InitPosition ${initPositionPoint.dx} | EndPosition ${endPositionPoint.dx}");
  }
}

class MySliderThumb extends RangeSliderThumbShape {
  final double thumbRadius = 8.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0.1,0.1);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation, Animation<double> enableAnimation, bool isDiscrete,
        bool isEnabled, bool isOnTop, TextDirection textDirection, SliderThemeData sliderTheme, Thumb thumb}) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCenter(center: center, width: 5.0, height: 20.0);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(rect.left - 1, rect.top),
        Offset(rect.right + 1, rect.bottom),
      ),
      Radius.circular(thumbRadius - 2),
    );

    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = MyColors.darkGrey
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);
  }

}
