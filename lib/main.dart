import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rap_edit/controllers/FileController.dart';
import 'package:rap_edit/pages/ChoosingBeatsPage.dart';
import 'package:rap_edit/pages/TabbedLoading.dart';
import 'package:rap_edit/pages/Trials.dart';
import 'package:rap_edit/pages/WelcomePage.dart';
import 'package:rap_edit/pages/WritingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/FileLoadingPage.dart';
import 'pages/WritingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
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
        TabbedLoading.routeName: (context) => TabbedLoading()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Color(0xFF2C75FF),
          accentColor: Color(0xFF2C75FF),
          //fontFamily: 'Georgia',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0,),
            body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
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