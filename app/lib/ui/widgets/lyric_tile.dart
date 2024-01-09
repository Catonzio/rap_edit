import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/models/lyric.dart';

class LyricTile extends StatelessWidget {
  final Lyric lyric;
  final Function() onDelete;
  final Function() onLoad;
  const LyricTile({super.key, required this.lyric, required this.onDelete, required this.onLoad});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
          horizontal: context.width * 0.05, vertical: context.height * 0.01),
      child: ListTile(
          title: Text(lyric.title),
          subtitle: AutoSizeText(
            lyric.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_forever),
                color: Themes.red,
              ),
              IconButton(
                onPressed: onLoad,
                icon: const Icon(Icons.upload_rounded),
                color: Themes.blue,
              ),
            ],
          )),
    );
  }
}
