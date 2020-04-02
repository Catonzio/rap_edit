import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';

import '../drawer/CstmDrawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Recorder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CstmDrawer(null)
    );
  }
}

class Trials extends StatefulWidget {

  @override
  _TrialsState createState() => _TrialsState();
}

class _TrialsState extends State<Trials> {
  RangeValues _values = RangeValues(0.3, 0.7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CstmBackGround(
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SliderTheme(
                  data: SliderThemeData(
                    thumbSelector: _customRangeThumbSelector,
                  ),
                  child: RangeSlider(
                      values: _values,
                      min: 0,
                      max: 100,
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
                        });
                      }
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
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
}
