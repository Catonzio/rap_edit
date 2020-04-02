import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/models/Dictionary.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class WritingPageController extends ChangeNotifier {

  static String lastString = "";

  Widget setTitleText() {
    if(SongSingleton.instance.currentSong != null && SongSingleton.instance.currentSong.title.isNotEmpty) {
      return Text(SongSingleton.instance.currentSong.title, textAlign: TextAlign.center, style: CstmTextTheme.pageTitle);
    } else {
      return Text("RapEdit", textAlign: TextAlign.center, style: CstmTextTheme.pageTitle);
    }
  }

  /// Sets the Title and the Text fields content as the ones of the currentSong of the SongSingleton
  String setCurrentText() {
    if(SongSingleton.instance.currentSong != null) {
      return SongSingleton.instance.currentSong.text.trim();
    }
    else
      return "";
  }

  /// Saves the currentSong of the SongSingleton as a File on the file system
  int saveFile(String title, String text) {
    if(title.isEmpty) {
      return -1;
    } else {
      SongSingleton.instance.currentSong = new SongFile(
          title.trim(), text.trim(), null);
      if (!SongSingleton.instance.currentSong.isEmpty()) {
        FileController.writeFile(SongSingleton.instance.currentSong);
        return 1;
      }
      else {
        return 0;
      }
    }
  }

  listenForText(TextEditingController textController) {
    if(textController.text.trim().isNotEmpty && textController.selection.baseOffset > 0) {
      String untilSelection = textController.text.substring(
          0, textController.selection.base.offset);
      List<String> listOfLines = untilSelection.split("\n");
      if (listOfLines.length > 1) {
        List<String> secondLastLineSplitted = listOfLines[listOfLines.length - 2].split(" ");
        if (secondLastLineSplitted.length > 0) {
          String possibleRhyme = secondLastLineSplitted[secondLastLineSplitted
              .length - 1];
          if (lastString != possibleRhyme) {
            lastString = possibleRhyme;
            notifyListeners();
            return getRhymeWord(lastString);
          }
        }
      }
    }
  }

  getRhymeWord(String lastString) {
    if(lastString != null && lastString.isNotEmpty) {
      return Dictionary.instance.getRhymeWord(lastString);
    }
  }


}