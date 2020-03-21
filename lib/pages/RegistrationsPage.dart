import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';
import 'package:share_extend/share_extend.dart';

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
                SizedBox(height: 20,),
                Text("Registrations", style: TextStyle(fontSize: 40),),
                Expanded(
                  child: ListView.builder(
                    itemCount: registrationsPath.length,
                    //padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    itemBuilder: (BuildContext context, int index) {
                      return CardFile(
                        title: getOnlyRegistrationName(registrationsPath[index]),
                        text: "",
                        buttomButtons: <Widget>[
                          ButtonCstmCard(
                            icon: Icons.delete,
                            pressed: () => { deleteRegistration(index) },
                          ),
                          ButtonCstmCard(
                            icon: Icons.share,
                            pressed: () => { shareSong(registrationsPath[index]) },
                          ),
                          ButtonCstmCard(
                            icon: Icons.file_upload,
                            pressed: () => { loadRegistration(registrationsPath[index]) },
                          ),
                          ButtonCstmCard(
                            icon: Icons.play_arrow,
                            pressed: () => { listenPreview(registrationsPath[index]) },
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 10,),
                CstmButton(
                  iconData: Icons.home,
                  pressed: () => { Navigator.popAndPushNamed(context, WritingPage.routeName) },
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      )
    );
  }

  loadRegistrations() {
    Directory downloadDirectory = Directory(FileController.filePath);
    downloadDirectory.listSync().forEach((file) => {
      if(file.path.endsWith(".wav")) {
        registrationsPath.add(file.path)
      }
    });
  }

  String getOnlyRegistrationName(String registrationsPath) {
    return registrationsPath.substring(registrationsPath.lastIndexOf("/") + 1, registrationsPath.lastIndexOf("."));
  }

  listenPreview(String path) {
    AudioPlayer player = AudioPlayer();
    player.play(path, isLocal: true);
    Future.delayed(Duration(seconds: 5), () => {
      player.stop()
    });
  }

  loadRegistration(String registrationsPath) {
    SongSingleton.instance.beatPath = registrationsPath;
    SongSingleton.instance.isLocal = true;
    SongSingleton.instance.isAsset = false;
    Navigator.popAndPushNamed(context, WritingPage.routeName);
  }

  deleteRegistration(int index) {
    FileController.deleteRegistration(registrationsPath[index]);
    setState(() {
      registrationsPath.remove(registrationsPath[index]);
    });
  }

  shareSong(String registrationsPath) async {
    ShareExtend.share(registrationsPath, "file");
  }

}