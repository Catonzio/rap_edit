import 'package:get/get.dart';
import 'package:rap_edit/data/bindings/beats_bindings.dart';
import 'package:rap_edit/data/bindings/home_bindings.dart';
import 'package:rap_edit/data/bindings/lyrics_bindings.dart';
import 'package:rap_edit/data/bindings/settings_bindings.dart';
import 'package:rap_edit/data/bindings/splash_bindings.dart';
import 'package:rap_edit/ui/pages/about_page.dart';
import 'package:rap_edit/ui/pages/beats/beats_page.dart';
import 'package:rap_edit/ui/pages/home_page.dart';
import 'package:rap_edit/ui/pages/lyrics_page.dart';
import 'package:rap_edit/ui/pages/mixed_songs_page.dart';
import 'package:rap_edit/ui/pages/mixer_page.dart';
import 'package:rap_edit/ui/pages/recordings_page.dart';
import 'package:rap_edit/ui/pages/settings_page.dart';
import 'package:rap_edit/ui/pages/splash_page.dart';

import 'routes.dart';

class Pages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: Routes.writing,
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.lyrics,
      page: () => const LyricsPage(),
      binding: LyricsBindings(),
    ),
    GetPage(
      name: Routes.beats,
      page: () => const BeatsPage(),
      binding: BeatsBindings(),
    ),
    GetPage(
      name: Routes.recordings,
      page: () => const RecordingsPage(),
      binding: BeatsBindings(),
    ),
    GetPage(
      name: Routes.mix,
      page: () => const MixerPage(),
      // binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.mixedSongs,
      page: () => const MixedSongsPage(),
      // binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutPage(),
    )
  ];
}
