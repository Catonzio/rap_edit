import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/Trials/RegistrationsPageDuration.dart';
import 'package:rap_edit/controllers/ChoosingBeatsController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/TextsPage.dart';
import 'package:rap_edit/pages/WritingPage.dart';

import '../custom_widgets/CtsmButton.dart';

class ChoosingBeatsPage extends StatefulWidget {
  static String routeName = "/choosingBeats";
  @override
  ChoosingBeatsPageState createState() => ChoosingBeatsPageState();
}

class ChoosingBeatsPageState extends State<ChoosingBeatsPage> with MyPageInterface {

  IconData playPauseIcon = Icons.play_arrow;
  ChoosingBeatsController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<ChoosingBeatsController>(context, listen: false);
    controller.init();
  }

  @override
  void dispose() {
    super.dispose();
    controller.stopPreview();
  }

  updateIcon(IconData data) {
    if(mounted) {
      setState(() {
        playPauseIcon = data;
      });
    }
  }

  loadFromFileSystem(BuildContext context) async {
    if(await controller.loadFromFileSystem())
      loadWritingPage();
  }

  listenPreview(String song) { updateIcon(controller.listenAssetPreview(song)); }

  loadAsset(String song) {
    controller.loadAsset(song);
    loadWritingPage();
  }

  loadFromYoutubeAlertDialog(BuildContext context) {
    TextEditingController urlController = new TextEditingController();

    Widget alert = CstmAlertDialog(
        dialogTitle: "Loading",
        continueText: "Load",
        height: 100,
        body: Column(
          children: <Widget>[
            Text("YouTube url"),
            SizedBox(height: 20.0,),
            CstmTextField(
              maxLines: 1,
              controller: urlController,
              hintText: "insert url",
            )
          ],
        ),
        pressed: () async {
          await controller.loadFromYoutube(urlController.text.trim());
          Navigator.pop(context);
          loadWritingPage();
        }
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChoosingBeatsController controllerListen = Provider.of<ChoosingBeatsController>(context);

    return ListPage(
      title: "Beats",
      listView: ListView.builder(
        itemCount: controller.songs.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return CardFile(
            title: controller.getOnlySongName(controller.songs[index]),
            bottomButtons: <Widget>[
              ButtonCstmCard(
                icon: Icons.file_upload,
                pressed: () => { loadAsset(controller.songs[index]) },
              ),
              ButtonCstmCard(
                icon: playPauseIcon,
                pressed: () => { listenPreview(controller.songs[index]) },
              )
            ],
          );
        },
      ),
      bottomRowButtons: <Widget>[
        CstmButton(
          text: "File System",
          pressed: () => { loadFromFileSystem(context) },
        ),
        //Container(width: 10.0,),
        CstmButton(
          iconData: Icons.home,
          pressed: () => { loadWritingPage() },
        ),
        //Container(width: 10.0,),
        CstmButton(
          text: "YouTube",
          pressed: () => { 
            loadFromYoutubeAlertDialog(context)
          },
        )
      ],
    );
  }

  @override
  void loadChoosingBeatsPage() => null;

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  void loadRegistrationsPage() => loadPage(RegistrationsPageDuration.routeName);

  @override
  void loadTextsPage() => loadPage(TextsPage.routeName);

  @override
  void loadWritingPage() => loadPage(WritingPage.routeName);

}