import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CstmDrawerLine extends StatelessWidget {

  final IconData icon;
  final String text;
  final Function pressed;
  final EdgeInsetsGeometry padding;

  CstmDrawerLine({
   Key key,
   this.icon,
   this.text,
   this.pressed,
   this.padding
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          padding: padding,
          child: Row(
            children: <Widget>[
              Icon(icon),
              Container(width: 10,),
              Text(text, style: TextStyle(fontSize: 20),)
            ],
          ),
          onPressed: () => { debugPrint("Save") },
        ),
      ],
    );
  }

}