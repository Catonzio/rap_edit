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
    words.shuffle();
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
      if(isRhyme(word, lastString)) {
        rhymes.add(word);
      }
    });
    rhymes.shuffle();
    if(rhymes.length > 0 && rhymes.length > 10) {
      return rhymes.sublist(0, 10);
    } else
      return rhymes;
  }

  bool isRhyme(String first, String second) {
    first = first.toLowerCase().trim();
    second = second.toLowerCase().trim();
    if(first.isNotEmpty && second.isNotEmpty) {
      if (first.length > 3) {
        if (second.endsWith(first.substring(first.length - 3))) {
          return true;
        }
      } else if (second.endsWith(first)) {
        return true;
      }
    }
    return false;
  }
}