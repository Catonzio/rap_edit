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
            trackHeight: MediaQuery.of(context).size.width*0.013,
            inactiveTrackColor: MyColors.softGrey,
            activeTrackColor: MyColors.textColor,
            thumbColor: MyColors.electricBlue,
            rangeThumbShape: CstmSliderThumb(),
            valueIndicatorColor: MyColors.darkGrey,
            rangeTrackShape: CstmSliderTrackShape(
                sliderRangeValues: AudioPlayerController.rangeValues,
                position: widget.controller.positionSeconds(),
                duration: widget.controller.durationSeconds()
            ),
          ),
          child: SongSingleton.instance.beatPath != null && widget.controller.durationSeconds() != 0
              ? RangeSlider(
            values: AudioPlayerController.rangeValues,
            min: 0.0,
            max: widget.controller.durationSeconds(),
            divisions: 300,
            labels: RangeLabels(
                AudioPlayerController.getDurationFormatted(Duration(seconds: AudioPlayerController.rangeValues.start.toInt())),
                AudioPlayerController.getDurationFormatted(Duration(seconds: AudioPlayerController.rangeValues.end.toInt()))
            ),
            onChanged: (RangeValues values) {
              setState(() {
                var oldStart = AudioPlayerController.rangeValues.start;
                if (values.end - values.start >= 5) {
                  AudioPlayerController.rangeValues = values;
                } else {
                  if (AudioPlayerController.rangeValues.start == values.start) {
                    if(AudioPlayerController.rangeValues.start + 10 <= widget.controller.durationSeconds())
                      AudioPlayerController.rangeValues = RangeValues(
                          AudioPlayerController.rangeValues.start,
                          AudioPlayerController.rangeValues.start + 10
                      );
                  } else {
                    if(AudioPlayerController.rangeValues.end - 10 >= 0)
                      AudioPlayerController.rangeValues = RangeValues(
                          AudioPlayerController.rangeValues.end - 10,
                          AudioPlayerController.rangeValues.end
                      );
                  }
                }
                if(AudioPlayerController.rangeValues.end < widget.controller.positionSeconds())
                  widget.controller.seekToSecond(AudioPlayerController.rangeValues.end.toInt());
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

