import 'dart:ui';

import 'package:flutter/material.dart';

class MyColors {
  
  static Color primaryColor = electricBlue.withOpacity(0.5);
  static Color secondaryColor = softPurple;
  static Color endElementColor = Color(0xFF000000).withOpacity(0.5);

  static Color backGroundGrey = Color(0xFF202020);
  static Color backGroundWhite = Color(0xFF303030).withOpacity(0.5);

  static Color electricBlue = Color(0xFF2C75FF);
  static Color darkGrey = Color(0xFF151515);
  static Color darkRed = Color(0xFF8B0000);
  static Color textColor = Color(0xFFFFFFFF);
  static Color softGrey = Colors.grey[800];
  static Color softPurple = Color(0xFF7030A0);
  static Color deepPurpleOpac = Color(0xFF1A113D).withOpacity(0.5);
  static Color deepPurpleAlert = Color(0xFF171033);

  static Color startAppBar = primaryColor;
  static Color endAppBar = endElementColor;
}