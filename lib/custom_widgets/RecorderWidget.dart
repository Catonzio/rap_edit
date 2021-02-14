import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/RecorderController.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../controllers/FileController.dart';
import 'CstmAlertDialog.dart';
import 'CstmTextField.dart';

class RecorderWidget extends StatefulWidget {

  final RecorderWidgetState state = RecorderWidgetState();

  @override
  RecorderWidgetState createState() => state;

  void stopRecording() {
    state?.stopRecording();
  }
}

class RecorderWidgetState extends State<RecorderWidget> {

  RecorderController controller;
  String countdownString;
  //IconData registerIcon;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<RecorderController>(context, listen: false);

  }

  @override
  void dispose() {
    if(controller != null) {
      controller?.deleteTimer();
    }
    stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final registerButton = RawMaterialButton(
      child: RawMaterialButton(
        shape: new CircleBorder(),
        fillColor: MyColors.darkRed,
        //child: Icon(registerIcon),
        onPressed: () => { displayAlertWhereToSave(context) },
      ),
      shape: new CircleBorder(side: BorderSide(width: 2.5)),
      //elevation: 2.0,
      fillColor: Colors.white,
      onPressed: () => { displayAlertWhereToSave(context) },
      //padding: const EdgeInsets.all(15.0),
    );

    return Container(
      child: Row(
        children: <Widget>[
          registerButton,
          Container(width: 5,),
          Text("${controller?.countdownString}")
        ],
      ),
    );
  }

  startCountdown() {
    controller?.startCountdown();
  }

  stopRecording() {
    controller.stopRecording();
  }

  prepareRecording(String title) async {
    !FileController.existsRecord(title)
        ? controller?.recordingName = title
        : controller?.recordingName = FileController.manageName(title);
    if(await controller.prepare()) {
      startCountdown();
    }
    Navigator.pop(context);
  }

  displayAlertWhereToSave(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    if(SongSingleton.instance.currentSong != null) {
      editingController.text = SongSingleton.instance.currentSong.title;
    }
    if(!controller.isRecording()) {
      Widget alert = CstmAlertDialog(
        dialogTitle: "Recording",
        continueText: "Ok",
        height: 100,
        body: Column(
          children: <Widget>[
            Text("Registration name?"),
            SizedBox(height: 20.0,),
            CstmTextField(
              maxLines: 1,
              controller: editingController,
              hintText: "insert title",
            )
          ],
        ),
        pressed: () {
          prepareRecording(editingController.text);
          setState(() {
            //countdownString = controller?.countdownString;
          });
        }
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else if(controller.isRecording()) {
      stopRecording();
    }
  }


}