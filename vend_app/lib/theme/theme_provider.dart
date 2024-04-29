import 'package:flutter/material.dart';
import 'package:vend_app/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Initial state: light mode

  ThemeData get themeData => _isDarkMode ? darkMode : lightMode;

  bool get isDarkMode => _isDarkMode; // Getter for easier access

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
