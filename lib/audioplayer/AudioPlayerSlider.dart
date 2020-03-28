import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'AudioPlayerController.dart';

class AudioPlayerSlider extends StatefulWidget {

  @override
  AudioPlayerSliderState createState() => AudioPlayerSliderState();
}

class AudioPlayerSliderState extends State<AudioPlayerSlider> {

  /// Returns the Duration displayed as 'minute':'seconds'
  String getDurationFormatted(Duration dur) {
    //se dur è != null, ritorna dur.toString(); altrimenti, Duration().toString()
    String pos = dur?.toString() ?? Duration().toString();
    return pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf("."));
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderThemeData(
          trackHeight: 5.0,
          inactiveTrackColor: MyColors.softGrey,
          activeTrackColor: MyColors.textColor,
          thumbColor: MyColors.electricBlue,
          rangeThumbShape: MySliderThumb(),
          valueIndicatorColor: MyColors.darkGrey,
          rangeTrackShape: MySliderTrackShape(sliderRangeValues: AudioPlayerController.instance.rangeValues, position: AudioPlayerController.instance.positionSeconds()),
        ),
        child: SongSingleton.instance.beatPath != null
            ? RangeSlider(
          values: AudioPlayerController.instance.rangeValues,
          min: 0.0,
          max: AudioPlayerController.instance.durationSeconds() + 0.1,
          divisions: 300,
          labels: RangeLabels(
              getDurationFormatted(Duration(seconds: AudioPlayerController.instance.rangeValues.start.toInt())),
              getDurationFormatted(Duration(seconds: AudioPlayerController.instance.rangeValues.end.toInt()))
          ),
          onChanged: (RangeValues values) {
            setState(() {
              if (values.end - values.start >= 5) {
                AudioPlayerController.instance.rangeValues = values;
              } else {
                if (AudioPlayerController.instance.rangeValues.start == values.start) {
                  AudioPlayerController.instance.rangeValues = RangeValues(
                      AudioPlayerController.instance.rangeValues.start,
                      AudioPlayerController.instance.rangeValues.start + 10
                  );
                } else {
                  AudioPlayerController.instance.rangeValues = RangeValues(
                      AudioPlayerController.instance.rangeValues.end - 10,
                      AudioPlayerController.instance.rangeValues.end
                  );
                }
              }
            });
          },
        )
            : Slider(
          value: 0.0,
          onChanged: (double val) => {},
        )
    );
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