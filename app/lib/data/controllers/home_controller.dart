import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/music_controller.dart';
import 'package:rap_edit/data/controllers/writer_controller.dart';

class HomeController extends GetxController {
  final MusicController musicController;
  final WriterController writerController;

  HomeController(
      {required this.musicController, required this.writerController});

}
