import 'package:flutter/material.dart';
import 'package:newsapp/pages/home.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'News App',
            themeMode: themeProvider.themeMode,
            theme: MyAppThemes.lightTheme,
            darkTheme: MyAppThemes.darkTheme,
            home: Home(),
          );
        },
      );
}
