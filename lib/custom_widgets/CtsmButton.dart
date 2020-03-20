import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle = new TextStyle(color: MyColors.textColor, fontSize: 15);
  final Function pressed;
  final IconData iconData;

  CstmButton({
    Key key,
    this.text,
    @required this.pressed,
    this.iconData
  });

  @override
  Widget build(BuildContext context) {
    if (text != null && iconData == null) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [MyColors.endElementColor, MyColors.startElementColor]
            ),
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.transparent,
          elevation: 10.0,
          child: MaterialButton(
            minWidth: MediaQuery
                .of(context)
                .size
                .width / 4,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            onPressed: pressed,
          ),
        ),
      );
    } else if(text == null && iconData != null) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [MyColors.endElementColor, MyColors.startElementColor]
            ),
            borderRadius: BorderRadius.circular(30.0)
        ),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.transparent,
          elevation: 10.0,
          child: MaterialButton(
            minWidth: MediaQuery
                .of(context)
                .size
                .width / 4,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Icon(
              iconData,
              color: MyColors.textColor,
            ),
            onPressed: pressed,
          ),
        ),
      );
    }
    else {
      return Text("Error!");
    }
  }
}

class PlayerButton extends StatelessWidget {
  final IconData icon;
  final Function pressed;

  PlayerButton({
    Key key,
    this.icon,
    this.pressed
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Icon(icon, color: Theme.of(context).primaryColor),
      onPressed: () => { pressed },
    );
  }
}