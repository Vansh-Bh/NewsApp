import 'package:flutter/material.dart';
import 'package:newsapp/pages/home.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatelessWidget {
  // const ChangeThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
        value: themeProvider.isDarkMode,
        activeColor: Colors.blue[600],
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        });
  }
}
