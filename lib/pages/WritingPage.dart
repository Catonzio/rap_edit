import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/audioplayer/AudioPlayerController.dart';
import 'package:rap_edit/audioplayer/AudioPlayerWidget.dart';
import 'package:rap_edit/controllers/RecorderController.dart';
import 'package:rap_edit/controllers/WritingPageController.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/RecorderWidget.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

import '../models/SongFile.dart';
import '../models/SongSingleton.dart';
import '../support/MyColors.dart';
import 'PageStyle.dart';

class WritingPage extends StatefulWidget {
  static String routeName = "/";

  @override
  WritingPageState createState() => WritingPageState();
}

class WritingPageState extends State<WritingPage> with AutomaticKeepAliveClientMixin, MyPageInterface {

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

    return PageStyle(
      pageTitle: "WritingPage",
      page: this,
      body: <Widget>[
        SizedBox(height: 10.0,),
        ChangeNotifierProvider(
          create: (context) => AudioPlayerController(),
          child: player,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ChangeNotifierProvider(
              create: (context) => RecorderController(),
              child: RecorderWidget(),
            ),
          ],
        ),
        Container(
          height: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(2.0),
                icon: Icon(Icons.delete_forever, color: MyColors.darkRed,),
                onPressed: () => { alertDeleteText(context) },
              ),
              Expanded(
                  child: ListView(
                    children: getRhymesButtons(),
                    scrollDirection: Axis.horizontal,
                  )
              ),
              Builder(
                builder: (context) =>
                    IconButton(
                      padding: EdgeInsets.all(2.0),
                      icon: Icon(Icons.save, color: MyColors.electricBlue),
                      onPressed: () => { alertSaveText(context) },
                    ),
              )
            ],
          ),
        ),
        Expanded(
          child: textText,
        ),
      ],
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
        content: Text(message, style: CstmTextTheme.snackBar),
        backgroundColor: MyColors.darkGrey,
      )
    );
  }

  /// Sets the Title and the Text fields content as the ones of the currentSong of the SongSingleton
  setTitleAndText() => textController.text = Provider.of<WritingPageController>(context, listen: false).setCurrentText();

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
            //visualDensity: VisualDensity.compact,
            onPressed: () => { addTheRhyme(rhymes.indexOf(element)) },
          )
        );
      });
    }
    return listOfButtons;
  }

  alertSaveText(BuildContext context) {
    TextEditingController titleController = new TextEditingController();

    if(SongSingleton.instance.currentSong != null && SongSingleton.instance.currentSong.title.isNotEmpty)
      titleController.text = SongSingleton.instance.currentSong.title;

    Widget alert = CstmAlertDialog(
      dialogTitle: "Saving",
      continueText: "Save",
      height: 100,
      body: Column(
        children: <Widget>[
          Text("How to save?"),
          SizedBox(height: 20.0,),
          CstmTextField(
            maxLines: 1,
            controller: titleController,
            hintText: "insert title",
          )
        ],
      ),
      pressed: () {
        saveFile(context, titleController.text.trim());
        Navigator.pop(context);
      },
    );

    // show the dialog
    showMyDialog(context, alert);
  }

  alertDeleteText(BuildContext context) {
    Widget alert = CstmAlertDialog(
      body: Text("Are you sure you want to delete the text?"),
      continueText: "Delete",
      dialogTitle: "Deleting",
      pressed: () {
        deleteText();
        Navigator.pop(context);
      },
    );
    // show the dialog
    showMyDialog(context, alert);
  }

  showMyDialog(BuildContext context, Widget alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void loadWritingPage() => null;

  @override
  void loadPage(String routeName) {
    if(SongSingleton.instance.currentSong != null)
      SongSingleton.instance.currentSong = new SongFile(
          title: SongSingleton.instance.currentSong.title.trim(),
          text: textController.text.trim(),
      );
    else
      SongSingleton.instance.currentSong = new SongFile(
          title: "",
          text: textController.text
      );
    player.pauseSong();
    Navigator.pushNamed(context, routeName);
  }

}
