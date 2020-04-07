import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/drawer/CstmPopupMenu.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class PageStyle extends StatefulWidget {

  final String pageTitle;
  final List<Widget> body;
  final MyPageInterface page;

  PageStyle({
    Key key,
    @required this.pageTitle,
    @required this.body,
    @required this.page
  });

  @override
  PageStyleState createState() => PageStyleState();
}

class PageStyleState extends State<PageStyle> with MyPageInterface {

  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      //drawer: CstmDrawer(widget.page),
      body: CstmBackGround(
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            child: Column(
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2.0, color: MyColors.softPurple.withOpacity(0.5)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${widget.pageTitle}", style: CstmTextTheme.pageTitle,
                        textAlign: TextAlign.center,),
                      //SizedBox(width: 70,),
                      Expanded(child: Text("")),
                      CstmPopupMenu(page: widget.page,)
                    ],
                  )
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.body,
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

}