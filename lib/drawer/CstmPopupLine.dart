import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';

class CstmPopupLine extends PopupMenuItem {

  final IconData icon;
  final String text;
  final String routeName;

  CstmPopupLine({
    Key key,
    this.icon,
    this.text,
    this.routeName
  });

  PopupMenuItem getButton() {
    return PopupMenuItem(
      child: Row(
        children: <Widget>[
          Icon(icon),
          SizedBox(width: 30,),
          Text(text)
        ],
      ),
      value: routeName,
    );
  }

}