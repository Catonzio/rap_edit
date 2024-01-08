import 'package:flutter/material.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/ui/widgets/pages_drawer.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

List<Beat> assetsBeats = [
  Beat.empty()
    ..songUrl = "beats/Gemitaiz - Gigante (instrumental).mp3"
    ..title = "Gemitaiz - Gigante (instrumental)",
  Beat.empty()
    ..songUrl = "Hip_Hop_Instrumental_Beat.mp3"
    ..title = "Hip Hop Instrumental Beat",
  Beat.empty()
    ..songUrl = "metronome_100bpm_4-4.mp3"
    ..title = "Metronome 100bpm 4-4",
  Beat.empty()
    ..songUrl = "metronome_100bpm_6-8.mp3"
    ..title = "Metronome 100bpm 6-8",
  Beat.empty()
    ..songUrl = "Rap_Instrumental_Beat.mp3"
    ..title = "Rap Instrumental Beat",
  Beat.empty()
    ..songUrl = "Trap_Instrumental_Beat.mp3"
    ..title = "Trap Instrumental Beat",
];

Widget pagesDrawer = const PagesDrawer();
