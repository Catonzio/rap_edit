import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:rap_edit/models/SongSingleton.dart';

import 'FileController.dart';

class RecorderController extends ChangeNotifier {

  static FlutterAudioRecorder _recorder;
  static Recording _recording;
  static Timer _t;
  String recordingName;
  Timer countdownTimer;
  String countdownString = "";


  init() async {
    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    String customPath = FileController.registrationsPath + recordingName;

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV);
    await _recorder.initialized;
  }

  Future<bool> prepare() async {
    try {
      var hasPermission = await FlutterAudioRecorder.hasPermissions;
      if (hasPermission) {
        await init();
        _recording = await _recorder.current();
      }
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> stopRecording() async {
    if(_recording?.status == RecordingStatus.Recording) {
      _recording = await _recorder.stop();
      _t.cancel();
      SongSingleton.instance.beatPath = "${FileController.registrationsPath}$recordingName.wav";
      SongSingleton.instance.isLocal = true;
      SongSingleton.instance.isAsset = false;
      countdownString = "saved";
      return true;
    }
    return false;
  }

  startRecording() async {
    if(_recording.status == RecordingStatus.Initialized) {
      debugPrint("Start recording");
      await _recorder.start();
      _recording = await _recorder.current();

      _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
        _recording = await _recorder.current();
        _t = t;
      });
      startRegistrationTimer();
    }
  }

  getRecordingDuration() {
    return _recording?.duration;
  }

  isRecording() {
    try {
      return _recording.status == RecordingStatus.Recording;
    } catch(ex) {
      return false;
    }
  }

  deleteTimer() {
    if(countdownTimer != null)
      countdownTimer.cancel();
  }

  startCountdown() async {
    int start = 3;
    countdownTimer = new Timer.periodic(Duration(seconds: 1),
      (Timer timer) {
        if (start > 0) {
            countdownString = start.toString();
            start = start - 1;
            print("Countdown: $start");
            notifyListeners();
          } else if(start == 0) {
            countdownString = "recording";
            startRecording();
            start = start - 1;
            print("Countdown: $start");
            notifyListeners();
          }
          else {
            timer.cancel();
          }
    });
    //getRecordingText();
  }

  getRecordingText() {
    try {
      countdownString = int.parse(countdownString) != null ? countdownString : "";
    } catch(ex) {
      countdownString = getDurationFormatted(getRecordingDuration());
    }
    notifyListeners();
    return countdownString;
  }

  /// Returns the Duration displayed as 'minute':'seconds'
  String getDurationFormatted(Duration dur) {
    //se dur è != null, ritorna dur.toString(); altrimenti, Duration().toString()
    String pos = dur?.toString() ?? "";
    return pos.contains(":") ? pos.substring(pos.indexOf(":") + 1, pos.lastIndexOf(".")) : pos;
  }

  void startRegistrationTimer() {
    Timer.periodic(Duration(seconds: 1),
            (timer) {
              getRecordingText();
              notifyListeners();
            });
  }
}