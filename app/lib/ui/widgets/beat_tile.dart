import 'package:flutter/material.dart';
import 'package:rap_edit/data/models/beat.dart';

class BeatTile extends StatelessWidget {
  final Beat beat;
  final Function() onTap;
  const BeatTile({super.key, required this.beat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(beat.title), onTap: onTap);
  }
}
