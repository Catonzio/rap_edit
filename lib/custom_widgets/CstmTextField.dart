import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmTextField extends StatelessWidget {

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
   return Container(
     //color: MyColors.darkGrey,
     child: TextFormField(
       textCapitalization: TextCapitalization.none,
       obscureText: false,
       cursorColor: MyColors.textColor,
       style: CstmTextTheme.textField,
       maxLines: maxLines,
       //style: style,
       decoration: InputDecoration(
         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
         hintText: hintText,
         border: OutlineInputBorder(
             borderSide: BorderSide(color: MyColors.primaryColor, width: 2.0),
             borderRadius: BorderRadius.circular(8.0)
         ),
       ),
       controller: controller,
       autocorrect: false,
     ),
   );
  }

}