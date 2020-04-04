import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/Trials/ChoosingBeatsDuration.dart';
import 'package:rap_edit/Trials/RegistrationsPageDuration.dart';
import 'package:rap_edit/controllers/ChoosingBeatsController.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/controllers/WritingPageController.dart';
import 'package:rap_edit/models/Dictionary.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/MixingAudioPage.dart';
import 'package:rap_edit/pages/WelcomePage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/FileController.dart';
import 'pages/RegistrationsPage.dart';
import 'pages/TextsPage.dart';
import 'pages/WritingPage.dart';

var initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  //to prevent landscape
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(PageMain());
  });
}

class PageMain extends StatelessWidget {
  static String routeName = "/main";

  @override
  Widget build(BuildContext context) {
    FileController.setDirectoryPath();
    Dictionary.instance.initializeWords();
    checkPermissions();
    return MaterialApp(
      initialRoute: initScreen == 0 || initScreen == null
          ? WelcomePage.routeName
          : WritingPage.routeName,
      routes: {
        WelcomePage.routeName: (context) => WelcomePage(),
        TextsPage.routeName: (context) => TextsPage(),
        WritingPage.routeName: (context) => ChangeNotifierProvider(
                                              create: (context) => WritingPageController(),
                                              child: WritingPage(),
                                            ),
        ChoosingBeatsPage.routeName: (context) => ChangeNotifierProvider(
                                                    create: (context) => ChoosingBeatsController(),
                                                    child: ChoosingBeatsPage(),
                                                  ),
        MixingAudioPage.routeName: (context) => MixingAudioPage(),
        RegistrationsPage.routeName: (context) => RegistrationsPage(),
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: MyColors.electricBlue,
          accentColor: MyColors.electricBlue,
          fontFamily: 'Montserrat',
      ),
    );
  }

  checkPermissions() async {
    final PermissionHandler permissionHandler = PermissionHandler();
    await permissionHandler.requestPermissions([PermissionGroup.microphone]);
    await permissionHandler.requestPermissions([PermissionGroup.storage]);
    await permissionHandler.requestPermissions([PermissionGroup.mediaLibrary]);
  }
}