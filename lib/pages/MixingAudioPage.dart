import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/drawer/CstmDrawer.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
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
    return Scaffold(
        appBar: GradientAppBar(
          title: Text("Mix audio", style: CstmTextTheme.pageTitle,),
          centerTitle: true,
          backgroundColorStart: MyColors.startAppBar,
          backgroundColorEnd: MyColors.endAppBar,
          //serve per non permettere di tornare indietro dall'appbar
          //automaticallyImplyLeading: false,
        ),
        drawer: CstmDrawer(this),
        body: CstmBackGround(
          body: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
              ),
            ),
          ),
        )
    );
  }

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  void loadMixingAudioPage() => null;
}
