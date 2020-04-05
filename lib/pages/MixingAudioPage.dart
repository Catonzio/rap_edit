import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/drawer/CstmDrawer.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/PageStyle.dart';
import 'package:rap_edit/pages/RegistrationsPage.dart';
import 'package:rap_edit/pages/TextsPage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class MixingAudioPage extends StatefulWidget {
  static String routeName = "/mixingAudioPage";

  MixingAudioPageState createState() => MixingAudioPageState();
}

class MixingAudioPageState extends State<MixingAudioPage> with MyPageInterface{

  String firstSongPath;
  String secondSongPath;

  @override
  Widget build(BuildContext context) {
    return PageStyle(
      pageTitle: "Mixing Audio",
      body: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("First song: $firstSongPath", style: CstmTextTheme.textField,textAlign: TextAlign.center,),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => loadWritingPage(),
            )
          ],
        )
      ],
    );
  }

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  void loadMixingAudioPage() => null;
}
