import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/domain_controllers/music_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/data/repositories/lyrics_repository.dart';

class WriterController extends GetxController {
  static WriterController get to => Get.find<WriterController>();

  // final LyricFileController lyricRepository = LyricFileController.to;
  final LyricsRepository lyricsRepository = LyricsRepository.to;
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
    Beat? currentBeat = MusicController.to.beat;
    currentLyric.text = textEditingController.text.trim();
    currentLyric.title = titleController.text.trim();
    currentLyric.beatUrl = currentBeat?.songUrl ?? "";
    currentLyric.beatId = currentBeat?.id ?? "";
    // currentLyric currentLyric = currentLyric;
    return await lyricsRepository.saveLyric(currentLyric);
  }

  void emptyText() {
    textEditingController.clear();
    currentLyric.text = "";
    lyricsRepository.saveLyric(currentLyric);
  }

  void newLyric() {
    currentLyric = Lyric.empty();
    textEditingController.clear();
    titleController.clear();
  }
}
