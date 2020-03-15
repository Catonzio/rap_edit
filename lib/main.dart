import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/pages/ChoosingBase.dart';
import 'package:rap_edit/pages/SecondPage.dart';
import 'pages/FileLoadingPage.dart';
import 'pages/SecondPage.dart';

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
        SecondPage.routeName: (context) => SecondPage(currentSong: ModalRoute.of(context).settings.arguments),
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
      home: ChoosingBase()
    );
  }
}