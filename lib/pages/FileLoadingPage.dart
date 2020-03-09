import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CardFile.dart';
import 'package:rap_edit/main.dart';
import 'package:rap_edit/models/SongFile.dart';

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
        backgroundColor: Colors.black87,
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
                        backgroundColor: Colors.grey,
                        deleteButtonAction: () => { deleteFile(index) },
                        loadButtonAction: () => { loadFile(index )},
                      );
                    },
                  ),
                )
              ]
          ),
        )
    );
  }

  deleteFile(int index) {
    FileController.deleteFile(file[index]);
    setState(() {
      file.remove(file[index]);
    });
  }

  loadFile(int index) {
    Navigator.pushNamed(context, TabBarDemo.routeName, arguments: file[index]);
  }

  getOnlyFirstLine(String text) {
    if(text.contains("\n"))
      return text.substring(0, text.indexOf("\n"));
    else
      return text;
  }


}
