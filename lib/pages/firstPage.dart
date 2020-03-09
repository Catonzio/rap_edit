import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FirstPage extends StatelessWidget {
  String filePath;
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.black87,
          child: Center(
            child: Column(
              children: <Widget>[
                MaterialButton(
                  child: Text(
                    "Load"
                  ),
                  onPressed: () => { loadFile() },
                ),
                TextField(
                  readOnly: true,
                  controller: controller,
                )
              ],
            ),
          ),
        )
    );
  }

  loadFile() async {

    filePath = await FilePicker.getFilePath(type: FileType.ANY);
    debugPrint("ooooo $filePath");
    controller.text = filePath;
  }
}
