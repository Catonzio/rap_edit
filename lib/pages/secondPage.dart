import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/models/SongFile.dart';

import '../custom_widgets/floatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import 'FileLoadingPage.dart';

class SecondPage extends StatefulWidget {
  static String routeName = "/secondPage";
  SongFile currentSong;

  SecondPage({Key key, this.currentSong});

  @override
  SecondPageState createState() => SecondPageState(currentSong: currentSong);

}

class SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin {

  static final GlobalKey<ScaffoldState> secondPageScaffold = new GlobalKey<ScaffoldState>();

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();
  SongFile currentSong;

  SecondPageState({Key key, this.currentSong});

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    this.saveFile();
  }

  @override
  Widget build(BuildContext context) {

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
      key: secondPageScaffold,
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
                AudioPlayerWidget(),
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

  void saveFile() {
    currentSong = new SongFile(titleController.text.trim(), textController.text.trim(), null);
    if(!currentSong.isEmpty()) {
      FileController.writeFile(currentSong);
      saveSnackbar(titleController.text + " correctly saved!");
    }
    else {
      saveSnackbar("Couldn't save the text!");
    }
  }

  static saveSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.blue,
    );
    secondPageScaffold.currentState.showSnackBar(snackBar);
  }

  void loadFiles(BuildContext context) {
    Navigator.pushNamed(context, FileLoadingPage.routeName);
  }

  setTitleAndText() {
    this.titleController.text = this.currentSong.title;
    this.textController.text = this.currentSong.text;
  }

}
