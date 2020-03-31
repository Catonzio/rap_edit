import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmSliderTrackShape extends RangeSliderTrackShape {

  final RangeValues sliderRangeValues;
  final double position;
  final double duration;

  CstmSliderTrackShape({
    Key key,
    @required this.sliderRangeValues,
    @required this.position,
    @required this.duration
  });


  @override
  Rect getPreferredRect({RenderBox parentBox, Offset offset = Offset.zero, SliderThemeData sliderTheme, bool isEnabled, bool isDiscrete}) {

    final double thumbWidth =
        sliderTheme.rangeThumbShape.getPreferredSize(true, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + thumbWidth;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - thumbWidth*2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset, {RenderBox parentBox, SliderThemeData sliderTheme, Animation<double> enableAnimation, Offset startThumbCenter, Offset endThumbCenter, bool isEnabled, bool isDiscrete, TextDirection textDirection}) {
    assert(sliderTheme.trackHeight != 0);

    //width of the thumb
    final double thumbWidth =
        sliderTheme.rangeThumbShape.getPreferredSize(true, isDiscrete).width;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

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
    Offset initInactivePoint = Offset(offset.dx, trackDyPosition);
    Offset endInactivePoint = Offset(offset.dx + parentBox.size.width, trackDyPosition);

    //factor with which every active line is multiplied; it needs to normalize the length to the duration of the song

    //starting and ending points of the active track
    Offset initActivePoint = Offset(startThumbCenter.dx + thumbWidth, trackDyPosition);
    Offset endActivePoint = Offset(endThumbCenter.dx - thumbWidth, trackDyPosition);

    double scalarFactor = duration != 0
        ? ((endInactivePoint.dx - thumbWidth) - (initInactivePoint.dx + thumbWidth)) / duration
        : 0.0;

    //starting and ending points of the position track
    Offset initPositionPoint = Offset(initActivePoint.dx, trackDyPosition);
    Offset endPositionPoint = Offset(initInactivePoint.dx + (position)*scalarFactor, trackDyPosition);

    context.canvas.drawLine(initInactivePoint, endInactivePoint, inactivePaint);
    context.canvas.drawLine(initActivePoint, endActivePoint, activePaint);
    context.canvas.drawLine(initPositionPoint, endPositionPoint, positionPaint);
  }
}

class CstmSliderThumb extends RangeSliderThumbShape {
  final double thumbRadius = 8.0;
  final double thumbWidth = 3.0;
  final double thumbHeigth = 20.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeigth);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation, Animation<double> enableAnimation, bool isDiscrete,
        bool isEnabled, bool isOnTop, TextDirection textDirection, SliderThemeData sliderTheme, Thumb thumb}) {

    final Canvas canvas = context.canvas;

    final rect = Rect.fromCenter(center: center, width: thumbWidth, height: thumbHeigth);

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