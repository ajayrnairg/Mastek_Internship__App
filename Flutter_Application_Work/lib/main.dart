import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/direct_chat_screen.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/features/screens/rough_screen/rough_screen.dart';
import 'package:rough_app/src/features/screens/splash_screen/splash_screen.dart';
import 'package:rough_app/src/features/screens/welcome_screen/welcome_screen.dart';
import 'package:rough_app/src/utils/services/auth.dart';
import 'package:rough_app/src/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: GAppTheme.lightTheme,
      darkTheme: GAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home:
      FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData){
              return  HomeScreen();
            }
            else{
              return WelcomeScreen();
                // SplashScreen();
            }
          }
      ),

      //  home: HomeScreen(),
      // home: DirectChatScreen(),
      // home: RoughScreen(title: "ABCD"),
    );

  }
}

