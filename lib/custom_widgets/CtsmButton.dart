import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CstmButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle = new TextStyle(color: Colors.white, fontSize: 15);
  final Function pressed;

  CstmButton({
    Key key,
    @required this.text,
    @required this.pressed
  });

  @override
  Widget build(BuildContext context) {
    return Material (
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      elevation: 10.0,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width/4,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        onPressed: pressed,
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