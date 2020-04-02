import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/WritingPage/WritingPage.dart';
import 'package:rap_edit/support/ListenAssetSupport.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../custom_widgets/CtsmButton.dart';

class ChoosingBeatsPage extends StatefulWidget {
  static String routeName = "/choosingBeats";
  @override
  ChoosingBeatsPageState createState() => ChoosingBeatsPageState();
}

class ChoosingBeatsPageState extends State<ChoosingBeatsPage> {

  List<String> songs = new List();
  List<Widget> songsCards = new List();

  IconData playPauseIcon = Icons.play_arrow;
  ListenAssetSupport listenAssetSupport;


  @override
  void initState() {
    super.initState();
    songs = ["Hip_Hop_Instrumental_Beat.mp3", "Rap_Instrumental_Beat.mp3", "Trap_Instrumental_Beat.mp3", "metronome_100bpm_4-4.mp3", "metronome_100bpm_6-8.mp3"];
    listenAssetSupport = ListenAssetSupport();
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
      listView: ListView.builder(
        itemCount: songs.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return CardFile(
            title: getOnlySongName(songs[index]),
            text: "",
            bottomButtons: <Widget>[
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
      ),
      bottomRowButtons: <Widget>[
        CstmButton(
          text: "File System",
          pressed: () => { loadFromFileSystem(context) },
        ),
        //Container(width: 10.0,),
        CstmButton(
          iconData: Icons.home,
          pressed: () => { Navigator.popAndPushNamed(context, WritingPage.routeName, arguments: null) },
        ),
        //Container(width: 10.0,),
        CstmButton(
          text: "YouTube",
          pressed: () => { 
            loadFromYoutubeAlertDialog(context)
          },
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

  loadFromYoutubeAlertDialog(BuildContext context) {
    TextEditingController urlController = new TextEditingController();

    Widget alert = CstmAlertDialog(
      dialogTitle: "Loading",
      continueText: "Load",
      height: 100,
      body: Column(
        children: <Widget>[
          Text("YouTube url"),
          SizedBox(height: 20.0,),
          CstmTextField(
            maxLines: 1,
            controller: urlController,
            hintText: "insert url",
          )
        ],
      ),
      pressed: () async {
        String videoPath = await loadFromYoutube(context, urlController.text);
        debugPrint("Video path: $videoPath");
        SongSingleton.instance.beatPath = videoPath;
        SongSingleton.instance.isLocal = false;
        SongSingleton.instance.isAsset = false;
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, WritingPage.routeName);
      }
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  loadFromYoutube(BuildContext context, String text) async {
    var id = YoutubeExplode.parseVideoId(text);
    var yt = YoutubeExplode();
    var mediaStreams = await yt.getVideoMediaStream(id);
    var audio = mediaStreams.audio;
    return audio[0].url.toString();
  }

}