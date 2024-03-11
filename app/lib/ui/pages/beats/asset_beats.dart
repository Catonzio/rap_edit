import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/pages_controllers/beats_controller.dart';
import 'package:rap_edit/data/models/beat.dart';
import 'package:rap_edit/ui/widgets/search_beat_widget.dart';
import 'package:rap_edit/ui/widgets/tiles/beat_tile.dart';
import 'package:rap_edit/utils/extensions/context_extension.dart';

class AssetBeats extends StatelessWidget {
  const AssetBeats({super.key});

  @override
  Widget build(BuildContext context) {
    final BeatsController controller = BeatsController.to;

    return Obx(() {
      if (controller.isLoadingBeats) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.assetBeats.isEmpty) {
        return const Center(child: Text("No asset beats available"));
      }
      return Column(
        children: [
          SearchBeatWidget(controller: controller),
          Expanded(
            child: ListView(
              children: controller.assetBeats
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
        ],
      );
    });
  }
}
