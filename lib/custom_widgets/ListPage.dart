import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/PageStyle.dart';

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
    this.bottomRowButtons,
    this.futureBuilder,
    @required this.pageInterface
  });

  @override
  Widget build(BuildContext context) {
    return PageStyle(
      page: pageInterface,
      pageTitle: title,
      body: <Widget>[
        Expanded(
            child: listView??futureBuilder
        ),
        SizedBox(height: 10,),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: bottomRowButtons??
                <Widget>[
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () => pageInterface.loadWritingPage(),
                  )
                ]
        )
        //SizedBox(height: 10,)
      ],

    );
  }

}