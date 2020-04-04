import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rap_edit/Trials/ChoosingBeatsDuration.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/drawer/CstmDrawerLine.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/MixingAudioPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/RegistrationsPage.dart';
import 'package:rap_edit/pages/TextsPage.dart';
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
  List<Widget> buttonsList;

  @override
  void initState() {
    super.initState();
    buttonsList = List();
    createButtons().forEach((key, val) => buttonsList.add(val));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawerPainter(buttonsList),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: getButtons(),
      ),
    );
  }

  List<Widget> getButtons() {
    var buttonsMap = createButtons();
    List<Widget> buttons = List();
    buttons.add(buttonsMap[ButtonsNames.buttonCancel]);

    if(widget.page is WritingPageState) {
      WritingPageState state = widget.page as WritingPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonWrite && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(widget.page is ChoosingBeatsPageState) {
      ChoosingBeatsPageState state = widget.page as ChoosingBeatsPageState;
      buttons.add(
          CstmDrawerLine(
            text: "Load YouTube",
            icon: Icons.play_circle_filled,
            pressed: () => { state.loadFromYoutubeAlertDialog(context) },
          )
      );
      buttons.add(
          CstmDrawerLine(
            text: "Load File System",
            icon: Icons.library_music,
            pressed: () => { state.loadFromFileSystem() },
          )
      );
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonLoadBeats && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(widget.page is RegistrationsPageState) {
      RegistrationsPageState state = widget.page as RegistrationsPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonLoadRecs && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(widget.page is TextsPageState) {
      TextsPageState state = widget.page as TextsPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonLoadTexts && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else if(widget.page is MixingAudioPageState) {
      MixingAudioPageState state = widget.page as MixingAudioPageState;
      buttonsMap.forEach((key, value) {
        if(key != ButtonsNames.buttonMixing && key != ButtonsNames.buttonCancel)
          buttons.add(value);
      });
    }

    else {
      buttonsMap.forEach((key, value) => { buttons.add(value) });
    }

    return buttons;
  }

  Map createButtons() {
    var buttonsMap = Map();

    //buttonsMap[ButtonsNames.sized30] = SizedBox(height: 30,);
    //buttonsMap[ButtonsNames.sized10] = SizedBox(height: 10,);

    buttonsMap[ButtonsNames.buttonCancel] = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        RawMaterialButton(
          padding: EdgeInsets.fromLTRB(0, 30, 25, 30),
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

    buttonsMap[ButtonsNames.buttonMixing] = CstmDrawerLine(
      text: "Mix audio",
      pressed: () => { widget.page.loadMixingAudioPage() },
      icon: Icons.library_music,
    );

    return buttonsMap;
  }
}

class ButtonsNames {
  static String sized30 = 'sized30';
  static String sized10 = 'sized10';
  static String buttonCancel = 'buttonCancel';
  static String buttonLoadBeats = 'buttonLoadBeats';
  static String buttonLoadTexts = 'buttonLoadTexts';
  static String buttonLoadRecs = 'buttonLoadRecs';
  static String buttonWrite = 'buttonWrite';
  static String buttonMixing = 'buttonMixing';
}

class DrawerPainter extends CustomPainter{

  List<Widget> buttonsList;

  DrawerPainter(this.buttonsList);

  @override
  void paint(Canvas canvas, Size size) {
    Paint arc = Paint()
      ..color = MyColors.electricBlue
      ..style = PaintingStyle.fill;

    double height =
    buttonsList == null || buttonsList.isEmpty
        ? size.height
        : (size.height - 90)/(11.5/buttonsList.length);

    RRect center2 = RRect.fromLTRBR(0, 0, size.width/2, height, Radius.circular(40));

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