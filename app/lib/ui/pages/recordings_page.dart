import 'package:flutter/material.dart';
import 'package:rap_edit/utils/constants.dart';

class RecordingsPage extends StatelessWidget {
  const RecordingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recordings Page"),
      ),
      endDrawer: pagesDrawer,
      body: const Center(
        child: Text("Recordings"),
      ),
    );
  }
}
