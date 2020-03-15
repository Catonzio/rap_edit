import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../custom_widgets/CtsmButton.dart';

class ChoosingBase extends StatefulWidget {

  @override
  ChoosingBaseState createState() => ChoosingBaseState();
}

class ChoosingBaseState extends State<ChoosingBase> {

  List<Widget> songs;

  @override
  void initState() {
    super.initState();
    //songs = createSongList();
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
              CstmButton(
                pressed: () => {createSongList()},
                text: "Hello",
              )
              //ListView.builder(itemBuilder: null)
            ],
          ),
        ),
      ),
    );
  }

  createSongList() async {

    /*Directory directory = Directory.current;
    List<FileSystemEntity> files = await directory.list().toList();
    files.forEach((f) => {
      debugPrint(f.path)
    });*/
    Directory dir = await (getApplicationDocumentsDirectory());
    Directory newDir = await Directory(dir.path + "/flutter_assets/");
    if(await newDir.exists())
      newDir.listSync().forEach((f) => {
      debugPrint(f.path)
    });
    else
      debugPrint("Non esisteee");
  }

}