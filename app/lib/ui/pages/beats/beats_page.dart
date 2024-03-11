import 'package:flutter/material.dart';
import 'package:rap_edit/ui/pages/beats/asset_beats.dart';
import 'package:rap_edit/ui/pages/beats/local_beats.dart';
import 'package:rap_edit/ui/pages/beats/store_beats.dart';
import 'package:rap_edit/utils/constants.dart';

class BeatsPage extends StatelessWidget {
  const BeatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Beats Page"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Assets"),
                Tab(text: "Local"),
                Tab(text: "Store"),
              ],
            ),
          ),
          endDrawer: pagesDrawer,
          body: const TabBarView(children: [
            // AssetBeats(controller: controller),
            AssetBeats(),
            LocalBeats(),
            StoreBeats(),
          ])),
    );
  }
}
