// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';

import 'package:rap_edit/main.dart';
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
  });

  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MyWidget());

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
    final buttonText = find.text("B");
    final button = find.byType(MaterialButton);
    final field = find.byType(CstmTextField);

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
    expect(buttonText, findsOneWidget);
    expect(button, findsOneWidget);
    expect(field, findsOneWidget);
  });

  testWidgets("Test my WritingPage", (WidgetTester tester) async {
    await tester.pumpWidget(WritingPage());

    final textFields = find.byType(CstmTextField);

    expect(textFields, findsNWidgets(2));
  });
}

class MyWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("T"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("M"),
              MaterialButton(
                child: Text("B"),
              ),
              CstmTextField(
                hintText: "hello",
              )
            ],
          )
        ),
      ),
    );
  }
}
