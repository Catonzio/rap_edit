import 'package:flutter/material.dart';

class Themes {
  static const Color red = Color(0xFFF44141);
  static const Color blue = Color(0xFF55a5d0);
  static const Color yellow = Color(0xFFe4ce9f);

  static const AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.red,
    elevation: 1,
  );

  static ThemeData get lightTheme {
    ThemeData baseTheme = ThemeData.light(useMaterial3: true);
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
          elevation: 2,
          titleTextStyle: baseTheme.appBarTheme.titleTextStyle
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  static ThemeData get darkTheme {
    ThemeData baseTheme = ThemeData.dark(useMaterial3: true);
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
          elevation: 2,
          titleTextStyle: baseTheme.appBarTheme.titleTextStyle
              ?.copyWith(fontWeight: FontWeight.bold)),
      // tooltipTheme: baseTheme.tooltipTheme.copyWith(
      //   textStyle: baseTheme.tooltipTheme.textStyle?.copyWith(
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //   ),
      //   decoration: BoxDecoration(
      //     color: Colors.black,
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      // ),
    );
  }
}
