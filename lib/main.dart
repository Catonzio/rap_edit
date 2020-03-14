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

    FileController.setDirectoryPath();
    return MaterialApp(

      routes: {
        FileLoadingPage.routeName: (context) => FileLoadingPage(),
        ProvePage.routeName: (context) => ProvePage(),
        SecondPage.routeName: (context) => SecondPage(),
        TabBarDemo.routeName: (context) => TabBarDemo(),
        TabBarPage.routeName: (context) => TabBarPage()
      },

      home: TabBarPage()
    );
  }
}