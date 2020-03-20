import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmTextField extends StatelessWidget {

  final TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 20);
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  CstmTextField({
    Key key,
    this.controller,
    this.hintText,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
   return TextField(
     textCapitalization: TextCapitalization.none,
     obscureText: false,
     cursorColor: MyColors.textColor,
     style: textStyle,
     maxLines: maxLines,
     //style: style,
     decoration: InputDecoration(
       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
       hintText: hintText,
       hintStyle: TextStyle(color: MyColors.textColor),
       border: OutlineInputBorder(
           borderSide: BorderSide(color: MyColors.startElementColor, width: 2.0),
           borderRadius: BorderRadius.circular(8.0)
       ),
     ),
     controller: controller,
   );
  }

}