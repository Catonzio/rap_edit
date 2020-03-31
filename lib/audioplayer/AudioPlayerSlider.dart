import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'AudioPlayerController.dart';
import 'CstmShapes.dart';

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
            rangeThumbShape: CstmSliderThumb(),
            valueIndicatorColor: MyColors.darkGrey,
            rangeTrackShape: CstmSliderTrackShape(
                sliderRangeValues: widget.controller.rangeValues,
                position: widget.controller.positionSeconds(),
                duration: widget.controller.durationSeconds()
            ),
          ),
          child: SongSingleton.instance.beatPath != null && widget.controller.durationSeconds() != 0
              ? RangeSlider(
            values: widget.controller.rangeValues,
            min: 0.0,
            max: widget.controller.durationSeconds(),
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
                    if(widget.controller.rangeValues.start + 10 <= widget.controller.durationSeconds())
                      widget.controller.rangeValues = RangeValues(
                          widget.controller.rangeValues.start,
                          widget.controller.rangeValues.start + 10
                      );
                  } else {
                    if(widget.controller.rangeValues.end - 10 >= 0)
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

