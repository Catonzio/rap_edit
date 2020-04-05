import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class PageStyle extends StatefulWidget {

  final String pageTitle;
  final List<Widget> body;

  PageStyle({
    Key key,
    this.pageTitle,
    this.body
  });

  @override
  PageStyleState createState() => PageStyleState();
}

class PageStyleState extends State<PageStyle> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        //elevation: 10,
        child: BottomAppBar(
          color: MyColors.deepPurple.withOpacity(1),
          elevation: 1000,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
              )
            ],
          ),
        ),
      ),
      body: CstmBackGround(
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2.0, color: MyColors.softPurple),
                    ),
                  ),
                  child: Text("${widget.pageTitle}", style: CstmTextTheme.pageTitle,
                    textAlign: TextAlign.center,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.body,
                )
              ],
            ),
          ),
        )
      ),
    );
  }

}