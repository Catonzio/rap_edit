import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/drawer/CstmDrawerLine.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmDrawer extends StatefulWidget {
  
  @override
  CstmDrawerState createState() => CstmDrawerState();
}

class CstmDrawerState extends State<CstmDrawer> {

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawerPainter(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RawMaterialButton(
                padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                shape: CircleBorder(),
                child: Icon(Icons.cancel, size: 40,),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.fromLTRB(0, 0, 60, 0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.save),
                    Container(width: 10,),
                    Text("Save Text", style: TextStyle(fontSize: 20),)
                  ],
                ),
                onPressed: () => { debugPrint("Save") },
              ),
            ],
          ),
          SizedBox(height: 30,),
          CstmDrawerLine(),
          SizedBox(height: 30,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("Load Texts", style: TextStyle(fontSize: 20),),
                onPressed: () => { debugPrint("Load") },
              ),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.fromLTRB(0, 0, 120, 0),
                child: Text("Load Recs", style: TextStyle(fontSize: 20),),
                onPressed: () => { debugPrint("Load") },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DrawerPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint arc = Paint()
        ..color = MyColors.electricBlue
        ..style = PaintingStyle.fill;

    Rect center2 = Rect.fromLTRB(-size.width, -size.height/2, size.width/1.1, size.height/2);

    Rect center = Rect.fromCircle(
      center: Offset(0, size.height/30),
      radius: size.height/2
    );

    LinearGradient gradient = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [MyColors.endElementColor, MyColors.primaryColor]
    );
    arc.shader = gradient.createShader(center2);

    canvas.drawArc(center2, 0, pi/2, true, arc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

