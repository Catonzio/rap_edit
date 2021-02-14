import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/controllers/ChoosingBeatsController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CstmAlertDialog.dart';
import 'package:rap_edit/custom_widgets/CstmTextField.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/support/MyColors.dart';

class ChoosingBeatsPage extends StatefulWidget {
  static String routeName = "/choosingBeats";
  @override
  ChoosingBeatsPageState createState() => ChoosingBeatsPageState();
}

class ChoosingBeatsPageState extends State<ChoosingBeatsPage> with MyPageInterface {

  List<IconData> playPauseIcons = List();
  ChoosingBeatsController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<ChoosingBeatsController>(context, listen: false);
    controller.init();
    controller.songs?.forEach((element) { playPauseIcons.add(Icons.play_arrow); });
  }

  @override
  void dispose() {
    super.dispose();
    controller.stopPreview();
  }

  updateIcon(IconData data, int index) {
    if(mounted) {
      setState(() {
        playPauseIcons[index] = data;
      });
    }
  }

  loadFromFileSystem() async {
    if(await controller.loadFromFileSystem())
      loadWritingPage();
  }

  listenPreview(int index) {
    if(playPauseIcons[index] == Icons.play_arrow) {
     updateIcon(Icons.stop, index);
    } else if(playPauseIcons[index] == Icons.stop) {
      updateIcon(Icons.play_arrow, index);
    }
    for(int i = 0; i<playPauseIcons.length; i++) {
      if(i!=index)
        playPauseIcons[i] = Icons.play_arrow;
    }
    controller.listenAssetPreview(controller.songs[index]);
  }

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

    return ListPage(
      title: "Beats",
      pageInterface: this,
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
                icon: playPauseIcons[index],
                pressed: () => { listenPreview(index) },
              )
            ]
          );
        },
      ),
       bottomRowButtons: <Widget>[
         Material(
           color: MyColors.deepPurpleOpac.withOpacity(0.5),
           borderRadius: BorderRadius.circular(20),
           child: FlatButton(
             child: Text("File system"),
             onPressed: () => loadFromFileSystem(),
           ),
           elevation: 20,
         ),
         IconButton(
           icon: Icon(Icons.home),
           onPressed: () => loadWritingPage(),
         ),
         Material(
           color: MyColors.deepPurpleOpac.withOpacity(0.5),
           borderRadius: BorderRadius.circular(20),
           child: FlatButton(
             child: Text("YouTube"),
             onPressed: () => loadFromYoutubeAlertDialog(context),
           ),
           elevation: 20,
         ),
       ],
    );
  }

  @override
  void loadChoosingBeatsPage() => null;

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

}