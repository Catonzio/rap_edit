import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardFile extends StatelessWidget {

  final String title;
  final String text;
  final IconData icon;
  final Function deleteButtonAction;
  final Function loadButtonAction;
  final Color color;
  final Color backgroundColor;

  CardFile({
    @required this.title,
    @required this.text,
    @required this.icon,
    @required this.deleteButtonAction,
    @required this.loadButtonAction,
    @required this.color,
    @required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = new TextStyle(color: color);

    return Card(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(icon),
            title: Text(title, style: textStyle,),
            subtitle: Text(
              text,
              maxLines: 4,
              style: textStyle,
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text("Delete", style: textStyle,),
                onPressed: deleteButtonAction,
              ),
              FlatButton(
                child: Text("Load", style: textStyle,),
                onPressed: loadButtonAction,
              )
            ],
          ),
        ],
      ),
    );
  }
}