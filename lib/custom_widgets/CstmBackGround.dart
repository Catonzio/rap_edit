import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmBackGround extends StatelessWidget {
  final Widget body;

  CstmBackGround({Key key, @required this.body});

  @override
  Widget build(BuildContext context) {

    return Container(
      /*decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topLeft,
              stops: [
                0.3,
                0.6,
                0.9
              ],
              //colors: [MyColors.backGroundWhite, MyColors.endElementColor]
            colors: [
              MyColors.endElementColor,
              MyColors.deepPurple,
              MyColors.deepPurple,
            ]
          )
      ),*/
      color: MyColors.deepPurple,
      child: body,
    );
  }


}