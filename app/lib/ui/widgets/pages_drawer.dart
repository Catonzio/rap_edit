import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/data/controllers/domain_controllers/beat_preview_controller.dart';
import 'package:rap_edit/data/controllers/pages_controllers/home_controller.dart';
import 'package:rap_edit/utils/extensions/context_extension.dart';

class PagesDrawer extends StatelessWidget {
  const PagesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? "";
    return SizedBox(
      width: (context.width * 0.5).clamp(150, 300),
      child: Drawer(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: (context.height * 0.2)
                    .clamp(50, context.mediaQueryPadding.top + 161),
                child: DrawerHeader(
                  decoration:
                      BoxDecoration(color: context.theme.colorScheme.primary),
                  child: AutoSizeText(
                    "RapEdit",
                    style: context.textTheme.headlineLarge!.copyWith(
                        color: context.theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    DrawerItem(
                      icon: Icons.draw,
                      title: "Writing",
                      route: Routes.writing,
                      isSelected: currentRoute == Routes.writing,
                    ),
                    Divider(),
                    DrawerItem(
                      icon: Icons.queue_music,
                      title: "Load beat",
                      route: Routes.beats,
                      isSelected: currentRoute == Routes.beats,
                    ),
                    DrawerItem(
                      icon: Icons.upload_file,
                      title: "Load lyric",
                      route: Routes.lyrics,
                      isSelected: currentRoute == Routes.lyrics,
                    ),
                    DrawerItem(
                      icon: Icons.spatial_audio_off,
                      title: "Load recs",
                      route: Routes.recordings,
                      isSelected: currentRoute == Routes.recordings,
                    ),
                    Divider(),
                    DrawerItem(
                      icon: Icons.multitrack_audio,
                      title: "Mix audio",
                      route: Routes.mix,
                      isSelected: currentRoute == Routes.mix,
                    ),
                    DrawerItem(
                      icon: Icons.mic_external_on_rounded,
                      title: "Mixed songs",
                      route: Routes.mixedSongs,
                      isSelected: currentRoute == Routes.mixedSongs,
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              const Divider(thickness: 5),
              DrawerItem(
                icon: Icons.settings,
                title: "Settings",
                route: Routes.settings,
                isSelected: currentRoute == Routes.settings,
              ),
              DrawerItem(
                icon: Icons.info,
                title: "About",
                route: Routes.about,
                isSelected: currentRoute == Routes.about,
              ),
            ],
          )),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isSelected;

  const DrawerItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.route,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected
          ? context.theme.colorScheme.primary.withOpacity(0.2)
          : null,
      leading: Icon(icon),
      title: AutoSizeText(
        title,
        maxLines: 1,
      ),
      onTap: () {
        if (route == Routes.writing) {
          if (context.mounted) {
            context.navigator.pushNamedAndRemoveUntil(
                route, ModalRoute.withName(Routes.writing));
          }
        } else {
          if (Get.currentRoute == Routes.beats) {
            BeatPreviewController.to.pause();
          }
          if (Get.currentRoute == Routes.writing) {
            HomeController.to.pauseSong();
            context.navigator.pop();
          }
          // Get.toNamed(route)?.then((value) => Get.back());
          if (context.mounted) {
            context.navigator.pushNamed(route).then((value) {
              if (context.mounted) {
                context.navigator.pop();
              }
            });
          }
        }
        // Navigator.pop(context);
        // Navigator.pushNamed(context, route);
      },
    );
  }
}
