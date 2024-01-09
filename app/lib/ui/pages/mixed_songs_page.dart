import 'package:flutter/material.dart';
import 'package:rap_edit/utils/constants.dart';

class MixedSongsPage extends StatelessWidget {
  const MixedSongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mixed Songs Page"),
      ),
      endDrawer: pagesDrawer,
      body: const Center(
        child: Text("To be implemented"),
      ),
    );
  }
}
