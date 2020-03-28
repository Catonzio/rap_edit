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

class AudioPlayerTrialsState extends State<AudioPlayerTrials> {

  static AudioPlayer player;
  static AudioCache cache;
  static AudioPlayerState playerState;
  static Duration duration;
  static Duration position;

  static IconData playPauseIcon = Icons.play_circle_outline;
  TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 15);

  bool _valuesInitialized = false;

  @override
  void initState() {
    super.initState();
    SongSingleton.instance.beatPath = "Rap_Instrumental_Beat.mp3";
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
    initPlayer();
    setState(() {
      _values = RangeValues(position.inSeconds.toDouble(), duration?.inSeconds?.toDouble()??10.0);
    });
  }

  void initPlayer() {
    try {
      if (player == null) {
        player = new AudioPlayer();
        duration = new Duration();
        position = new Duration();
      }
      /*if(!_valuesInitialized) {
        _values = _values ?? RangeValues(0, 0);
        setState(() {
          _valuesInitialized = true;
        });
      }*/
      player.onDurationChanged.listen((Duration d) {
        if (this.mounted)
          setState(() {duration = d;});
      });

      player.onAudioPositionChanged.listen((Duration p) {
        if (this.mounted)
          setState(() {
            position = p;
            /*if(_valuesInitialized) {
              _values = RangeValues(position.inSeconds.toDouble(), duration.inSeconds.toDouble());
            }*/
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

      cache = AudioCache(fixedPlayer: player);

      if (SongSingleton.instance.beatPath != null &&
          SongSingleton.instance.beatPath.isNotEmpty && player != null) {
        playSong();
        if(SongSingleton.instance.isAsset == true) {
          //pauseSong();
        } else {
          pauseSong();
        }
      }
      /*do {

      }while(duration == Duration(seconds: 0));*/
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

  RangeValues _values;

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
          labels: RangeLabels(getDurationFormatted(Duration(seconds: _values.start.toInt())), getDurationFormatted(Duration(seconds: _values.end.toInt()))),
          //activeColor: Theme.of(context).primaryColor,
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
      if(position.inSeconds.toDouble() == _values.end || position.inSeconds.toDouble() > _values.end) {
        seekToSecond(_values.start.toInt());
      }
    }
  }

  /// Starts playing the beat located at the beatPath of the SongSingleton
  playSong() {
    if(SongSingleton.instance.isLocal == false && SongSingleton.instance.isAsset == true) {
      cache.play(SongSingleton.instance.beatPath);
      setLoop();
    }
    else if(SongSingleton.instance.isLocal == true && SongSingleton.instance.isAsset == false) {
      player.play(SongSingleton.instance.beatPath,
          isLocal: SongSingleton.instance.isLocal);
      setLoop();
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
                    child: CustomPaint(
                      foregroundPainter: CompletionPainter(
                        completeColor: Colors.red,
                        position: position.inSeconds.toDouble(),
                        start: _values.start,
                        max: _values.end,
                        width: 4.5
                      ),
                      child: createSlider(),
                    )
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
    debugPrint("InitPosition ${initPositionPoint.dx} | EndPosition ${endPositionPoint.dx}");
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

class CompletionPainter extends CustomPainter{
  Color completeColor;
  double position;
  double start;
  double max;
  double width;

  CompletionPainter({
    Key key,
    this.completeColor,
    this.position,
    this.start,
    this.max,
    this.width
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
        ..color = completeColor
        //..strokeCap = StrokeCap.square
        ..strokeWidth = width;
    //debugPrint("Width: ${size.width}");
    //debugPrint("Start: $start");

    double beginOffset = 24 + start;

    Offset init = Offset(beginOffset, size.height/2);
    double finalPos = min(start, max);
    Offset end = Offset(beginOffset + position*1.38, size.height/2);

    //canvas.drawLine(init, end, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


}