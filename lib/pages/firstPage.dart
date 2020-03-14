import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FirstPage extends StatelessWidget {
  String filePath;
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
              "Hello peppe",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white
              ),
            ),
              MaterialButton(
                child: Text(
                  "Clicca qui",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white
                    ),
                  ),
                color: Colors.blue,
              )
            ],
          ),
        ),
    );
  }

}
