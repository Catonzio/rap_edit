import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/SongSingleton.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/custom_widgets/CstmBackGround.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/models/SongFile.dart';
import 'package:rap_edit/pages/WritingPage.dart';

class FileLoadingPage extends StatefulWidget {
  static const routeName = '/filesPage';

  @override
  State createState() => FileLoadingPageState();
}

class FileLoadingPageState extends State<FileLoadingPage> {

  List<SongFile> file = new List();

  @override
  void initState() {
    super.initState();
    file = FileController.getListOfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CstmBackGround(
          body: Center(
            child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: file.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardFile(
                          title: file[index].title,
                          color: Colors.white,
                          icon: Icons.file_upload,
                          text: getOnlyFirstLine(file[index].text) + "\n\nLast modified: " + file[index].lastModifiedToString(),
                          backgroundColor: Theme.of(context).primaryColor,
                          deleteButtonAction: () => { deleteFile(index) },
                          loadButtonAction: () => { loadFile(index )},
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  CstmButton(
                    iconData: Icons.home,
                    pressed: () => { Navigator.pushNamed(context, WritingPage.routeName) },
                  ),
                  SizedBox(height: 10,)
                ]
            ),
          )
        )
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
    Navigator.popAndPushNamed(context, WritingPage.routeName);
  }

  /// Returns only the first line of the string
  getOnlyFirstLine(String text) {
    if(text.contains("\n"))
      return text.substring(0, text.indexOf("\n"));
    else
      return text;
  }


}
