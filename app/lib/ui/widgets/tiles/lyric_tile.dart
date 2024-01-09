import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/models/lyric.dart';
import 'package:rap_edit/ui/widgets/tiles/basic_tile.dart';

class LyricTile extends StatelessWidget {
  final Lyric lyric;
  final Function() onDelete;
  final Function() onLoad;
  const LyricTile(
      {super.key,
      required this.lyric,
      required this.onDelete,
      required this.onLoad});

  @override
  Widget build(BuildContext context) {
    return BasicTile(
        title: Text(lyric.title),
        subtitle: Row(
          children: [
            Expanded(
              flex: 6,
              child: AutoSizeText(
                lyric.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
                flex: 4,
                child: AutoSizeText(
                  lyric.songName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
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
        ));
  }
}
