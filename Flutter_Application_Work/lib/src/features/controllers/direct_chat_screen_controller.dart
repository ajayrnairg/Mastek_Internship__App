import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/direct_chat_main_screen.dart';

class DirectChatScreenController extends GetxController {
  static DirectChatScreenController get find => Get.find();

  List<Map<String, String>> sendMsgs = [
    {"who": "a", "what": "hello"},
    {"who": "a", "what": "hi"},
    {"who": "a", "what": "bye"},
    {"who": "a", "what": "Welcome"},
    {"who": "a", "what": "Thank You"},
    {"who": "a", "what": "Namaste"},
    {"who": "a", "what": "What's App"}
  ];
  List<Map<String, String>> receiveMsgs = [
    {"who": "b", "what": "bye"},
    {"who": "b", "what": "hello"},
    {"who": "b", "what": "hi"},
    {"who": "b", "what": "Thank You"},
    {"who": "b", "what": "Welcome"},
    {"who": "b", "what": "What's App"},
    {"who": "b", "what": "Namaste"},
  ];
  List<Map<String, String>> combineMsgs = [
    {
      "who": "a",
      "what": "bye WelcomeWelcomeWelcomeWelcome ",
      "time": "21:30:10"
    },
    {"who": "b", "what": "hello", "time": "02:05:40"},
    {
      "who": "a",
      "what":
      "Thank YouThank YouThank YouThank YouThank YouThank YouThank YouThank YouThank YouThank YouThank YouThank You",
      "time": "06:10:05"
    },
    {
      "who": "b",
      "what": "Thank You WelcomeWelcomeWelcomeWelcome",
      "time": "11:25:50"
    },
    {"who": "a", "what": "Namaste Namaste Namaste Namaste", "time": "14:20:55"},
    {
      "who": "b",
      "what":
      "WelcomeWelcomeWelcomeWelcomeWelcomeWelcomeWelcomeWelcomeWelcomeWelcomeWelcomeWelcome",
      "time": "23:59:59"
    },
    {"who": "a", "what": "What's App", "time": "06:10:05"},

    {"who": "b", "what": "bye hello hi hi", "time": "14:20:55"},

    {"who": "a", "what": "hello hi hi hi", "time": "09:15:30"},
    {"who": "b", "what": "Namaste", "time": "18:55:15"},
    {"who": "a", "what": "hi bye bye bye bye", "time": "12:00:00"},
    {"who": "b", "what": "What's App", "time": "02:05:40"},
    {"who": "a", "what": "WelcomeWelcomeWelcomeWelcome", "time": "16:45:20"},
    {"who": "b", "what": "WelcomeWelcomeWelcomeWelcome hi", "time": "18:55:15"},


  ];

  TextEditingController messageTextEditingController = TextEditingController();

  goToDirectMainChatFunc(selectedLang1, selectedLang2) {
    Get.to(() => DirectChatMainScreen(
        selectedLang1: selectedLang1, selectedLang2: selectedLang2));
  }

  addMessage() {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      debugPrint(message);
      Map<String, String> mapInstance = {
        "who": "b",
        "what": "${message}",
        "time":
        "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}"
      };
      combineMsgs.insert(0, mapInstance);
      debugPrint(mapInstance.toString());
      debugPrint(combineMsgs.toString());
    }
    messageTextEditingController.text = "";
  }
}
