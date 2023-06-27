import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/direct_chat_screen.dart';
import 'package:rough_app/src/features/screens/group_chat_screen/group_chat_screen.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/features/screens/translate_screen/translate_screen.dart';

import '../screens/chat_screen/chat_screen.dart';

class HomeScreenController extends GetxController{

  static HomeScreenController get find => Get.find();

  goToPageFunc(key){
    debugPrint(key.toString());
    var ch = key.toString()[3].toUpperCase();
    if(ch == 'C'){
      Get.to(() => ChatScreen());
    }
    else if(ch == 'D'){
      Get.to(() => DirectChatScreen());
    }
    else if(ch == 'G'){
      Get.to(() => GroupChatScreen());
    }
    else if(ch == 'T'){
      Get.to(() => TranslateScreen());
    }
    else{
      Get.to(() => HomeScreen());
    }

  }

  goToHomePageFunc(){
    Get.back();
  }

  goBackOnePageFunc(){
    Get.back();
  }

}