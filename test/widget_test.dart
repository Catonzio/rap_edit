// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/models/Dictionary.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('Get rhymes test', () {
    //Dictionary.instance.initializeWords();
    List<String> rhymes = new List();
    String str = "cosa";
    rhymes.add("cosa");
    expect(Dictionary.instance.getRhymeWord(str), "cosa");
  });

  test('Gets only the file name given a path', () {
    String path = "/data/user/0/test/text.txt";
    String path2 = "/data/user/0/test/test.mp3";
    String path3 = "";
    String result = FileController.getOnlyFileName(path);
    String result2 = FileController.getOnlyFileName(path2);
    String result3 = FileController.getOnlyFileName(path3);
    expect(result, "text.txt");
    expect(result2, "test.mp3");
    expect(result3, "");

    expect("", SongSingleton.instance.getName());
    SongSingleton.instance.beatPath = "/data/user/0/test/test.mp3";
    expect(SongSingleton.instance.getName(), "test");
  });

  test("Voglio provare gli operatori", () {
    var a = 10;
    var b = a??12;
    expect(10, b);
    var c;
    var d = c??10;
    expect(10, d);
    b = c??a;
    expect(a, b);

    Prova prova = Prova();
    var e = prova.prova??"-";
    expect("-", e);
    prova.prova = "ciao";
    e = prova.prova??"-";
    expect("ciao", e);
    Prova prova2;
    var f = prova2?.prova??"-";
    expect("-", f);
    prova2 = Prova();
    prova2.prova = "prova2";
    f = prova2?.prova??"-";
    expect("prova2", f);

    var h = prova2?.val;
    expect(null, h);
    prova2.val = true;
    h = prova2?.prova == "prova2";
    expect(true, h);
    Prova prova3;
    var i = prova3?.prova == "prova3" ? "yes" : "no";
    expect("no", i);
  });
}


class Prova {
  String prova;
  bool val;
}
