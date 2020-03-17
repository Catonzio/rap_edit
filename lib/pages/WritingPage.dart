import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/pages/ChoosingBeats.dart';

import '../custom_widgets/floatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import 'FileLoadingPage.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin {

  //static final GlobalKey<ScaffoldState> secondPageScaffold = new GlobalKey<ScaffoldState>();

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setTitleAndText();
  }

  @override
  void dispose() {
    super.dispose();
    //this.saveFile();
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
                AudioPlayerWidget(),
                Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CstmButton(
                            text: "Load",
                            pressed: () => { loadSong(context) },
                          )
                        ],
                      ),
                    )
                ),
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
    SongSingleton.instance.currentSong = null;
    titleController.clear();
    textController.clear();
  }

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

  static saveSnackbar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.blue,
    );
    Scaffold.of(context).showSnackBar(snackBar);
    //secondPageScaffold.currentState.showSnackBar(snackBar);
  }

  void loadFiles(BuildContext context) {
    SongSingleton.instance.currentSong = new SongFile(titleController.text, textController.text, null);
    Navigator.popAndPushNamed(context, FileLoadingPage.routeName);
  }

  setTitleAndText() {
    if(SongSingleton.instance.currentSong != null) {
      this.titleController.text = SongSingleton.instance.currentSong.title;
      this.textController.text = SongSingleton.instance.currentSong.text;
    }
  }

  loadSong(BuildContext context) {
    SongSingleton.instance.currentSong = new SongFile(titleController.text, textController.text, null);
    Navigator.popAndPushNamed(context, ChoosingBeats.routeName);
  }

}
