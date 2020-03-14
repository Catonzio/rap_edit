import 'package:flutter/material.dart';

import '../models/SongFile.dart';
import 'firstPage.dart';
import 'prove.dart';
import 'secondPage.dart';
import 'secondPage.dart';
import 'thirdPage.dart';

class TabBarPage extends StatefulWidget {
  static String routeName = "/tabBarPage";

  @override
  TabBarPageState createState() {
    return TabBarPageState();
  }

}

class TabBarPageState extends State<TabBarPage> {

  static SecondPage secondPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(secondPage == null) {
      secondPage = new SecondPage();
    }
    else {
      SongFile song = ModalRoute
          .of(context)
          .settings
          .arguments;
      if (song != null) {
        secondPage.setCurrentSong(song);
      }
    }
    return DefaultTabController(
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
    );
  }

}