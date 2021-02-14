import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';
import 'package:share_extend/share_extend.dart';

class MixedSongsPage extends StatefulWidget {
  static String routeName = "/mixedSongsPage";

  @override
  MixedSongsPageState createState() => MixedSongsPageState();
}

class MixedSongsPageState extends State<MixedSongsPage> with MyPageInterface{

  List<String> mixedSongsPath = List();
  ListenAssetSupport listenAssetSupport;
  List<IconData> playPauseIcons = List();


  @override
  void initState() {
    super.initState();
    loadMixedSongs();
    listenAssetSupport = ListenAssetSupport();
    mixedSongsPath?.forEach((element) { playPauseIcons.add(Icons.play_arrow); });
  }

  @override
  void dispose() {
    super.dispose();
    listenAssetSupport.stopPreview();
  }

  loadMixedSongs() {
    Directory downloadDirectory = Directory(FileController.mixedSongsPath);
    downloadDirectory.listSync().forEach((file) => {
      if(file.path.endsWith(".wav") || file.path.endsWith(".mp3")) {
        mixedSongsPath.add(file.path)
      }
    });
    mixedSongsPath.sort((a,b) => a.compareTo(b));
  }

  String getOnlyMixedsongName(String mixedSongsPath) {
    return mixedSongsPath.substring(mixedSongsPath.lastIndexOf("/") + 1, mixedSongsPath.lastIndexOf("."));
  }

  updateIcon(IconData data, int index) {
    if(mounted) {
      setState(() {
        playPauseIcons[index] = data;
      });
    }
  }

  listenPreview(int index) {
    if(playPauseIcons[index] == Icons.play_arrow) {
      updateIcon(Icons.stop, index);
    } else if(playPauseIcons[index] == Icons.stop) {
      updateIcon(Icons.play_arrow, index);
    }
    for(int i = 0; i<playPauseIcons.length; i++) {
      if(i!=index)
        playPauseIcons[i] = Icons.play_arrow;
    }
    listenAssetSupport.listenPreview(mixedSongsPath[index]);
  }

  loadRegistration(String mixedSongsPath) {
    SongSingleton.instance.beatPath = mixedSongsPath;
    SongSingleton.instance.isLocal = true;
    SongSingleton.instance.isAsset = false;
    loadWritingPage();
  }

  deleteRegistration(int index) {
    FileController.deleteRegistration(mixedSongsPath[index]);
    setState(() {
      mixedSongsPath.remove(mixedSongsPath[index]);
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
  void loadRegistrationsPage() => null;

  @override
  Widget build(BuildContext context) {
    //FileController.deleteAllRegistrations();
    return ListPage(
      title: "Mixed songs",
      pageInterface: this,
      listView: mixedSongsPath.length == 0 ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("No mixed song available")
            ],
          )
          :
      ListView.builder(
        itemCount: mixedSongsPath.length,
        itemBuilder: (BuildContext context, int index) {
          return CardFile(
            title: getOnlyMixedsongName(mixedSongsPath[index]),
            //text: "Duration: ${getSongDuration(registrationsPath[index])}",
            bottomButtons: <Widget>[
              ButtonCstmCard(
                icon: Icons.delete,
                pressed: () => { deleteRegistration(index) },
              ),
              ButtonCstmCard(
                icon: Icons.share,
                pressed: () => { shareSong(mixedSongsPath[index]) },
              ),
              ButtonCstmCard(
                icon: Icons.file_upload,
                pressed: () => { loadRegistration(mixedSongsPath[index]) },
              ),
              ButtonCstmCard(
                icon: playPauseIcons[index],
                pressed: () => { listenPreview(index) },
              )
            ],
          );
        },
      ),
    );
  }
}