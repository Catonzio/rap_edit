import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/pages_controllers/beats_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/ui/widgets/search_beat_widget.dart';
import 'package:rap_edit/ui/widgets/tiles/beat_tile.dart';
import 'package:rap_edit/utils/extensions/context_extension.dart';

class LocalBeats extends StatelessWidget {
  const LocalBeats({super.key});

  @override
  Widget build(BuildContext context) {
    final BeatsController controller = BeatsController.to;
    final Widget uploaderButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          controller.uploadBeatsFromFileSystem();
        },
        child: const AutoSizeText(
          "Load From file system",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    return Obx(() {
      if (controller.isLoadingBeats) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.localBeats.isEmpty) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [const Text("No local beats available"), uploaderButton],
        ));
      }
      return Column(
        children: [
          SearchBeatWidget(controller: controller),
          Expanded(
            child: ListView(
              children: controller.localBeats
                  .where((p0) => p0.title
                      .toLowerCase()
                      .contains(controller.searchString.toLowerCase()))
                  .toList()
                  .map((Beat e) => BeatTile(
                      beat: e,
                      onUpload: () {
                        controller.loadBeat(e);
                        context.navigator.pop();
                        context.navigator.pushNamed(Routes.writing);
                      }))
                  .toList(),
            ),
          ),
          uploaderButton
        ],
      );
    });
  }
}
