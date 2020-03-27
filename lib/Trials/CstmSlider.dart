import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/support/MyColors.dart';


class CstmSlider extends StatefulWidget {

  @override
  CstmSliderState createState() => CstmSliderState();
}

class CstmSliderState extends State<CstmSlider> {

  double position = 0.0;
  double duration = 500.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: duration,
            child: CustomPaint(
              painter: SliderPainter(
                  lineColor: Colors.white,
                  completeColor: Colors.red,
                  completePercent: position,
                  width: 8.0
              ),
              child: Row(
                children: <Widget>[
                  IconButton(

                    icon: Icon(Icons.arrow_back_ios, color: MyColors.electricBlue,),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: MyColors.electricBlue,),
                  ),
                ],
              )
            ),
          ),
          Container(height: 30,),
          CstmButton(
            text: "Click",
            pressed: () => { increasePosition() },
          )
        ],
      )
    );
  }

  increasePosition() {
    setState(() {
      position += 20;
      if(position > duration) {
        position = 0.0;
      }
    });
  }

}

class SliderPainter extends CustomPainter {

  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  SliderPainter({
    Key key,
    this.lineColor,
    this.completeColor,
    this.completePercent,
    this.width
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset init = Offset(0, size.height/2);
    Offset end = Offset(size.width, size.height/2);
    Offset percentOffset = Offset(completePercent, size.height/2);
    canvas.drawLine(init, end, line);
    canvas.drawLine(init, percentOffset, complete);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}







class CstmCircle extends StatefulWidget {
  final String hello;
  CstmCircle({Key key, this.hello});

  @override
  CstmCircleState createState() => CstmCircleState();
}

class CstmCircleState extends State<CstmCircle> with TickerProviderStateMixin {

  double percentage = 0.0;
  double newPercentage = 0.0;
  AnimationController percentageAnimationController;

  @override
  void initState() {
    super.initState();
    percentageAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    )..addListener(() {
      setState(() {
        percentage = lerpDouble(percentage, newPercentage, percentageAnimationController.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200.0,
        width: 200.0,
        child: CustomPaint(
          foregroundPainter: MyPainter(
            lineColor: Colors.amber,
            completeColor: Colors.blueAccent,
            completePercent: percentage,
            width: 8.0
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.purple,
              splashColor: Colors.blueAccent,
              shape: CircleBorder(),
              child: Text("click"),
              onPressed: () {
                setState(() {
                  percentage = newPercentage;
                  newPercentage += 1;
                  if(percentage > 100) {
                    percentage = 0.0;
                    newPercentage = 0.0;
                  }
                  percentageAnimationController.forward(from: 0.0);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

}

class MyPainter extends CustomPainter {

  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;

  MyPainter({
    Key key,
    this.lineColor,
    this.completeColor,
    this.completePercent,
    this.width
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
        ..color = lineColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
    Paint complete = new Paint()
        ..color = completeColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;

    Offset center = new Offset(size.width/2, size.height/2);
    double radius = min(size.width/2, size.height/2);
    canvas.drawCircle(center, radius, line);

    double arcAngle = 2*pi*(completePercent/100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi/2, arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}