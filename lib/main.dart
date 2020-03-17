import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/pages/ChoosingBeats.dart';
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
        ChoosingBeats.routeName: (context) => ChoosingBeats()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan[600],
          fontFamily: 'Georgia',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0,),
            body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
          ),
      ),
    );
  }

  getArgument(BuildContext context) {
    var argument;
    if(ModalRoute.of(context) != null) {
      argument = ModalRoute.of(context).settings.arguments;
    }
    return argument;
  }
}