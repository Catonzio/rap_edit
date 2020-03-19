import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

class RegistrationsPage extends StatefulWidget {

  @override
  RegistrationsPageState createState() => RegistrationsPageState();
}

class RegistrationsPageState extends State<RegistrationsPage> {

  List<String> registrationsPath = List();

  @override
  void initState() {
    super.initState();
    loadRegistrations();
  }



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
                Expanded(
                  child: ListView.builder(
                    itemCount: registrationsPath.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Colors.black, MyColors.electricBlue]
                                  ),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(getOnlyRegistrationName(registrationsPath[index])),
                                  ),
                                  ButtonBar(
                                    children: <Widget>[
                                      MaterialButton(
                                        child: Text("Share"),
                                        onPressed: () => {  },
                                      ),
                                      MaterialButton(
                                          child: Text("Load"),
                                          onPressed: () => {  }
                                      ),
                                      MaterialButton(
                                        child: Text("Preview"),
                                        onPressed: () => { listenPreview(registrationsPath[index]) },
                                      )
                                    ],
                                  )
                                ],
                              )
                          )
                      );
                    },
                  ),
                ),
                CstmButton(
                  iconData: Icons.home,
                  pressed: () => { Navigator.popAndPushNamed(context, WritingPage.routeName) },
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> loadRegistrations() async {
    Directory downloadDirectory = await getApplicationDocumentsDirectory();
    downloadDirectory.listSync().forEach((file) => {
      if(file.path.endsWith(".wav")) {
        registrationsPath.add(file.path)
      }
    });
    debugPrint("oooooooooooooooooooo " + registrationsPath.length.toString());
  }

  String getOnlyRegistrationName(String registrationsPath) {
    return registrationsPath.substring(registrationsPath.lastIndexOf("/") + 1);
  }

  listenPreview(String path) {
    AudioPlayer player = AudioPlayer();
    player.play(path, isLocal: true);
    Future.delayed(Duration(seconds: 5), () => {
      player.stop()
    });
  }

}