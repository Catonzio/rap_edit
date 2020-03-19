import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/pages/Trials.dart';
import 'package:rap_edit/pages/WritingPage.dart';

import 'pages/FileLoadingPage.dart';
import 'pages/WritingPage.dart';

void main() {
  runApp(PageMain());
}

class PageMain extends StatelessWidget {
  static String routeName = "/main";

  @override
  Widget build(BuildContext context) {
    FileController.setDirectoryPath();

    return MaterialApp(
      routes: {
        FileLoadingPage.routeName: (context) => FileLoadingPage(),
        WritingPage.routeName: (context) => WritingPage(),
        ChoosingBeatsPage.routeName: (context) => ChoosingBeatsPage(),
        Trials.routeName: (context) => Trials(),
        TabbedLoading.routeName: (context) => TabbedLoading()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Color(0xFF2C75FF),
          accentColor: Color(0xFF2C75FF),
          fontFamily: 'Georgia',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0,),
            body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
          ),
      ),
    );
  }
}