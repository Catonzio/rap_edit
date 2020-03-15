import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CstmTextField extends StatelessWidget {

  final TextStyle textStyle = new TextStyle(color: Colors.white, fontSize: 20);
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
     obscureText: false,
     cursorColor: Colors.white,
     style: textStyle,
     maxLines: maxLines,
     //style: style,
     decoration: InputDecoration(
       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
       hintText: hintText,
       hintStyle: TextStyle(color: Colors.white),
       border: OutlineInputBorder(
           borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
           borderRadius: BorderRadius.circular(8.0)
       ),
     ),
     controller: controller,
   );
  }

}