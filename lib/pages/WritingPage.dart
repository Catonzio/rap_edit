import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/custom_widgets/RecorderWidget.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../controllers/SongSingleton.dart';
import '../custom_widgets/FloatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import '../support/MyColors.dart';
import 'FileLoadingPage.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin {

  //final TextEditingController titleController = new TextEditingController();
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
  // ignore: must_call_super
  Widget build(BuildContext context) {

    final textText = CstmTextField(
      controller: textController,
      hintText: "insert text",
      maxLines: 20,
    );

    final loadSongButton = CstmButton(
      text: "Beats",
      pressed: () => { loadSong() },
    );

    Text titleText;
    if(SongSingleton.instance.currentSong != null && SongSingleton.instance.currentSong.title.isNotEmpty) {
      titleText = Text(SongSingleton.instance.currentSong.title, style: Theme.of(context).textTheme.title, textAlign: TextAlign.center);
    } else {
      titleText = Text("RapEdit", style: Theme.of(context).textTheme.title, textAlign: TextAlign.center,);
    }


    return Scaffold(
      //key: secondPageScaffold,
      appBar: GradientAppBar(
        title: titleText,
        centerTitle: true,
        backgroundColorStart: MyColors.electricBlue,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    loadSongButton,
                    RecorderWidget()
                  ],
                ),
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

  /// Deletes the current song of the SongSingleton and clears the TextFields
  deleteText() {
    SongSingleton.instance.currentSong.text = "";
    textController.clear();
  }

  /// Saves the currentSong of the SongSingleton as a File on the file system
  void saveFile(BuildContext context, TextEditingController titleController) {
    SongSingleton.instance.currentSong = new SongFile(titleController.text, textController.text, null);
    if(!SongSingleton.instance.currentSong.isEmpty()) {
      FileController.writeFile(SongSingleton.instance.currentSong);
      displaySnackbar(titleController.text + " correctly saved!", context);
    }
    else {
      displaySnackbar("Couldn't save! Text is empty", context);
    }
  }

  /// Display a snackBar with the message passed as argument
  static displaySnackbar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white),),
        backgroundColor: MyColors.darkGrey,
      )
    );
  }

  /// Loads the page of Song Loading
  void loadFiles() {
    loadOtherPage(TabbedLoading.routeName);
  }

  /// Sets the Title and the Text fields content as the ones of the currentSong of the SongSingleton
  setTitleAndText() {
    if(SongSingleton.instance.currentSong != null) {
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
    if(SongSingleton.instance.currentSong != null)
      SongSingleton.instance.currentSong = new SongFile(SongSingleton.instance.currentSong.title, textController.text, null);
    else
      SongSingleton.instance.currentSong = new SongFile("", "", null);
    Navigator.popAndPushNamed(context, routeName);
  }

}
