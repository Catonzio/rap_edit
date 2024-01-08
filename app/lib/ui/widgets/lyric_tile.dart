import 'package:flutter/material.dart';
import 'package:rap_edit/data/models/lyric.dart';

class LyricTile extends StatelessWidget {
  final Lyric lyric;
  final Function() onTap;
  const LyricTile({super.key, required this.lyric, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(lyric.title), onTap: onTap);
  }
}
