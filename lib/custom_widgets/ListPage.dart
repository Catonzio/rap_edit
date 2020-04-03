import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/drawer/CstmDrawer.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'CstmBackGround.dart';

class ListPage extends StatelessWidget {

  final String title;
  final ListView listView;
  final FutureBuilder<List<int>> futureBuilder;
  final List<Widget> bottomRowButtons;
  final MyPageInterface pageInterface;

  ListPage({
    Key key,
    @required this.title,
    this.listView,
    @required this.bottomRowButtons,
    this.futureBuilder,
    @required this.pageInterface
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(title, style: CstmTextTheme.pageTitle,),
          centerTitle: true,
          backgroundColorStart: MyColors.startAppBar,
          backgroundColorEnd: MyColors.endAppBar,
          //serve per non permettere di tornare indietro dall'appbar
          //automaticallyImplyLeading: false,
        ),
      drawer: CstmDrawer(pageInterface),
      body: CstmBackGround(
          body: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              child: Column(
                  children: <Widget>[

                    Expanded(
                      child: listView??futureBuilder
                    ),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bottomRowButtons
                    )
                    //SizedBox(height: 10,)
                  ]
              ),
            )
          )
      )
    );
  }

}