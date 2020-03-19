// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/pages/WritingPage.dart';

void main() {
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

  test("Test the name handling of a registration", () {
    String str1 = "test";
    String str2 = "test(1)";
    String str3 = "test(20)";
    String str4 = "test(ciao)";

    expect("test(1)", FileController.manageName(str1));
    expect("test(2)", FileController.manageName(str2));
    expect("test(21)", FileController.manageName(str3));
    expect("test(ciao)(1)", FileController.manageName(str4));
  });
}
