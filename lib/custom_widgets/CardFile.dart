import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/support/MyColors.dart';

class CardFile extends StatelessWidget {

  final String title;
  final String text;
  final List<Widget> buttomButtons;

  CardFile({
    @required this.title,
    @required this.text,
    @required this.buttomButtons
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [MyColors.endElementColor, MyColors.primaryColor]
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(title, style: TextStyle(color: MyColors.textColor, fontSize: 25)),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                  )
                ],
              ),
              //SizedBox(height: 10.0,),
              //Text(text, maxLines: 1, style: TextStyle(color: MyColors.textColor, fontSize: 15), textAlign: TextAlign.end,),
              Row(
                children: <Widget>[
                  Container(
                    child: Text(text, maxLines: 1, style: TextStyle(color: MyColors.textColor, fontSize: 15), textAlign: TextAlign.end,),
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttomButtons
              )
            ],
          ),
        ),
        SizedBox(height: 8.0,)
      ],
    );
  }

}

class ButtonCstmCard extends StatelessWidget {

  final IconData icon;
  final Function pressed;

  ButtonCstmCard({Key key, this.icon, this.pressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 25.0,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        child: Icon(icon, color: MyColors.textColor),
        onPressed: pressed,
      ),
    );
  }

}