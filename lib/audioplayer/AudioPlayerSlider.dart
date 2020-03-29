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
    return SliderTheme(
        data: SliderThemeData(
          trackHeight: 5.0,
          inactiveTrackColor: MyColors.softGrey,
          activeTrackColor: MyColors.textColor,
          thumbColor: MyColors.electricBlue,
          rangeThumbShape: MySliderThumb(),
          valueIndicatorColor: MyColors.darkGrey,
          rangeTrackShape: MySliderTrackShape(sliderRangeValues: widget.controller.rangeValues, position: widget.controller.positionSeconds()),
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
              if(widget.controller.rangeValues.end < widget.controller.position.inSeconds.toDouble())
                widget.controller.seekToSecond(widget.controller.rangeValues.end.toInt());
              if(oldStart != values.start)
                widget.controller.seekToSecond(values.start.toInt());
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