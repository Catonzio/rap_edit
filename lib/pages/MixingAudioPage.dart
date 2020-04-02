import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';

class MixingAudioPage extends StatefulWidget {
  static String routeName = "/mixingAudioPage";

  MixingAudioPageState createState() => MixingAudioPageState();
}

class MixingAudioPageState extends State<MixingAudioPage> {

  String firstSongPath;
  String secondSongPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CstmBackGround(
          body: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("First song: $firstSongPath", style: CstmTextTheme.textField,),

                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
