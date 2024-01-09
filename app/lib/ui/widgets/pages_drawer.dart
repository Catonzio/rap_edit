import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/beat_preview_controller.dart';

class PagesDrawer extends StatelessWidget {
  const PagesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: context.theme.colorScheme.primary),
              child: Text(
                "RapEdit",
                style: context.textTheme.headlineLarge!.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const DrawerItem(
              icon: Icons.draw,
              title: "Writing",
              route: Routes.writing,
            ),
            const Divider(),
            const DrawerItem(
              icon: Icons.queue_music,
              title: "Load beat",
              route: Routes.beats,
            ),
            const DrawerItem(
              icon: Icons.upload_file,
              title: "Load lyric",
              route: Routes.lyrics,
            ),
            const DrawerItem(
              icon: Icons.spatial_audio_off,
              title: "Load recs",
              route: Routes.writing,
            ),
            const Divider(),
            const DrawerItem(
              icon: Icons.multitrack_audio,
              title: "Mix audio",
              route: Routes.writing,
            ),
            const DrawerItem(
              icon: Icons.mic_external_on_rounded,
              title: "Mixed songs",
              route: Routes.writing,
            ),
            const Spacer(),
            const Divider(thickness: 5),
            const DrawerItem(
              icon: Icons.settings,
              title: "Settings",
              route: "/settings",
            ),
            const DrawerItem(
              icon: Icons.info,
              title: "About",
              route: "/about",
            ),
          ],
        ));
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const DrawerItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (route == Routes.writing) {
          Get.offAllNamed(route,
              predicate: ModalRoute.withName(Routes.writing));
          // Get.offAndToNamed(route);
        } else {
          if (Get.currentRoute == Routes.beats) {
            BeatPreviewController.to.pause();
          }
          Get.toNamed(route)?.then((value) => Get.back());
        }
        // Navigator.pop(context);
        // Navigator.pushNamed(context, route);
      },
    );
  }
}
