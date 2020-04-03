import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/drawer/CstmDrawerLine.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmDrawer extends StatefulWidget {

  MyPageInterface page;

  CstmDrawer(this.page);

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
        children: getButtons(),
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
        if(widget.page != null && widget.page is WritingPageState) {
          WritingPageState write = widget.page as WritingPageState;
          write.saveFile(context, titleController.text.trim());
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

  List<Widget> getButtons() {
    List<Widget> buttons = List();
    createButtons().forEach((key, val) => buttons.add(val));
    return buttons;
  }

  Map createButtons() {
    var buttonsMap = Map();
    buttonsMap[ButtonsNames.sized30] = SizedBox(height: 30,);
    buttonsMap[ButtonsNames.sized10] = SizedBox(height: 10,);

    buttonsMap[ButtonsNames.buttonCancel] = Row(
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
    );

    buttonsMap[ButtonsNames.buttonSave] = CstmDrawerLine(
      text: "Save text",
      icon: Icons.save,
      pressed: () => { alertSaveText(context) },
    );

    buttonsMap[ButtonsNames.buttonLoadBeats] = CstmDrawerLine(
      text: "Load beats",
      icon: Icons.queue_music,
      pressed: () => { widget.page.loadChoosingBeatsPage() },
    );

    buttonsMap[ButtonsNames.buttonLoadTexts] = CstmDrawerLine(
      text: "Load texts",
      icon: Icons.file_upload,
      pressed: () => { widget.page.loadTextsPage() },
    );

    buttonsMap[ButtonsNames.buttonLoadRecs] = CstmDrawerLine(
      text: "Load recs",
      pressed: () => { widget.page.loadRegistrationsPage() },
      icon: Icons.record_voice_over,
    );

    buttonsMap[ButtonsNames.buttonWrite] = CstmDrawerLine(
      text: "Write text",
      pressed: () => { widget.page.loadWritingPage() },
      icon: Icons.edit,
    );

    return buttonsMap;
  }
}

class ButtonsNames {
  static String sized30 = 'sized30';
  static String sized10 = 'sized10';
  static String buttonCancel = 'buttonCancel';
  static String buttonSave = 'buttonSave';
  static String buttonLoadBeats = 'buttonLoadBeats';
  static String buttonLoadTexts = 'buttonLoadTexts';
  static String buttonLoadRecs = 'buttonLoadRecs';
  static String buttonWrite = 'buttonWrite';
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

