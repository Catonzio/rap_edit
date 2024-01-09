import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/file_controller.dart';
import 'package:rap_edit/data/models/lyric.dart';

class WriterController extends GetxController {
  static WriterController get to => Get.find<WriterController>();

  final FileController fileController = FileController.to;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final Rx<Lyric> _currentLyric = Lyric.empty().obs;
  Lyric get currentLyric => _currentLyric.value;
  set currentLyric(Lyric value) => _currentLyric.value = value;

  bool get isLyricLoaded => currentLyric.title.isNotEmpty;

  void loadLyric(Lyric lyric) {
    currentLyric = lyric;
    textEditingController.text = currentLyric.text;
    titleController.text = currentLyric.title;
  }

  Future<bool> saveText() async {
    currentLyric.text = textEditingController.text.trim();
    currentLyric.title = titleController.text.trim();
    return await fileController.saveFile(currentLyric);
  }

  void emptyText() {
    textEditingController.clear();
    currentLyric.text = "";
    fileController.saveFile(currentLyric);
  }

  void newLyric() {
    currentLyric = Lyric.empty();
    textEditingController.clear();
    titleController.clear();
  }
}
