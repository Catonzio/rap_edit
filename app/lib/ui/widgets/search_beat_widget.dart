import 'package:flutter/material.dart';
import 'package:rap_edit/data/controllers/pages_controllers/beats_controller.dart';

class SearchBeatWidget extends StatelessWidget {
  final BeatsController controller;

  const SearchBeatWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: TextField(
          maxLines: 1,
          controller: controller.searchController,
          onChanged: (value) {
            controller.searchString = value;
            controller.searchController.text = value;
          },
          decoration: const InputDecoration(
            hintText: "Search",
            suffixIcon: Icon(Icons.search),
          )),
    );
  }
}
