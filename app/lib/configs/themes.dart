import 'package:flutter/material.dart';

class Themes {
  static const Color red = Color.fromARGB(255, 139, 4, 4);
  static const Color blue = Color.fromARGB(255, 35, 35, 216);

  static const AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.red,
    elevation: 1,
  );

  static ThemeData lightTheme = ThemeData.light();
  static ThemeData get darkTheme {
    ThemeData baseTheme = ThemeData.dark(useMaterial3: true);
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
          elevation: 2,
          titleTextStyle: baseTheme.appBarTheme.titleTextStyle
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
