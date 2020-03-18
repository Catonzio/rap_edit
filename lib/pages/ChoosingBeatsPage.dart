import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/pages/WritingPage.dart';

import '../custom_widgets/CtsmButton.dart';

class ChoosingBeatsPage extends StatefulWidget {
  static String routeName = "/choosingBeats";
  @override
  ChoosingBeatsPageState createState() => ChoosingBeatsPageState();
}

class ChoosingBeatsPageState extends State<ChoosingBeatsPage> {

  List<String> songs = new List();
  List<Widget> songsCards = new List();
  String loadButtonText = "Load";
  String previewButtonText = "Preview";
  AudioPlayer player;
  AudioCache cache;
  AudioPlayerState playerState;

  @override
  void initState() {
    super.initState();
    songs = ["metronome_100bpm_8-8.mp3", "metronome_120bpm_4-4.mp3"];
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    player.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() => playerState = s);
    });
    createSongList();
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
              ListView.builder(
                itemCount: songs.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
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
                              child: Text(loadButtonText),
                              onPressed: () => { loadAsset(songs[index]) }
                            ),
                            MaterialButton(
                              child: Text(previewButtonText),
                              onPressed: () => { listenPreview(songs[index]) },
                            )
                          ],
                        )
                      ],
                    )
                  );
                },
              ),
              //ListView(children: songsCards,),
              SizedBox(height: 30,),
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
    //Future<String> structure = rootBundle.loadString("assets/structure.txt");
    //Future<List<String>> futureSongs = structure.asStream().forEach((str) => { str.split("\n") });
    //debugPrint("ooooooooo " + futureSongs.toString());
    //String structure = await rootBundle.loadString("assets/structure.txt");
    //this.songs = structure.split("\n");
    //buildSongList();
  }

  String getOnlySongName(String song) {
    return song.substring(song.indexOf("/") + 1, song.lastIndexOf(".mp3"));
  }

  loadFromFileSystem(BuildContext context) async {
    try {
      String localFilePath = await FilePicker.getFilePath(type: FileType.audio);
      if(localFilePath != null && localFilePath.isNotEmpty) {
        SongSingleton.instance.beatPath = localFilePath;
        SongSingleton.instance.isLocal = true;
        SongSingleton.instance.isAsset = false;
        Navigator.pushNamed(context, WritingPage.routeName);
      }
    } catch(ex) {

    }
  }

  listenPreview(String song) {
    if(playerState != AudioPlayerState.PLAYING) {
      setState(() {
        previewButtonText = "Stop";
      });
      cache.play(song);
    } else if(playerState == AudioPlayerState.PLAYING) {
      setState(() {
        previewButtonText = "Preview";
      });
      player.stop();
    }
  }

  void buildSongList() {
    songs.forEach((song) {
      songsCards.add(
        Card(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(getOnlySongName(song)),
              ),
              ButtonBar(
                children: <Widget>[
                  MaterialButton(
                    child: Text(loadButtonText),
                  ),
                  MaterialButton(
                    child: Text(previewButtonText),
                    onPressed: () => { listenPreview(song) },
                  )
                ],
              )
            ],
          )
        )
      );
    });
    debugPrint("oooooooooooooooo " + songsCards.toString());
  }

  loadAsset(String song) {
    SongSingleton.instance.beatPath = song;
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
    Navigator.pushNamed(context, WritingPage.routeName);
  }

}