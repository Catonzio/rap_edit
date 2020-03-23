import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/Trials/ChoosingBeatsDuration.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/pages/WelcomePage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:rap_edit/support/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/FileController.dart';
import 'pages/FileLoadingPage.dart';
import 'pages/WritingPage.dart';

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
    checkPermissions();
    return MaterialApp(
      initialRoute: initScreen == 0 || initScreen == null ? WelcomePage.routeName : WritingPage.routeName,
      routes: {
        FileLoadingPage.routeName: (context) => FileLoadingPage(),
        WritingPage.routeName: (context) => WritingPage(),
        ChoosingBeatsPage.routeName: (context) => ChoosingBeatsPage(),
        WelcomePage.routeName: (context) => WelcomePage(),
        TabbedLoading.routeName: (context) => TabbedLoading(),
        ChoosingBeatsDurationPage.routeName: (context) => ChoosingBeatsDurationPage()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: MyColors.electricBlue,
          accentColor: MyColors.electricBlue,
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: MyColors.textColor),
            title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: MyColors.textColor),
            subtitle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: MyColors.textColor),
            body1: TextStyle(fontSize: 20.0, color: MyColors.textColor),
          ),
      ),
    );
  }

  checkPermissions() async {
    final PermissionHandler permissionHandler = PermissionHandler();
    var result = await permissionHandler.requestPermissions([PermissionGroup.microphone]);
    var result2 = await permissionHandler.requestPermissions([PermissionGroup.storage]);
    var result3 = await permissionHandler.requestPermissions([PermissionGroup.mediaLibrary]);
  }
}