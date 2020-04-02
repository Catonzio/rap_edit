import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/audioplayer/AudioPlayerController.dart';
import 'package:rap_edit/audioplayer/AudioPlayerWidget.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/custom_widgets/FloatingButtonsCarouselPage.dart';
import 'package:rap_edit/custom_widgets/OtherRecorderWidget.dart';
import 'package:rap_edit/drawer/CstmDrawer.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/pages/WritingPage/WritingPageController.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../../models/SongFile.dart';
import '../../models/SongSingleton.dart';
import '../../support/MyColors.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin {

  TextEditingController textController;
  AudioPlayerWidget player;
  List<String> rhymes = new List();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    textController = new TextEditingController();
    setTitleAndText();
    player = AudioPlayerWidget();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {

    final controller = Provider.of<WritingPageController>(context);
    textController.addListener(() => listenForText(controller));

    final textText = CstmTextField(
      controller: textController,
      hintText: "insert text",
      maxLines: 20,
    );

    final loadSongButton = CstmButton(
      text: "Beats",
      pressed: () => { loadSong() },
    );

    return Scaffold(
      //key: secondPageScaffold,
      appBar: GradientAppBar(
        title: controller.setTitleText(),
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
        floatingActionButton: FloatingButtonsCarousel(this),
        );
  }

  /// Deletes the current song of the SongSingleton and clears the TextFields
  deleteText() {
    if(SongSingleton.instance.currentSong != null)
      SongSingleton.instance.currentSong.text = "";
    textController.clear();
  }

  /// Saves the currentSong of the SongSingleton as a File on the file system
  void saveFile(BuildContext context, String title) {
    int result = Provider.of<WritingPageController>(context, listen: false).saveFile(title, textController.text.trim());

    if(result == -1)
      displaySnackbar("Couldn't save! Title is empty!", context);
    else if(result == 1)
        displaySnackbar(title + " correctly saved!", context);
    else
      displaySnackbar("Couldn't save! Text is empty", context);
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
  void loadFiles() => loadOtherPage(TabbedLoading.routeName);

  /// Sets the Title and the Text fields content as the ones of the currentSong of the SongSingleton
  setTitleAndText() => textController.text = Provider.of<WritingPageController>(context, listen: false).setCurrentText();


  /// Loads the page of Beats Loading
  loadSong() => loadOtherPage(ChoosingBeatsPage.routeName);


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

  listenForText(WritingPageController controller) {
    List<String> rime = controller.listenForText(textController);
    if(rime != null && rime.isNotEmpty) {
      setState(() { rhymes = rime; });
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
            child: Text(element),
            onPressed: () => { addTheRhyme(rhymes.indexOf(element)) },
          )
        );
      });
    }
    return listOfButtons;
  }

}
