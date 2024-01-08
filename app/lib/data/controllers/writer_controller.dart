import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/file_controller.dart';
import 'package:rap_edit/data/models/lyric.dart';

class WriterController extends GetxController {
  final FileController fileController = Get.find<FileController>();
  final TextEditingController textEditingController = TextEditingController();

  final Rx<Lyric> _currentLyric = Lyric.empty().obs;
  Lyric get currentLyric => _currentLyric.value;
  set currentLyric(Lyric value) => _currentLyric.value = value;

  void saveText() {
    currentLyric.text = textEditingController.text.trim();
    fileController.saveFile(currentLyric);
  }

  void emptyText() {
    textEditingController.clear();
    currentLyric.text = "";
    fileController.saveFile(currentLyric);
  }
}
