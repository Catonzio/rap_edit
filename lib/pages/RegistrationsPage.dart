import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/TextsPage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';
import 'package:share_extend/share_extend.dart';

import 'ChoosingBeatsPage.dart';

class RegistrationsPage extends StatefulWidget {
  static String routeName = "/registrationsPage";

  @override
  RegistrationsPageState createState() => RegistrationsPageState();
}

class RegistrationsPageState extends State<RegistrationsPage> with MyPageInterface{

  List<String> registrationsPath = List();
  ListenAssetSupport listenAssetSupport;
  IconData playPauseIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    loadRegistrations();
    listenAssetSupport = ListenAssetSupport();
  }

  @override
  Widget build(BuildContext context) {
    //FileController.deleteAllRegistrations();
    return ListPage(
      title: "Registrations",
      listView: ListView.builder(
        itemCount: registrationsPath.length,
        itemBuilder: (BuildContext context, int index) {
          return CardFile(
            title: getOnlyRegistrationName(registrationsPath[index]),
            text: "Duration: ${getSongDuration(registrationsPath[index])}",
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
      ),
      bottomRowButtons: <Widget>[
        CstmButton(
          iconData: Icons.home,
          pressed: () => { loadWritingPage() },
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
    loadWritingPage();
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

  @override
  void loadChoosingBeatsPage() => loadPage(ChoosingBeatsPage.routeName);

  @override
  void loadRegistrationsPage() => null;

  @override
  void loadTextsPage() => loadPage(TextsPage.routeName);

  @override
  void loadWritingPage() => loadPage(WritingPage.routeName);

}