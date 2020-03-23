import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

import 'CstmBackGround.dart';

class ListPage extends StatelessWidget {

  final String title;
  final ListView listView;
  final FutureBuilder<List<int>> futureBuilder;
  final List<Widget> buttomRowButtons;

  ListPage({
    Key key,
    @required this.title,
    this.listView,
    @required this.buttomRowButtons,
    this.futureBuilder
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CstmBackGround(
            body: Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2.0, color: MyColors.endElementColor),
                          ),
                        ),
                        child: Text("$title", style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                      ),
                      Expanded(
                        child: listView??futureBuilder
                      ),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: buttomRowButtons
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