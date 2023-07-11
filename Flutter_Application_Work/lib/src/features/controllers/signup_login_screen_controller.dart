import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rough_app/src/features/screens/home_screen/home_screen.dart';
import 'package:rough_app/src/features/screens/login_screen/login_screen.dart';
import 'package:rough_app/src/features/screens/signup_screen/signup_screen.dart';



class SignupLoginScreenController extends GetxController {

  static SignupLoginScreenController get find => Get.find();


  goToLoginPageFunc(){
    Get.off(() => const LogInScreen());
  }

  goToSignupPageFunc(){
    Get.off(() => const SignUpScreen());
  }

  goToHomePageFunc(){
    Get.offAll(() =>  HomeScreen());
  }

}