import 'package:flutter/material.dart';
import 'package:rap_edit/utils/constants.dart';

class MixerPage extends StatelessWidget {
  const MixerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mixer Page"),
      ),
      endDrawer: pagesDrawer,
      body: const Center(
        child: Text("To be implemented"),
      ),
    );
  }
}