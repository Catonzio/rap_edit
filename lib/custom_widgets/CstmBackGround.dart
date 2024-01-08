import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmBackGround extends StatelessWidget {
  final Widget body;

  CstmBackGround({Key key, @required this.body});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                0.02,
                0.5,
                0.9
              ],
              //colors: [MyColors.backGroundWhite, MyColors.endElementColor]
              colors: [
                MyColors.softPurple.withOpacity(0.2),
                MyColors.deepPurpleOpac,
                MyColors.deepPurpleOpac,
              ]
          )
      ),
      //color: MyColors.deepPurple,
      child: body,
    );
  }


}