import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class CstmButton extends StatelessWidget {

  final String text;
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [MyColors.endElementColor, MyColors.primaryColor]
          ),
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.transparent,
        elevation: 10.0,
        child: MaterialButton(
          //minWidth: MediaQuery.of(context).size.width / 4,
          //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          child: text == null
              ? Icon(iconData, color: MyColors.textColor, size: 30,)
              : Text(text, textAlign: TextAlign.center,
              style: CstmTextTheme.buttonText
          ),
          onPressed: pressed,
        ),
      ),
    );
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