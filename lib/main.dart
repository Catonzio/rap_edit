import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rap_edit/Trials/ChoosingBeatsDuration.dart';
import 'package:rap_edit/Trials/RegistrationsPageDuration.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/models/Dictionary.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/pages/WelcomePage.dart';
import 'package:rap_edit/pages/WritingPage/WritingPage.dart';
import 'package:rap_edit/pages/WritingPage/WritingPageController.dart';
import 'package:rap_edit/support/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/FileController.dart';
import 'pages/FileLoadingPage.dart';
import 'pages/WritingPage/WritingPage.dart';

var initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  runApp(PageMain());
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
        FileLoadingPage.routeName: (context) => FileLoadingPage(),
        WritingPage.routeName: (context) => ChangeNotifierProvider(
                                              create: (context) => WritingPageController(),
                                              child: WritingPage(),
                                            ),
        //WritingPage.routeName: (context) => WritingPage(),
        ChoosingBeatsPage.routeName: (context) => ChoosingBeatsPage(),
        WelcomePage.routeName: (context) => WelcomePage(),
        //TabbedLoading.routeName: (context) => TabbedLoading(),
        ChoosingBeatsDurationPage.routeName: (context) => ChoosingBeatsDurationPage(),
        RegistrationsPageDuration.routeName: (context) => RegistrationsPageDuration(),
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