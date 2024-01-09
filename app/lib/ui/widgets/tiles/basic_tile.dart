import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  const BasicTile(
      {super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
          horizontal: context.width * 0.05, vertical: context.height * 0.01),
      child: ListTile(
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
