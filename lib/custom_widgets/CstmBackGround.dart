import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmBackGround extends StatelessWidget {
  final Widget body;

  CstmBackGround({Key key, @required this.body});
//Color(0xFF202020)
  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFFBDB76B);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topLeft,
              stops: [
                0.1,
                0.3,
                0.5,
                0.7,
                0.9
              ],
              //colors: [MyColors.backGroundWhite, MyColors.endElementColor]
            colors: [
              Colors.black,
              MyColors.darkGrey,
              MyColors.darkGrey,
              MyColors.darkGrey,
              MyColors.backGroundWhite
            ]
          )
      ),
      child: body,
    );
  }


}