import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/direct_chat_screen.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/features/screens/splash_screen/splash_screen.dart';
import 'package:rough_app/src/utils/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: GAppTheme.lightTheme,
      darkTheme: GAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // home: SplashScreen(),
      // home: HomeScreen(),
      home: DirectChatScreen(),
    );

  }
}

