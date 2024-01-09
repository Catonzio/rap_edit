import 'package:flutter/material.dart';
import 'package:rap_edit/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings Page"),
        ),
        endDrawer: pagesDrawer,
        body: const SafeArea(
          child: Center(child: Text("Hello")),
        ));
  }
}
