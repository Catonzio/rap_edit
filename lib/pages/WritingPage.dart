import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/models/SongFile.dart';

import '../custom_widgets/floatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import 'FileLoadingPage.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";
  final SongFile currentSong;
  final localFilePath;

  WritingPage({Key key, this.currentSong, this.localFilePath});

  @override
  WritingPageState createState() => WritingPageState(currentSong: currentSong);
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin {

  //static final GlobalKey<ScaffoldState> secondPageScaffold = new GlobalKey<ScaffoldState>();

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();
  SongFile currentSong;
  String localFilePath;

  WritingPageState({Key key, this.currentSong, this.localFilePath});

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    //this.saveFile();
  }

  @override
  Widget build(BuildContext context) {

    var argument;
    if(ModalRoute.of(context) != null) {
      argument = ModalRoute.of(context).settings.arguments;
    }
    if(argument != null && argument is SongFile) {
      currentSong = argument;
    }
    else if(argument != null && argument is String) {
      localFilePath = argument;
    }

    if(currentSong != null) { setTitleAndText(); }

    final titleText = CstmTextField(
      controller: titleController,
      hintText: "insert title",
    );

    final textText = CstmTextField(
      controller: textController,
      hintText: "insert text",
      maxLines: 15,
    );

    return Scaffold(
      //key: secondPageScaffold,
      appBar: AppBar(
        title: Text("RapEdit", style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                AudioPlayerWidget(localFilePath: localFilePath,),
                SizedBox(height: 20,),
                titleText,
                SizedBox(height: 20,),
                SizedBox(height: 20,),
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
      currentSong = null;
      titleController.clear();
      textController.clear();
  }

  void saveFile(BuildContext context) {
    currentSong = new SongFile(titleController.text.trim(), textController.text.trim(), null);
    if(!currentSong.isEmpty()) {
      FileController.writeFile(currentSong);
      saveSnackbar(titleController.text + " correctly saved!", context);
    }
    else {
      saveSnackbar("Couldn't save the text!", context);
    }
  }

  static saveSnackbar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.blue,
    );
    Scaffold.of(context).showSnackBar(snackBar);
    //secondPageScaffold.currentState.showSnackBar(snackBar);
  }

  void loadFiles(BuildContext context) {
    Navigator.popAndPushNamed(context, FileLoadingPage.routeName);
  }

  setTitleAndText() {
    this.titleController.text = this.currentSong.title;
    this.textController.text = this.currentSong.text;
  }

}
