import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:rap_edit/controllers/FileController.dart';

class FfmpegController {

  String song1;
  String song2;

  Future<int> mergeSongs(String name) async {
    FlutterFFmpeg mmpeg = new FlutterFFmpeg();
    var arguments = [
      "-i",
      song1,
      "-i",
      song2,
      "-shortest",
      "-filter_complex",
      "[0:a]volume=0.4[a0];[1:a]volume=5.0[a1];[a0][a1]amix=inputs=2:duration=shortest",
      "${FileController.filePath}/$name.mp3"
    ];
    int result = await mmpeg.executeWithArguments(arguments);
    return result;
  }


}