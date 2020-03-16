import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/pages/WritingPage.dart';

import '../custom_widgets/CtsmButton.dart';

class ChoosingBeats extends StatefulWidget {
  static String routeName = "/choosingBeats";
  @override
  ChoosingBeatsState createState() => ChoosingBeatsState();
}

class ChoosingBeatsState extends State<ChoosingBeats> {

  List<String> songs = new List();

  @override
  void initState() {
    super.initState();
    createSongList();
    debugPrint("oooooooo fetched strings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*ListView.builder(
                itemCount: songs.length,
                itemBuilder: (BuildContext context, int index) {
                  debugPrint("oooooooo Building List");
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(getOnlySongName(songs[index])),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            MaterialButton(
                              child: Text("Load"),
                            ),
                            MaterialButton(
                              child: Text("Preview"),
                            )
                          ],
                        )
                      ],
                    )
                  );
                },
              ),*/
              CstmButton(
                text: "From file System",
                pressed: () => { loadFromFileSystem(context) },
              ),
              SizedBox(height: 30.0,),
              CstmButton(
                text: "Home",
                pressed: () => { Navigator.pushNamed(context, WritingPage.routeName, arguments: null) },
              )
            ],
          ),
        ),
      ),
    );
  }

  createSongList() async {
    String structure = await rootBundle.loadString("assets/music/structure.txt");
    this.songs = structure.split("\n");
  }

  String getOnlySongName(String song) {
    return song.substring(song.indexOf("/") + 1, song.lastIndexOf(".mp3"));
  }

  loadFromFileSystem(BuildContext context) async {
    try {
      String localFilePath = await FilePicker.getFilePath(type: FileType.audio);
      if(localFilePath != null && localFilePath.isNotEmpty) {
        Navigator.pushNamed(context, WritingPage.routeName, arguments: localFilePath);
      }
    } catch(ex) {

    }
  }

}