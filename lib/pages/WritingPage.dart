import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../custom_widgets/floatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import 'FileLoadingPage.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin {

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();
  static AudioPlayerWidget player;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setTitleAndText();
    player = AudioPlayerWidget();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final titleText = CstmTextField(
      controller: titleController,
      hintText: "insert title",
    );

    final textText = CstmTextField(
      controller: textController,
      hintText: "insert text",
      maxLines: 15,
    );

    final loadSongButton = CstmButton(
      text: "Load",
      pressed: () => { loadSong() },
    );

    return Scaffold(
      //key: secondPageScaffold,
      appBar: GradientAppBar(
        title: Text("RapEdit", style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,),
        centerTitle: true,
        backgroundColorStart: Color(0xFF2C75FF),
        backgroundColorEnd: Colors.black,
        //serve per non permettere di tornare indietro dall'appbar
        automaticallyImplyLeading: false,
      ),
        body: CstmBackGround(
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                player,
                loadSongButton,
                SizedBox(height: 20,),
                titleText,
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

  /// Deletes the current song of the SongSingleton and clears the TextFields
  deleteText() {
    SongSingleton.instance.currentSong = null;
    titleController.clear();
    textController.clear();
  }

  /// Saves the currentSong of the SongSingleton as a File on the file system
  void saveFile(BuildContext context) {
    SongSingleton.instance.currentSong = new SongFile(titleController.text, textController.text, null);
    if(!SongSingleton.instance.currentSong.isEmpty()) {
      FileController.writeFile(SongSingleton.instance.currentSong);
      saveSnackbar(titleController.text + " correctly saved!", context);
    }
    else {
      saveSnackbar("Couldn't save the text!", context);
    }
  }

  /// Display a snackBar with the message passed as argument
  static saveSnackbar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white),),
        backgroundColor: MyColors.darkGrey,
      )
    );
  }

  /// Loads the page of Song Loading
  void loadFiles() {
    loadOtherPage(FileLoadingPage.routeName);
  }

  /// Sets the Title and the Text fields content as the ones of the currentSong of the SongSingleton
  setTitleAndText() {
    if(SongSingleton.instance.currentSong != null) {
      this.titleController.text = SongSingleton.instance.currentSong.title;
      this.textController.text = SongSingleton.instance.currentSong.text;
    }
  }

  /// Loads the page of Beats Loading
  loadSong() {
    loadOtherPage(ChoosingBeatsPage.routeName);
  }

  /// Given a routeName, saves in the currentSong of the SongSingleton
  /// the current Title and Text written in the fields and then navigates to the routeName
  loadOtherPage(String routeName) {
    SongSingleton.instance.currentSong = new SongFile(titleController.text, textController.text, null);
    Navigator.popAndPushNamed(context, routeName);
  }

}
