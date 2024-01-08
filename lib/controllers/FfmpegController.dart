import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:rap_edit/controllers/FileController.dart';

class FfmpegController {

  String song1;
  String song2;

  Future<int> mergeSongs(String name, vol1, vol2) async {
    FlutterFFmpeg mmpeg = new FlutterFFmpeg();
    print("\n+++++++++++++\nBeginning: ${DateTime.now()}\n+++++++++++++\n");
    var arguments = [
      "-i",
      song1,
      "-i",
      song2,
      "-shortest",
      "-filter_complex",
      "[0:a]volume=$vol1[a0];[1:a]volume=$vol2[a1];[a0][a1]amix=inputs=2:duration=shortest",
      "-y",
      "${FileController.mixedSongsPath}$name.mp3"
    ];
    int result = await mmpeg.executeWithArguments(arguments);
    print("\n+++++++++++++\nEnding: ${DateTime.now()}\n+++++++++++++\n");
    return result;
  }


}