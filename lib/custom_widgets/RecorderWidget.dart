import 'dart:async';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/FileController.dart';
import 'CstmAlertDialog.dart';
import 'CstmTextField.dart';

class RecorderWidget extends StatefulWidget {

  @override
  RecorderWidgetState createState() => RecorderWidgetState();
}

class RecorderWidgetState extends State<RecorderWidget> {

  String cuntdownString = "";
  Timer cuntdownTimer;
  String title;
  IconData registerIcon;

  @override
  void initState() {
    super.initState();
    registerIcon = Icons.play_arrow;
  }

  @override
  void dispose() {
    if(cuntdownTimer != null)
      cuntdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final registerButton = RawMaterialButton(
      child: RawMaterialButton(
        shape: new CircleBorder(),
        fillColor: Colors.red,
        child: Icon(registerIcon),
        onPressed: () => { displayAlertWhereToSave(context) },
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      //padding: const EdgeInsets.all(15.0),
    );


    return Container(
      child: Row(
        children: <Widget>[
          registerButton,
          Container(width: 1,),
          Text(cuntdownString)
        ],
      ),
    );
  }

  mySetState(String str) {
    setState(() {
      cuntdownString = str;
    });
  }

  startCountdown() async {
    int start = 3;
    startRecording();
    cuntdownTimer = new Timer.periodic(Duration(seconds: 1),
      (Timer timer) => setState(() {
          if (start > 0) {
            mySetState(start.toString());
            start = start - 1;
          } else if(start == 0) {
            mySetState("recording");
            start = start - 1;
          }
          else {
            timer.cancel();
          }
        },
      )
    );
  }

  void startStopRecording() {
    if(registerIcon == Icons.pause) {
      stopRecording();
      updateIcon(Icons.play_arrow);
    }
    else if(registerIcon == Icons.play_arrow) {
      startCountdown();
      updateIcon(Icons.pause);
    }
  }

  stopRecording() async {
    Recording recording = await AudioRecorder.stop();
    debugPrint("Path : ${recording.path},"
        "  Format : ${recording.audioOutputFormat},"
        "  Duration : ${recording.duration},"
        "  Extension : ${recording.extension},");
  }


  startRecording() async {
      debugPrint("Start recording");
      PermissionHandler permissionHandler = PermissionHandler();
      var result = await permissionHandler.requestPermissions([PermissionGroup.microphone]);
      if(result[PermissionGroup.microphone] == PermissionStatus.granted) {
        Directory downloadDirectory = await getApplicationDocumentsDirectory();
        Future.delayed(Duration(seconds: 4), () async => { await AudioRecorder
            .start(path: downloadDirectory.path + '/' + title,
            audioOutputFormat: AudioOutputFormat.WAV) });
      }
  }

  displayAlertWhereToSave(BuildContext context) {
    TextEditingController controller = TextEditingController();
    if(registerIcon == Icons.play_arrow) {
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
              controller: controller,
              hintText: "insert title",
            )
          ],
        ),
        pressed: () {
          setState(() {
            title = controller.text;
            startStopRecording();
          });
          Navigator.pop(context);
        },
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else if(registerIcon == Icons.pause) {
      startStopRecording();
    }
  }

  void updateIcon(IconData icon) {
    setState(() {
      registerIcon = icon;
    });
  }

}