import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmDrawer extends StatefulWidget {
  
  @override
  CstmDrawerState createState() => CstmDrawerState();
}

class CstmDrawerState extends State<CstmDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: DrawerPainter(),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: MaterialButton(
                    child: Icon(Icons.cancel, size: 30,),
                    onPressed: () => { debugPrint("Cancel") },
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 80, 0),
                  child: MaterialButton(
                    child: Text("Load"),
                    onPressed: () => { debugPrint("Load") },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  
}

class DrawerPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint arc = Paint()
        ..color = MyColors.darkRed
        ..style = PaintingStyle.fill;

    Offset firstPoint = Offset(0, 0);
    Offset secondPoint = Offset(size.width/2, size.height / 2);

    Rect center = Rect.fromCircle(
      center: Offset(0, size.height/28),
      radius: size.height/2
    );

    canvas.drawArc(center, 0, pi/2, true, arc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

