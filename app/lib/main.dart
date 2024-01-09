import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rap_edit/configs/pages.dart';
import 'package:rap_edit/configs/routes.dart';
import 'package:rap_edit/configs/themes.dart';
import 'package:rap_edit/data/bindings/splash_bindings.dart';
import 'package:rap_edit/ui/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init("Lyrics");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      theme: Themes.darkTheme,
      defaultTransition: Transition.fade,
      initialBinding: SplashBindings(),
      getPages: Pages.pages,
      home: const SplashPage(),
    );
  }
}
