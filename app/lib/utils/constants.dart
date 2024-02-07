import 'package:flutter/material.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/ui/widgets/pages_drawer.dart';
import 'package:uuid/uuid.dart';

const String lyricsStorageName = "LyricsStorage";
const String beatsStorageName = "BeatsStorage";
const String settingsStorageName = "SettingsStorage";

Uuid uuid = const Uuid();

const oneSecond = Duration(seconds: 1);

List<Beat> assetsBeats = [
  Beat.fromAsset("beats/Gemitaiz - Gigante (instrumental).mp3"),
  Beat.fromAsset("beats/Hip_Hop_Instrumental_Beat.mp3"),
  Beat.fromAsset("beats/metronome_100bpm_4-4.mp3"),
  Beat.fromAsset("beats/metronome_100bpm_6-8.mp3"),
  Beat.fromAsset("beats/Rap_Instrumental_Beat.mp3"),
  Beat.fromAsset("beats/Trap_Instrumental_Beat.mp3"),
  // Beat.empty()
  //   ..songUrl = "beats/Gemitaiz - Gigante (instrumental).mp3"
  //   ..title = "Gemitaiz - Gigante (instrumental)",
  // Beat.empty()
  //   ..songUrl = "beats/Hip_Hop_Instrumental_Beat.mp3"
  //   ..title = "Hip Hop Instrumental Beat",
  // Beat.empty()
  //   ..songUrl = "beats/metronome_100bpm_4-4.mp3"
  //   ..title = "Metronome 100bpm 4-4",
  // Beat.empty()
  //   ..songUrl = "beats/metronome_100bpm_6-8.mp3"
  //   ..title = "Metronome 100bpm 6-8",
  // Beat.empty()
  //   ..songUrl = "beats/Rap_Instrumental_Beat.mp3"
  //   ..title = "Rap Instrumental Beat",
  // Beat.empty()
  //   ..songUrl = "beats/Trap_Instrumental_Beat.mp3"
  //   ..title = "Trap Instrumental Beat",
];

const List<String> musicExtensions = [
  ".mp3",
  ".wav",
  ".ogg",
  ".flac",
  ".acc",
  ".midi",
  ".m4a",
  ".mp4"
];

Widget pagesDrawer = const PagesDrawer();

const Map<String, String> aboutAppInfo = {
  "name": "Rap Edit",
  "version": "0.0.1",
};

const Map<String, String> aboutAuthorInfo = {
  "author": "Danilo Catone",
  "email": "danilocatone@gmail.com",
  "github": "https://github.com/catonzio",
};
