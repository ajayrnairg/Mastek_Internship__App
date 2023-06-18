import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../screens/login_screen/login_screen.dart';
import '../screens/signup_screen/signup_screen.dart';



class WelcomeScreenController extends GetxController{
  static WelcomeScreenController get find => Get.find();



  signUpFunc() {
    Get.to(() => SignUpScreen());
  }

  logInFunc() {
    Get.to(() => LogInScreen());
  }





}