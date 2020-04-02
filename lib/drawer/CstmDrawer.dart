import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/drawer/CstmDrawerLine.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmDrawer extends StatefulWidget {

  WritingPageState writingPage;

  CstmDrawer(this.writingPage);

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
                child: Icon(Icons.cancel, size: 30,),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 30,),
          CstmDrawerLine(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            text: "Save text",
            icon: Icons.save,
            pressed: () => { alertSaveText(context) },
          ),
          SizedBox(height: 10,),
          CstmDrawerLine(
            text: "Load beats",
            icon: Icons.file_upload,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            pressed: () => { widget.writingPage.loadSong() },
          ),
          SizedBox(height: 10,),
          CstmDrawerLine(
            text: "Load texts",
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            icon: Icons.file_upload,
            pressed: () => { widget.writingPage.loadTexts() },
          ),
          SizedBox(height: 10,),
          CstmDrawerLine(
            text: "Load recs",
            pressed: () => { widget.writingPage.loadRecs() },
            icon: Icons.file_upload,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          )
        ],
      ),
    );
  }

  alertSaveText(BuildContext context) {
    TextEditingController titleController = new TextEditingController();

    if(SongSingleton.instance.currentSong != null && SongSingleton.instance.currentSong.title.isNotEmpty)
      titleController.text = SongSingleton.instance.currentSong.title;

    Widget alert = CstmAlertDialog(
      dialogTitle: "Saving",
      continueText: "Save",
      height: 100,
      body: Column(
        children: <Widget>[
          Text("How to save?"),
          SizedBox(height: 20.0,),
          CstmTextField(
            maxLines: 1,
            controller: titleController,
            hintText: "insert title",
          )
        ],
      ),
      pressed: () {
        if(widget.writingPage != null) {
          widget.writingPage.saveFile(context, titleController.text.trim());
          Navigator.pop(context);
        }
      },
    );

    // show the dialog
    showMyDialog(context, alert);
  }

  showMyDialog(BuildContext context, Widget alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class DrawerPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint arc = Paint()
        ..color = MyColors.electricBlue
        ..style = PaintingStyle.fill;

    //Rect center2 = Rect.fromLTRB(-size.width, -size.height/2, size.width/2, size.height/2);

    RRect center2 = RRect.fromLTRBR(0, 0, size.width/2, size.height/2, Radius.circular(40));

    LinearGradient gradient = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [MyColors.endElementColor, MyColors.primaryColor]
    );
    //arc.shader = gradient.createShader(center2);

    arc.shader = gradient.createShader(Rect.fromLTRB(center2.left, center2.top, center2.right, center2.bottom));
    //canvas.drawArc(center2, 0, pi/2, true, arc);
    canvas.drawRRect(center2, arc);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

