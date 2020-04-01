import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/audioplayer/AudioPlayerController.dart';
import 'package:rap_edit/audioplayer/AudioPlayerWidget.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/custom_widgets/OtherRecorderWidget.dart';
import 'package:rap_edit/drawer/CstmDrawer.dart';
import 'package:rap_edit/models/Dictionary.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../custom_widgets/FloatingButtonsCarouselPage.dart';
import '../models/SongFile.dart';
import '../models/SongSingleton.dart';
import '../support/MyColors.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin {

  final TextEditingController textController = new TextEditingController();
  String lastString = "";
  AudioPlayerWidget player;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setTitleAndText();
    player = AudioPlayerWidget();
    textController.addListener(listenForText);
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
        backgroundColorStart: MyColors.primaryColor,
        backgroundColorEnd: MyColors.endElementColor,
        //serve per non permettere di tornare indietro dall'appbar
        //automaticallyImplyLeading: false,
      ),
        drawer: CstmDrawer(),
        body: CstmBackGround(
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                ChangeNotifierProvider(
                  create: (context) => AudioPlayerController(),
                  child: player,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    loadSongButton,
                    OtherRecorderWidget()
                  ],
                ),
                Container(
                  height: 30,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: getRhymesButtons(),
                            scrollDirection: Axis.horizontal,
                          )
                        )
                      ],
                  ),
                ),
                Expanded(
                  child: textText,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [MyColors.endElementColor, MyColors.primaryColor]
              ),
              borderRadius: BorderRadius.circular(50.0)
          ),
          child: new FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.transparent,
            mini: true,
            child: new Icon(Icons.delete, color: MyColors.textColor),
            onPressed: () { //alertDeleteText(context);
               },
          ),
        )
    );
  }

  /// Deletes the current song of the SongSingleton and clears the TextFields
  deleteText() {
    SongSingleton.instance.currentSong.text = "";
    textController.clear();
  }

  /// Saves the currentSong of the SongSingleton as a File on the file system
  void saveFile(BuildContext context, TextEditingController titleController) {
    if(titleController.text.trim().isEmpty) {
      displaySnackbar("Couldn't save! Title is empty!", context);
    } else {
      SongSingleton.instance.currentSong = new SongFile(
          titleController.text.trim(), textController.text.trim(), null);
      if (!SongSingleton.instance.currentSong.isEmpty()) {
        FileController.writeFile(SongSingleton.instance.currentSong);
        displaySnackbar(titleController.text + " correctly saved!", context);
      }
      else {
        displaySnackbar("Couldn't save! Text is empty", context);
      }
    }
  }

  /// Display a snackBar with the message passed as argument
  static displaySnackbar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: MyColors.textColor),),
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
      this.textController.text = SongSingleton.instance.currentSong.text.trim();
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
      SongSingleton.instance.currentSong = new SongFile(SongSingleton.instance.currentSong.title.trim(), textController.text.trim(), null);
    else
      SongSingleton.instance.currentSong = new SongFile("", textController.text, null);
    player.pauseSong();
    Navigator.pushNamed(context, routeName);
  }


  listenForText() {
    if(textController.text.trim().isNotEmpty && textController.selection.baseOffset > 0) {
      String untilSelection = textController.text.substring(
          0, textController.selection.base.offset);
      List<String> listOfLines = untilSelection.split("\n");
      if (listOfLines.length > 1) {
        List<String> secondLastLineSplitted = listOfLines[listOfLines.length - 2].split(" ");
        setState(() {
          if (secondLastLineSplitted.length > 0) {
            String possibleRhyme = secondLastLineSplitted[secondLastLineSplitted
                .length - 1];
            if (lastString != possibleRhyme) {
              lastString = possibleRhyme;
              getRhymeWord();
            }
          }
        });
      }
    }
  }

  List<String> rhymes = new List();

  getRhymeWord() {
    if(lastString != null && lastString.isNotEmpty) {
      setState(() {
        rhymes = Dictionary.instance.getRhymeWord(lastString);
      });
    }
  }

  addTheRhyme(int i) {
    TextSelection selection = TextSelection(baseOffset: textController.selection.baseOffset  + rhymes[i].length,
        extentOffset: textController.selection.extentOffset  + rhymes[i].length);
    setState(() {
      textController.text = textController.text + rhymes[i];
    });
    textController.selection = selection;
  }

  getRhymesButtons() {
    List<Widget> listOfButtons = new List();
    if(rhymes != null && rhymes.length > 0) {
      rhymes.forEach((element) {
        listOfButtons.add(
          FlatButton(
            child: Text(element, style: Theme.of(context).textTheme.body1,),
            onPressed: () => { addTheRhyme(rhymes.indexOf(element)) },
          )
        );
      });
    }
    return listOfButtons;
  }
}
