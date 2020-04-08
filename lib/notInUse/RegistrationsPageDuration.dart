import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';
import 'package:share_extend/share_extend.dart';

class RegistrationsPageDuration extends StatefulWidget {
  static String routeName = "/registrationsPageDuration";
  @override
  RegistrationsPageDurationState createState() => RegistrationsPageDurationState();
}

class RegistrationsPageDurationState extends State<RegistrationsPageDuration> with MyPageInterface {

  List<String> registrationsPath = List();
  ListenAssetSupport listenAssetSupport;
  IconData playPauseIcon = Icons.play_arrow;
  Future<List<int>> registrationsDurations;
  @override
  void initState() {
    super.initState();
    loadRegistrations();
    listenAssetSupport = ListenAssetSupport();
    registrationsDurations = listenAssetSupport.getLocalsDuration(registrationsPath);
  }

  @override
  void dispose() {
    super.dispose();
    listenAssetSupport.stopPreview();
  }

  @override
  Widget build(BuildContext context) {
    //FileController.deleteAllRegistrations();
    return ListPage(
      title: "Registrations",
      pageInterface: this,
      futureBuilder: FutureBuilder<List<int>>(
        future: registrationsDurations,
        builder: (context, snapshot) {
          try {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: registrationsPath.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  debugPrint("Registrations index: $index");
                  debugPrint("Snapshot datas length: ${snapshot.data.length}");
                  return CardFile(
                    title: getOnlyRegistrationName(registrationsPath[index]),
                    bottomButtons: <Widget>[
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
                        icon: playPauseIcon,
                        pressed: () => { listenPreview(registrationsPath[index]) },
                      )
                    ],
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          } catch(ex) {
            return CircularProgressIndicator();
          }
        },
      ),
      bottomRowButtons: <Widget>[
        CstmButton(
          iconData: Icons.home,
          pressed: () => { Navigator.popAndPushNamed(context, WritingPage.routeName) },
        ),
      ],
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

  updateIcon(IconData data) {
    if(mounted) {
      setState(() {
        playPauseIcon = data;
      });
    }
  }

  listenPreview(String path) {
    updateIcon(listenAssetSupport.listenPreview(path.trim()));
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

  getSongDuration(String registrationsPath) {}

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

}