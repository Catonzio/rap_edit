import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';

class CstmDrawerLine extends StatelessWidget {

  final IconData icon;
  final String text;
  final Function pressed;
  final EdgeInsetsGeometry padding;

  CstmDrawerLine({
   Key key,
   @required this.icon,
   @required this.text,
   @required this.pressed,
   this.padding
  });

  @override
  Widget build(BuildContext context) {
    return
        Container(
          padding: padding??EdgeInsets.fromLTRB(20, 0, 0, 0),
          //color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              MaterialButton(
                child: Text(text, style: CstmTextTheme.snackBar,),
                onPressed: pressed,
              )
            ],
          ),
//          child: MaterialButton(
//            padding: padding,
//            child: Row(
//              children: <Widget>[
//                Icon(icon),
//                Container(width: 10,),
//                Text(text, style: CstmTextTheme.drawerLine,)
//              ],
//            ),
//            onPressed: pressed,
//          ),
        );
  }

}