import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/models/SongFile.dart';

import '../custom_widgets/floatingButtonsCarouselPage.dart';
import 'FileLoadingPage.dart';

// ignore: must_be_immutable
class SecondPage extends StatefulWidget {
  static String routeName = "/secondPage";
  SecondPageState state;
  SongFile currentFile;

  SecondPage(this.currentFile);

  @override
  SecondPageState createState() => state = SecondPageState(currentFile);
}

class SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin {

  final TextStyle stileIntestazioni = new TextStyle(color: Colors.white, fontSize: 20);
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();
  SongFile currentFile;

  SecondPageState(this.currentFile);

  void setCurrentFile(currentFile) {
    this.currentFile = currentFile;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    if(currentFile != null && (currentFile.title != null || currentFile.title.isEmpty)) {
      textController.text = currentFile.text;
      titleController.text = currentFile.title;
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
      titleController.clear();
      textController.clear();
  }

  void saveFile() {
    currentFile = new SongFile(titleController.text.trim(), textController.text.trim(), null);
    FileController.writeFile(currentFile);
  }

  void loadFiles(BuildContext context) {
    Navigator.pushNamed(context, FileLoadingPage.routeName);
  }

}
