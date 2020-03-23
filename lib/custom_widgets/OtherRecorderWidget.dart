import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../controllers/FileController.dart';
import 'CstmAlertDialog.dart';
import 'CstmTextField.dart';

class OtherRecorderWidget extends StatefulWidget {

  @override
  OtherRecorderWidgetState createState() => OtherRecorderWidgetState();
}

class OtherRecorderWidgetState extends State<OtherRecorderWidget> {

  String cuntdownString = "";
  Timer cuntdownTimer;
  IconData registerIcon;

  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  String recordingName;

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

  _init() async {
    String appDocDirectory = FileController.filePath + "/";
    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    String customPath = appDocDirectory + recordingName;

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV);
    await _recorder.initialized;
  }

  _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
    startCountdown();
    await _init();
    var result = await _recorder.current();
    setState(() {
      _recording = result;
    });
    }
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
      //padding: const EdgeInsets.all(15.0),
    );


    return Container(
      child: Row(
        children: <Widget>[
          registerButton,
          Container(width: 5,),
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
    cuntdownTimer = new Timer.periodic(Duration(seconds: 1),
            (Timer timer) => setState(() {
          if (start > 0) {
            mySetState(start.toString());
            start = start - 1;
          } else if(start == 0) {
            mySetState("recording");
            startStopRecording();
            start = start - 1;
          }
          else {
            timer.cancel();
          }
        },
        )
    );
  }

  void startStopRecording() async {
    if(_recording.status == RecordingStatus.Recording) {
      stopRecording();
      mySetState("");
      updateIcon(Icons.play_arrow);
    }
    else if(_recording.status == RecordingStatus.Initialized) {
      startRecording();
      updateIcon(Icons.pause);
    }
  }

  stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  startRecording() async {
    debugPrint("Start recording");
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  displayAlertWhereToSave(BuildContext context) {
    TextEditingController controller = TextEditingController();
    if(SongSingleton.instance.currentSong != null) {
      controller.text = SongSingleton.instance.currentSong.title;
    }
    if(recordingName == null) {
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
            !FileController.existsRecord(controller.text)
            ?
              recordingName = controller.text
            :
              recordingName = FileController.manageName(controller.text);
            _prepare();
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
    } else if(_recording?.status == RecordingStatus.Recording) {
      startStopRecording();
    }
  }

  void updateIcon(IconData icon) {
    setState(() {
      registerIcon = icon;
    });
  }

}