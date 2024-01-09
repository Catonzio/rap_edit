import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/pages_controllers/beats_controller.dart';
import 'package:rap_edit/ui/widgets/tiles/beat_tile.dart';
import 'package:rap_edit/utils/constants.dart';

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
        initState: (state) => state.controller?.loadBeats(),
        builder: (controller) {
          return controller.isLoadingBeats
              ? const Center(child: CircularProgressIndicator())
              : controller.beats.isEmpty
                  ? const Center(child: Text("No beats available"))
                  : ListView.builder(
                      itemCount: controller.beats.length,
                      itemBuilder: (context, index) => BeatTile(
                          beat: controller.beats[index],
                          onTap: () => controller.loadBeat(index)));
        },
      )),
    );
  }
}
