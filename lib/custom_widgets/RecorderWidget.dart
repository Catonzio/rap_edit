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

  String cuntdownString = "";
  RecorderController controller;
  //IconData registerIcon;

  @override
  void initState() {
    super.initState();
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

    controller = Provider.of<RecorderController>(context, listen: true);

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
          Text("${getRecordingText()}")
        ],
      ),
    );
  }

  mySetState(String str) {
    if(mounted)
      setState(() {
        cuntdownString = str ?? "";
      });
  }

  String getRecordingText() {
    try {
      return int.parse(cuntdownString) != null ? cuntdownString : "";
    } catch(ex) {
      return cuntdownString + " " + getDurationFormatted(controller?.getRecordingDuration());
    }
  }

  /// Returns the Duration displayed as 'minute':'seconds'
  String getDurationFormatted(Duration dur) {
    //se dur è != null, ritorna dur.toString(); altrimenti, Duration().toString()
    String pos = dur?.toString() ?? "";
    return pos.contains(":") ? pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf(".")) : pos;
  }

  startCountdown() {
    controller?.startCountdown(mySetState);
  }

  stopRecording() async {
    bool rec = await controller.stopRecording();
    if(rec) {
      mySetState("saved");
    } else {
      debugPrint("oooooooooo can't stop");
    }
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
        pressed: () => { prepareRecording(editingController.text) }
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