import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vend_app/theme/theme_provider.dart';

class DarkModeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return TextButton(
      onPressed: themeProvider.toggleTheme,
      child: Text(
        themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
      ),
    );
  }
}
