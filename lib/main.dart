import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/pages/prove.dart';
import 'package:rap_edit/pages/secondPage.dart';
import 'package:rap_edit/pages/thirdPage.dart';

import 'pages/FileLoadingPage.dart';
import 'pages/firstPage.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  static String routeName = "/main";
  @override
  Widget build(BuildContext context) {
    SecondPage secondPage;
    if(ModalRoute.of(context) != null)
      secondPage = new SecondPage(ModalRoute.of(context).settings.arguments);
    else {
      secondPage = new SecondPage(null);
    }
    FileController.setDirectoryPath();
    return MaterialApp(
      routes: {
        FileLoadingPage.routeName: (context) => FileLoadingPage(),
        ProvePage.routeName: (context) => ProvePage(),
        SecondPage.routeName: (context) => SecondPage(null),
        TabBarDemo.routeName: (context) => TabBarDemo()
      },
      home: DefaultTabController(
        length: 4,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.wrap_text)),
                Tab(icon: Icon(Icons.add_shopping_cart)),
                Tab(icon: Icon(Icons.cloud_upload)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text('Rap Edit'),
          ),
          body: TabBarView(
            children: [
              FirstPage(),
              secondPage,
              ThirdPage(),
              ProvePage()
            ],
          ),
        ),
      ),
    );
  }
}