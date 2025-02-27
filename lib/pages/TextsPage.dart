import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/ListPage.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:share_extend/share_extend.dart';

class TextsPage extends StatefulWidget {
  static const routeName = '/textsPage';

  @override
  State createState() => TextsPageState();
}

class TextsPageState extends State<TextsPage> with MyPageInterface{

  List<SongFile> file = new List();

  @override
  void initState() {
    super.initState();
    file = FileController.getListOfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return ListPage(
      title: "Texts",
      pageInterface: this,
      listView: file.length == 0 ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("No text available")
            ],
          )
          :
      ListView.builder(
        itemCount: file.length,
        itemBuilder: (BuildContext context, int index) {
          return CardFile(
            title: file[index].title,
            text: getOnlyFirstLine(file[index].text),
            bottomButtons: <Widget>[
              ButtonCstmCard(
                icon: Icons.delete,
                pressed: () => { deleteFile(index) },
              ),
              ButtonCstmCard(
                icon: Icons.share,
                pressed: () => { shareText(file[index]) },
              ),
              ButtonCstmCard(
                icon: Icons.file_upload,
                pressed: () => { loadFile(index) },
              )
            ],
          );
        },
      ),
    );
  }

  /// Deletes the FileSystemEntity correlated with the selected Song from the file system
  deleteFile(int index) {
    FileController.deleteFile(file[index]);
    setState(() {
      file.remove(file[index]);
    });
  }

  /// Loads the selected Song from the file system and displays its Title and Text in the WritingPage
  loadFile(int index) {
    SongSingleton.instance.currentSong = file[index];
    if(file[index].beatPath != null) {
      SongSingleton.instance.beatPath = file[index].beatPath;
      SongSingleton.instance.isAsset = file[index].beatIsAsset;
      SongSingleton.instance.isLocal = file[index].beatIsLocal;
    }
    loadWritingPage();
  }

  /// Returns only the first line of the string
  getOnlyFirstLine(String text) {
    if(text.contains("\n"))
      return text.substring(0, text.indexOf("\n"));
    else
      return text;
  }

  shareText(SongFile file) {
    ShareExtend.share(file.title + "\n\n" + file.text, "text");
  }

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  void loadTextsPage() => null;


}
