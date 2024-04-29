import 'package:flutter/material.dart';

const Color vendAppWhite = Color(0xFFF6F6F3);
const Color vendAppBlack = Color(0xFF040404);
const Color vendAppBlue = Color(0xFF0C7489);

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      background: vendAppWhite,
      primary: Colors.purple.shade300,
      secondary: Colors.purple.shade200),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      background: vendAppBlack,
      primary: Colors.green.shade800,
      secondary: Colors.green.shade700),
);
