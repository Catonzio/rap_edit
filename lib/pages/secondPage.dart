import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/models/SongFile.dart';

import '../custom_widgets/floatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import 'FileLoadingPage.dart';

// ignore: must_be_immutable
class SecondPage extends StatefulWidget {
  static String routeName = "/secondPage";
  SecondPageState state;
  @override
  SecondPageState createState() =>  state = SecondPageState();

  setCurrentSong(SongFile song) {
    if(state != null)
      state.setCurrentSong(song);
  }

}

class SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin {

  final TextStyle stileIntestazioni = new TextStyle(color: Colors.white, fontSize: 20);
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();
  static SongFile currentFile;

  @override
  bool get wantKeepAlive => true;

  setCurrentSong(SongFile song) {
      if(song != null && !song.isEmpty()) {
        currentFile = song;
      }
  }

  @override
  Widget build(BuildContext context) {
    if(currentFile != null) {
      textController.text = currentFile.text;
      titleController.text = currentFile.title;
      debugPrint("ooooooooooooooo " + textController.text);
      debugPrint("ooooooooooooooo " + titleController.text);
    }
    final titleText = TextField(
      obscureText: false,
      cursorColor: Colors.white,
      style: stileIntestazioni,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "insert title",
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(8.0)
          ),
      ),
      controller: titleController
    );

    final textText = TextField(
      obscureText: false,
      cursorColor: Colors.white,
      style: stileIntestazioni,
      maxLines: 15,
      //style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "insert text",
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(8.0)
          ),
      ),
      controller: textController,
    );

    return Scaffold(
        backgroundColor: Colors.black87,
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(height: 20,),
                AudioPlayerWidget(),
                titleText,
                Container(height: 20,),
                Container(height: 10,),
                Expanded(
                  child: textText,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingButtonsCarousel(this),
    );
  }

  deleteText() {
      this.setCurrentSong(new SongFile("", "", ""));
      titleController.clear();
      textController.clear();
  }

  void saveFile() {
    currentFile = new SongFile(titleController.text.trim(), textController.text.trim(), null);
    FileController.writeFile(currentFile);
  }

  void loadFiles(BuildContext context) {
    Navigator.popAndPushNamed(context, FileLoadingPage.routeName);
  }

}
