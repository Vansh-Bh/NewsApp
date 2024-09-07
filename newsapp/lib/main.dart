import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsapp/pages/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newsapp/services/theme_changer.dart';

void main() async {
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService());

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App',
          themeMode: themeService.theme,
          theme: MyAppThemes.lightTheme,
          darkTheme: MyAppThemes.darkTheme,
          home: const Home(),
        ));
  }
}
