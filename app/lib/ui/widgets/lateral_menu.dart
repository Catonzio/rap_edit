import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/navigation_controller.dart';

class LateralMenu extends StatelessWidget {
  const LateralMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<NavigationController>(
      builder: (controller) {
        return NavigationRail(
          elevation: 10,
          onDestinationSelected: (value) => controller.selectedIndex = value,
          selectedIndex: controller.selectedIndex,
          useIndicator: true,
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
                icon: Icon(Icons.draw), label: Text("Writing")),
            NavigationRailDestination(
                icon: Icon(Icons.queue_music), label: Text("Load beat")),
            NavigationRailDestination(
                icon: Icon(Icons.upload_file), label: Text("Load lyric")),
            NavigationRailDestination(
                icon: Icon(Icons.spatial_audio_off), label: Text("Load recs")),
            NavigationRailDestination(
                icon: Icon(Icons.multitrack_audio), label: Text("Mix audio")),
            NavigationRailDestination(
                icon: Icon(Icons.mic_external_on_rounded),
                label: Text("Mixed songs")),
            NavigationRailDestination(
                icon: Icon(Icons.settings), label: Text("Settings")),
            NavigationRailDestination(
                icon: Icon(Icons.info), label: Text("About")),
          ],
        );
      },
    );
  }
}
