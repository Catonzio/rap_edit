import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/Trials/RegistrationsPageDuration.dart';
import 'package:rap_edit/pages/FileLoadingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

class TabbedLoading extends StatelessWidget {
  static String routeName = "/tabbedLoading";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[
              FileLoadingPage(),
              RegistrationsPageDuration()
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: <Widget>[
              Tab(
                icon: new Icon(Icons.assignment, color: MyColors.textColor,),
              ),
              Tab(
                icon: new Icon(Icons.mic, color: MyColors.textColor)
              )
            ],
          ),
        ),
      ),
    );
  }


}