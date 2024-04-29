import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vend_app/theme/theme_provider.dart';

class DarkModeToggleButton extends StatelessWidget {
  const DarkModeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ElevatedButton(
      onPressed: themeProvider.toggleTheme,
      child: Text(
        themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
      ),
    );
  }
}
