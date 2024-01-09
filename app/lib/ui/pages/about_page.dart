import 'package:flutter/material.dart';
import 'package:rap_edit/utils/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("About Page"),
        ),
        endDrawer: pagesDrawer,
        body: const SafeArea(
          child: Center(child: Text("Hello")),
        ));
  }
}
