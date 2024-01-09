import 'package:flutter/material.dart';

class Themes {
  static const Color red = Color(0xFFF44141);
  static const Color blue = Color(0xFF55a5d0);
  static const Color yellow = Color(0xFFe4ce9f);

  static ThemeData get lightTheme {
    ThemeData baseTheme = ThemeData.light(useMaterial3: true);
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
          elevation: 5,
          titleTextStyle: baseTheme.appBarTheme.titleTextStyle
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  static ThemeData get darkTheme {
    ThemeData baseTheme = ThemeData.dark(useMaterial3: true);
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
        elevation: 5,
        titleTextStyle: baseTheme.appBarTheme.titleTextStyle
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      listTileTheme: baseTheme.listTileTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
