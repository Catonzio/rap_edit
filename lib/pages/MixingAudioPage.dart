import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rap_edit/controllers/FfmpegController.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/notInUse/CstmDrawer.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/PageStyle.dart';
import 'package:rap_edit/pages/RegistrationsPage.dart';
import 'package:rap_edit/pages/TextsPage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/CstmTextTheme.dart';
import 'package:rap_edit/support/MyColors.dart';

class MixingAudioPage extends StatefulWidget {
  static String routeName = "/mixingAudioPage";

  MixingAudioPageState createState() => MixingAudioPageState();
}

class MixingAudioPageState extends State<MixingAudioPage> with MyPageInterface{

  FfmpegController controller;
  String result;
  TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = new FfmpegController();
    result = "Nothing";
  }

  @override
  Widget build(BuildContext context) {
    return PageStyle(
      pageTitle: "Mixing Audio",
      page: this,
      body: <Widget>[
        TextField(
          controller: textController,
          maxLines: 1,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Song1:", style: CstmTextTheme.buttonText,)
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CstmButton(
              text: "File System",
              pressed: () => loadFromFileSystem(),
            ),
            CstmButton(
              text: "Assets",
              pressed: () => loadFromAssets(),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Song2:", style: CstmTextTheme.buttonText,)
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CstmButton(
              text: "File System",
              pressed: () => loadFromFileSystem(),
            ),
            CstmButton(
              text: "Assets",
              pressed: () => loadFromAssets(),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CstmButton(
              text: "merge",
              pressed: () => mergeSongs(textController.text.trim()),
            )
          ],
        )
      ],
    );
  }

  loadFromFileSystem() async {
    /*String songPath = await FilePicker.getFilePath(type: FileType.audio);
    if(controller.song1 == null || controller.song1.isEmpty)
       controller.song1 = songPath;
    else
      controller.song2 = songPath;*/
    String songPath = FileController.assetPath("Gemitaiz - Gigante (instrumental).mp3");
    debugPrint("Loading $songPath");
    if(controller.song1 == null || controller.song1.isEmpty)
      controller.song1 = songPath;
    else
      controller.song2 = songPath;
  }

  loadFromAssets() {
    String songPath = SongSingleton.instance.beatPath;
    debugPrint("Loading $songPath");
    if(controller.song1 == null || controller.song1.isEmpty)
      controller.song1 = songPath;
    else
      controller.song2 = songPath;
  }

  mergeSongs(String name) {
    merge(name);
  }

  merge(String name) async {
    int res = await controller.mergeSongs(name);
    if(res == 0) {
      setState(() {
        result = "Success!";
      });
    } else {
      setState(() {
        result = "Fail!";
      });
    }
  }

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  void loadMixingAudioPage() => null;

}
