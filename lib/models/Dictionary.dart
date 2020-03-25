import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Dictionary {

  Dictionary.privateConstructor();

  static final Dictionary _instance = Dictionary.privateConstructor();

  static Dictionary get instance => _instance;

  List<String> words = new List();
  static int numberOfRhymes = 3;

  Dictionary() {
    initializeWords();
  }

  initializeWords() async {
    String paroleFile = await rootBundle.loadString("assets/parole.txt");
    words = paroleFile.split("\n");
    debugPrint("${words.length} words loaded");
  }

  printWords() {
    words.forEach((element) {
      debugPrint(element);
    });
  }

  List<String> getRhymeWord(String lastString) {
    List<String> rhymes = new List();
    words.forEach((word) {
      if(word.length > 3) {
        if(lastString.endsWith(word.substring(word.length - 3))) {
          rhymes.add(word);
        }
      } else if(lastString.endsWith(word)) {
          rhymes.add(word);
      }
    });
    if(rhymes.length > 0) {
      if(rhymes.length >= numberOfRhymes) {
        return rhymes.sublist(0, numberOfRhymes);
      } else if(rhymes.length < numberOfRhymes) {
        return rhymes;
      }
    }
  }
}