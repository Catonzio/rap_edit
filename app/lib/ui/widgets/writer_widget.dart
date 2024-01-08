import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/controllers/writer_controller.dart';

class WriterWidget extends StatelessWidget {
  final WriterController controller = Get.find<WriterController>();
  final double width;
  final double height;

  WriterWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => controller.emptyText(),
                    icon: const Icon(Icons.delete_forever),
                    color: Themes.red,
                  ),
                ),
                const Expanded(
                  flex: 8,
                  child: Row(children: []),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => controller.saveText(),
                    icon: const Icon(Icons.save),
                    color: Themes.blue,
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
                  hintText: "Write your lyrics here",
                ),
              ),
            ),
          ],
        ));
  }
}
