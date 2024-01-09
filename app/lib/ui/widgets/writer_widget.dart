import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/controllers/writer_controller.dart';

class WriterWidget extends StatelessWidget {
  final double width;
  final double height;

  const WriterWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final WriterController controller = WriterController.to;
    return SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => controller.isLyricLoaded
                        ? Text("Title: ${controller.currentLyric.title}")
                        : const Text("No lyric loaded"),
                  ),
                  TextButton(
                      onPressed: controller.newLyric,
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          Text("New lyric"),
                        ],
                      ))
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => controller.emptyText(),
                    icon: const Icon(Icons.delete_forever),
                    color: Themes.red,
                    tooltip: "Delete all lyric",
                  ),
                ),
                const Expanded(
                  flex: 8,
                  child: Row(children: []),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SaveTextDialog(controller: controller);
                          });
                    },
                    icon: const Icon(Icons.save),
                    color: Themes.blue,
                    tooltip: "Save lyric",
                  ),
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: controller.textEditingController,
                minLines: 100,
                maxLines: null,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Write your lyrics here",
                    alignLabelWithHint: true),
              ),
            ),
          ],
        ));
  }
}

class SaveTextDialog extends StatelessWidget {
  final WriterController controller;
  final _formKey = GlobalKey<FormState>();

  SaveTextDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Save your lyric"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: controller.titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Title",
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Insert a title";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("No")),
        TextButton(onPressed: () => saveText(context), child: const Text("Ok")),
      ],
    );
  }

  Future<void> saveText(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      bool saved = await controller.saveText();
      if (context.mounted) {
        ScaffoldMessengerState state = ScaffoldMessenger.of(context);
        state.showSnackBar(
          SnackBar(
            content: Text(saved ? 'Saved' : 'Error'),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: "Ok",
              onPressed: () => state.hideCurrentSnackBar(),
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
