import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}