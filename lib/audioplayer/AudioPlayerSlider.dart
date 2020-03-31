import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'AudioPlayerController.dart';

class AudioPlayerSlider extends StatefulWidget {

  final AudioPlayerController controller;

  AudioPlayerSlider(this.controller);

  @override
  AudioPlayerSliderState createState() => AudioPlayerSliderState();
}

class AudioPlayerSliderState extends State<AudioPlayerSlider> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 5.0,
            inactiveTrackColor: MyColors.softGrey,
            activeTrackColor: MyColors.textColor,
            thumbColor: MyColors.electricBlue,
            rangeThumbShape: MySliderThumb(),
            valueIndicatorColor: MyColors.darkGrey,
            rangeTrackShape: MySliderTrackShape(
                sliderRangeValues: widget.controller.rangeValues,
                position: widget.controller.positionSeconds(),
                duration: widget.controller.durationSeconds()
            ),
          ),
          child: SongSingleton.instance.beatPath != null
              ? RangeSlider(
            values: widget.controller.rangeValues,
            min: 0.0,
            max: widget.controller.durationSeconds() + 0.1,
            divisions: 300,
            labels: RangeLabels(
                widget.controller.getDurationFormatted(Duration(seconds: widget.controller.rangeValues.start.toInt())),
                widget.controller.getDurationFormatted(Duration(seconds: widget.controller.rangeValues.end.toInt()))
            ),
            onChanged: (RangeValues values) {
              setState(() {
                var oldStart = widget.controller.rangeValues.start;
                if (values.end - values.start >= 5) {
                  widget.controller.rangeValues = values;
                } else {
                  if (widget.controller.rangeValues.start == values.start) {
                    widget.controller.rangeValues = RangeValues(
                        widget.controller.rangeValues.start,
                        widget.controller.rangeValues.start + 10
                    );
                  } else {
                    widget.controller.rangeValues = RangeValues(
                        widget.controller.rangeValues.end - 10,
                        widget.controller.rangeValues.end
                    );
                  }
                }
                if(widget.controller.rangeValues.end < widget.controller.positionSeconds())
                  widget.controller.seekToSecond(widget.controller.rangeValues.end.toInt());
                if(oldStart != values.start)
                  widget.controller.seekToSecond(values.start.toInt());
              });
            },
          )
              : RangeSlider(
            values: RangeValues(0,0),
            onChanged: (RangeValues values) => {},
          )
      ),
    );
  }

}

class MySliderTrackShape extends RangeSliderTrackShape {

  final RangeValues sliderRangeValues;
  final double position;
  final double duration;

  static double myOffsetDx;
  static double myTrackWidth;

  MySliderTrackShape({
    Key key,
    @required this.sliderRangeValues,
    @required this.position,
    @required this.duration
  });


  @override
  Rect getPreferredRect({RenderBox parentBox, Offset offset = Offset.zero, SliderThemeData sliderTheme, bool isEnabled, bool isDiscrete}) {
    if(MySliderTrackShape.myOffsetDx == null)
      MySliderTrackShape.myOffsetDx = offset.dx;

    final double thumbWidth =
        sliderTheme.rangeThumbShape.getPreferredSize(true, isDiscrete).width + 20;
    final double trackHeight = sliderTheme.trackHeight;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = myOffsetDx + thumbWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - thumbWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset, {RenderBox parentBox, SliderThemeData sliderTheme, Animation<double> enableAnimation, Offset startThumbCenter, Offset endThumbCenter, bool isEnabled, bool isDiscrete, TextDirection textDirection}) {
    assert(sliderTheme.trackHeight != 0);

    if(myOffsetDx == null)
      myOffsetDx = offset.dx;

    //width of the thumb
    final double thumbWidth =
        sliderTheme.rangeThumbShape.getPreferredSize(true, isDiscrete).width + 20;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    if(myTrackWidth == null)
      myTrackWidth = trackRect.width;

    //4.8 is an empirical value; this is the dy position where the slider should be
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

    //starting and ending points of the inactive track
    Offset initInactivePoint = Offset(myOffsetDx + thumbWidth / 2, trackDyPosition);
    Offset endInactivePoint = Offset(myOffsetDx + myTrackWidth + thumbWidth / 2, trackDyPosition);
    debugPrint("TrackRect.width: $myTrackWidth | ThumbWidth: $thumbWidth");
    //factor with which every active line is multiplied; it needs to normalize the length to the duration of the song
    double scalarFactor = duration != 0
                          ? (endInactivePoint.dx - initInactivePoint.dx) / duration
                          : 0.0;

    //starting and ending points of the active track
    Offset initActivePoint = Offset(initInactivePoint.dx + sliderRangeValues.start * scalarFactor, trackDyPosition);
    Offset endActivePoint = Offset(initActivePoint.dx + (sliderRangeValues.end - sliderRangeValues.start)*scalarFactor, trackDyPosition);

    //starting and ending points of the position track
    Offset initPositionPoint = Offset(initActivePoint.dx , trackDyPosition);
    Offset endPositionPoint = Offset(initInactivePoint.dx + (position)*scalarFactor, trackDyPosition);

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

    debugPrint("Center: ${center.dx}");
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
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);
  }

}