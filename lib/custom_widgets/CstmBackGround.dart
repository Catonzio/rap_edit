import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmBackGround extends StatelessWidget {
  final Widget body;

  CstmBackGround({Key key, @required this.body});
//Color(0xFF202020)
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [MyColors.backGroundWhite, MyColors.endElementColor]
          )
      ),
      child: body,
    );
  }


}