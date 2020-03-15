import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/pages/prove.dart';
import 'package:rap_edit/pages/secondPage.dart';
import 'package:rap_edit/pages/TabBarsPage.dart';
import 'package:rap_edit/pages/thirdPage.dart';

import 'models/SongFile.dart';
import 'pages/FileLoadingPage.dart';
import 'pages/firstPage.dart';
import 'pages/secondPage.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  static String routeName = "/main";

  @override
  Widget build(BuildContext context) {
  debugPrint("oooooooooooooooooooo " + FileType.AUDIO.toString());
    FileController.setDirectoryPath();
    return MaterialApp(

      routes: {
        FileLoadingPage.routeName: (context) => FileLoadingPage(),
        ProvePage.routeName: (context) => ProvePage(),
        SecondPage.routeName: (context) => SecondPage(),
        TabBarDemo.routeName: (context) => TabBarDemo(),
        TabBarPage.routeName: (context) => TabBarPage()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan[600],
          //fontFamily: 'Georgia',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
          )
      ),
      home: SecondPage()
    );
  }
}