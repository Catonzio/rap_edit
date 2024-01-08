import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/lyrics_controller.dart';
import 'package:rap_edit/ui/widgets/lyric_tile.dart';
import 'package:rap_edit/utils/constants.dart';

class LyricsPage extends StatelessWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lyrics Page"),
      ),
      endDrawer: pagesDrawer,
      body: SafeArea(
          child: GetX<LyricsController>(
        initState: (state) => state.controller?.loadLyrics(),
        builder: (controller) {
          return controller.isLoadingLyrics
              ? const Center(child: CircularProgressIndicator())
              : controller.lyrics.isEmpty
                  ? const Center(child: Text("No lyrics found"))
                  : ListView.builder(
                      itemCount: controller.lyrics.length,
                      itemBuilder: (context, index) => LyricTile(
                            lyric: controller.lyrics[index],
                            onTap: () {
                              controller.loadLyric(index);
                            },
                          ));
        },
      )),
    );
  }
}
