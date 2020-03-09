import 'package:flutter/material.dart';
import 'package:rap_edit/custom_widgets/AudioPlayerWidget.dart';

class ProvePage extends StatefulWidget {
  static String routeName = "/provePage";

  @override
  ProvePageState createState() => new ProvePageState();
}

class ProvePageState extends State<ProvePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
    );
  }
}