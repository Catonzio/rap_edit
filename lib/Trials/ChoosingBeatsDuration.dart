import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';

import '../custom_widgets/CtsmButton.dart';

class ChoosingBeatsDurationPage extends StatefulWidget {
  static String routeName = "/choosingBeatsDuration";
  @override
  ChoosingBeatsDurationPageState createState() => ChoosingBeatsDurationPageState();
}

class ChoosingBeatsDurationPageState extends State<ChoosingBeatsDurationPage> {

  List<String> songs = new List();
  List<Widget> songsCards = new List();
  Future<List<int>> durations;

  IconData playPauseIcon = Icons.play_arrow;
  ListenAssetSupport listenAssetSupport;


  @override
  void initState() {
    super.initState();
    songs = ["Hip_Hop_Instrumental_Beat.mp3", "Rap_Instrumental_Beat.mp3", "Trap_Instrumental_Beat.mp3", "metronome_100bpm_4-4.mp3", "metronome_100bpm_6-8.mp3"];
    listenAssetSupport = ListenAssetSupport();
    durations = listenAssetSupport.getAssetsDuration(songs);
  }

  @override
  void dispose() {
    super.dispose();
    listenAssetSupport.stopPreview();
  }

  @override
  Widget build(BuildContext context) {
    return ListPage(
      title: "Beats",
      futureBuilder: FutureBuilder<List<int>>(
        future: durations,
        builder: (context, snapshot) {
          try {
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: songs.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CardFile(
                    title: getOnlySongName(songs[index]),
                    text: snapshot.data.length == 0
                        ? ""
                        : "Duration: ${snapshot.data[index]}",
                    buttomButtons: <Widget>[
                      ButtonCstmCard(
                        icon: Icons.file_upload,
                        pressed: () => { loadAsset(songs[index]) },
                      ),
                      ButtonCstmCard(
                        icon: playPauseIcon,
                        pressed: () => { listenPreview(songs[index]) },
                      )
                    ],
                  );
                },
              );
            } else {
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  return CircularProgressIndicator();
                },
              );
            }
          } catch (ex) {
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                return CircularProgressIndicator();
              },
            );
          }
        },
      ),
      buttomRowButtons: <Widget>[
        CstmButton(
          text: "File System",
          pressed: () => { loadFromFileSystem(context) },
        ),
        Container(width: 10.0,),
        CstmButton(
          iconData: Icons.home,
          pressed: () => { Navigator.popAndPushNamed(context, WritingPage.routeName, arguments: null) },
        )
      ],
    );
  }

  updateIcon(IconData data) {
    if(mounted) {
      setState(() {
        playPauseIcon = data;
      });
    }
  }

  String getOnlySongName(String song) {
    song = song.replaceAll("_", " ");
    return song.substring(song.indexOf("/") + 1, song.lastIndexOf(".mp3"));
  }

  loadFromFileSystem(BuildContext context) async {
    try {
      String localFilePath = await FilePicker.getFilePath(type: FileType.audio);
      if(localFilePath != null && localFilePath.isNotEmpty) {
        SongSingleton.instance.beatPath = localFilePath;
        SongSingleton.instance.isLocal = true;
        SongSingleton.instance.isAsset = false;
        Navigator.popAndPushNamed(context, WritingPage.routeName);
      }
    } catch(ex) {

    }
  }

  listenPreview(String song) {
    updateIcon(listenAssetSupport.listenAssetPreview(song));
  }

  loadAsset(String song) {
    SongSingleton.instance.beatPath = song;
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
    Navigator.popAndPushNamed(context, WritingPage.routeName);
  }

}