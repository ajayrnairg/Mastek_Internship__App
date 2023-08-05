import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rough_app/src/constants/image_strings.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/screens/chat_screen/chat_screen.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/direct_chat_screen.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/features/screens/rough_screen/rough_screen.dart';
import 'package:rough_app/src/features/screens/splash_screen/splash_screen.dart';
import 'package:rough_app/src/features/screens/translate_screen/translate_screen.dart';
import 'package:rough_app/src/features/screens/welcome_screen/welcome_screen.dart';
import 'package:rough_app/src/utils/helperfunctions/sharedpref_helper.dart';
import 'package:rough_app/src/utils/services/auth.dart';
import 'package:rough_app/src/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundMessageHandler);
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundMessageHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: GAppTheme.lightTheme,
      darkTheme: GAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home:
      FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot){
            if(snapshot.hasData){

              return  HomeScreen();

              // return TranslateScreen();
            }

            else{
              return
                 WelcomeScreen();
                 // SplashScreen();
              // ChatScreen();
            }

          }
      ),

      //  home: HomeScreen(),
      // home: DirectChatScreen(),
      // home: RoughScreen(title: "ABCD"),
    );

  }
}

