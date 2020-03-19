import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';

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
    songs = ["metronome_100bpm_2-4.mp3", "metronome_100bpm_4-4.mp3", "metronome_100bpm_6-8.mp3", "metronome_100bpm_8-8.mp3"];
    if(player == null && cache == null) {
      player = AudioPlayer();
      cache = AudioCache(fixedPlayer: player);
      player.onPlayerStateChanged.listen((AudioPlayerState s) {
        if(player != null)
          setState(() => playerState = s);
      });
    }
    createSongList();
  }

  @override
  void dispose() {
    super.dispose();
    player.stop();
    cache.clearCache();
    player.release();
    player = null;
    cache = null;
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
                    itemCount: songs.length,
                    shrinkWrap: true,
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
                          )
                      );
                    },
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                )
              ],
            ),
          ),
        ),
      )
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
      String localFilePath = await FilePicker.getFilePath(type: FileType.AUDIO);
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
  }

  loadAsset(String song) {
    SongSingleton.instance.beatPath = song;
    SongSingleton.instance.isAsset = true;
    SongSingleton.instance.isLocal = false;
    Navigator.popAndPushNamed(context, WritingPage.routeName);
  }

}