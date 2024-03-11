import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/pages_controllers/beats_controller.dart';
import 'package:rap_edit/ui/widgets/tiles/beat_tile.dart';
import 'package:rap_edit/utils/constants.dart';
import 'package:rap_edit/utils/extensions/context_extension.dart';

class BeatsPage extends StatelessWidget {
  const BeatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beats Page"),
      ),
      endDrawer: pagesDrawer,
      body: SafeArea(
          child: GetX<BeatsController>(
        initState: (state) => state.controller?.fetchBeats(),
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: context.height * (0.01 + 0.07),
                child: controller.isLoadingBeats
                    ? const Center(child: CircularProgressIndicator())
                    : controller.beats.isEmpty
                        ? const Center(child: Text("No beats available"))
                        : ListView.builder(
                            itemCount: controller.beats.length,
                            itemBuilder: (context, index) => BeatTile(
                                beat: controller.beats[index],
                                onTap: () {
                                  controller.loadBeat(index);
                                  // context.navigator.popAndPushNamed(Routes.writing);
                                  context.navigator.pop();
                                  context.navigator.pushNamed(Routes.writing);
                                })),
              ),
              Positioned(
                bottom: context.height * 0.01,
                left: context.width * (0.5 - 0.3 / 2),
                width: context.width * 0.3,
                height: context.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    controller.loadBeatsFromFileSystem();
                  },
                  child: const AutoSizeText(
                    "From file system",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
