import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
                                        child: Text("Delete"),
                                        onPressed: () => { deleteRegistration(index) },
                                      ),
                                      MaterialButton(
                                        child: Text("Share"),
                                        onPressed: () => { shareSong(registrationsPath[index]) },
                                      ),
                                      MaterialButton(
                                          child: Text("Load"),
                                          onPressed: () => { loadRegistration(registrationsPath[index]) }
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
    return registrationsPath.substring(registrationsPath.lastIndexOf("/") + 1);
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