import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/data/controllers/pages_controllers/settings_controller.dart';
import 'package:rap_edit/ui/widgets/tiles/basic_tile.dart';
import 'package:rap_edit/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: Row(children: [
              const Text("Settings Page"),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => saveSettings(context, controller),
                tooltip: "Save Settings",
              )
            ]),
          ),
          endDrawer: pagesDrawer,
          body: SafeArea(
              child: Column(
            children: [
              BasicTile(
                title: const Text("Dark Mode"),
                trailing: Switch(
                  value: controller.isDarkMode,
                  onChanged: controller.setIsDarkMode,
                ),
              )
            ],
          )));
    });
  }

  Future<void> saveSettings(
      BuildContext context, SettingsController controller) async {
    bool saved = await controller.saveSetting();
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
    }
  }
}
