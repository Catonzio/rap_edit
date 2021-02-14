import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/audioplayer/SimpleAudioPlayer.dart';
import 'package:rap_edit/controllers/FfmpegController.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/custom_widgets/CtsmButton.dart';
import 'package:rap_edit/models/SongSingleton.dart';
import 'package:rap_edit/pages/MyPageInterface.dart';
import 'package:rap_edit/pages/PageStyle.dart';

class MixingAudioPage extends StatefulWidget {
  static String routeName = "/mixingAudioPage";

  MixingAudioPageState createState() => MixingAudioPageState();
}

class MixingAudioPageState extends State<MixingAudioPage> with MyPageInterface, WidgetsBindingObserver {

  FfmpegController controller;
  String result;
  TextEditingController textController = new TextEditingController();
  SimpleAudioPlayer player;
  double beatVolume = 0.0;
  double vocalVolume = 0.0;
  TextEditingController beatTextController = new TextEditingController();
  TextEditingController vocalTextController = new TextEditingController();

  String beat = "/data/data/com.catonz.rap_edit/cache/Hip_Hop_Instrumental_Beat.mp3";
  String vocal = "/data/data/com.catonz.rap_edit/app_flutter/registrations/prova .wav";

  @override
  void initState() {
    super.initState();
    controller = new FfmpegController();
    controller.song1 = beat;
    controller.song2 = vocal;
    beatTextController.text = "$beatVolume";
    vocalTextController.text = "$vocalVolume";
    result = "Nothing";
    player = SimpleAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return PageStyle(
      pageTitle: "Mixing Audio",
      page: this,
      body: <Widget>[
        SizedBox(height: 10.0,),
        player,
        Text("Output name:"),
        TextField(
          controller: textController,
          maxLines: 1,
        ),
        SizedBox(height: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CstmButton(
                  text: "Load beat",
                  pressed: () => debugPrint("Load Beat"),
                ),
                Text("${beat.substring(beat.lastIndexOf("/") + 1)}")
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                CstmButton(
                    text: "Load vocal",
                    pressed: () => debugPrint("Load vocal")
                ),
                Text("Vocal: ${vocal.substring(vocal.lastIndexOf("/") + 1)}")
              ],
            )
          ],
        ),
        SizedBox(height: 20,),
        CstmButton(
         text: "Mix",
          pressed: () => mix(textController.text.trim()),
        ),
        SizedBox(height: 20,),
        Text("$result"),
        SizedBox(height: 20,),
        Expanded(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Beat volume"),
                  RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      min: 0.0,
                      value: beatVolume,
                      max: 10,
                      onChanged: (newValue) {
                        setState(() {
                          beatVolume = roundDouble(newValue, 2);
                          beatTextController.text = "$beatVolume";
                          print("Bella zio " + beatTextController.text);
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    child: TextField(
                      controller: beatTextController,
                      onChanged: (str) {
                        double val = double.parse(str);
                        setState(() {
                          print("Beat volume: $beatVolume");
                          beatVolume = roundDouble(val, 2);
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.3,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vocal volume"),
                  RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      min: 0.0,
                      value: vocalVolume,
                      max: 10,
                      onChanged: (newValue) {
                        setState(() {
                          vocalVolume = roundDouble(newValue, 2);
                        });
                      },
                    ),
                  ),
                  Text("$vocalVolume")
                ],
              )
            ],
          )
        )
      ],
    );
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
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
    mix(name);
  }

  mix(String name) async {
    Future<int> res = controller.mergeSongs(name, beatVolume, vocalVolume);
    res.then((value) {
      //this.player.loadAsset(FileController.mixedSongsPath + name);
      this.player.loadAsset("/mixed/" + name);
      if(value == 0) {
        setState(() {
          result = "Success!";
        });
      } else {
        setState(() {
          result = "Fail!";
        });
      }
    });
  }

  @override
  void loadPage(String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  @override
  void loadMixingAudioPage() => null;

}
